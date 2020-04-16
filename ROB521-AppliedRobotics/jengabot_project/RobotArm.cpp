#include <stdio.h>
#include <math.h>
#include <algorithm>
#include "RobotArm.h"
#include <sys/time.h>

using namespace std;

RobotArm::RobotArm(vector<float> init_theta)
{
   current_thetas = init_theta;
   prev_thetas = current_thetas;
   for (int i = 0; i < 5; i++)
      theta_dot.push_back(0.0f);

   gettimeofday(&last_time, NULL);

   //base
   Point3D base_point;
   base_point.x_m = 0.0;
   base_point.y_m = 0.0;
   base_point.z_m = 0.0;
   //create empty joints for now
   for (int i = 0; i <= NUM_JOINTS; i++)
      base_pts.push_back(base_point);


   //a, alpha, d, theta
   DH_Params dh_1(0.0, -PI/2, m_fLink1_Length_m, current_thetas[0]);
   Link link1(dh_1, -PI/2, PI/2, 0.5, 1.5, 0.05);

   DH_Params dh_2(m_fLink2_Length_m, -PI/2, 0.0, current_thetas[1]);
   Link link2(dh_2, -PI, 0, 0.75, 1.5, 0.05);

   DH_Params dh_3(0.0, PI/2, m_fLink3_Length_m, 0.0); //fixed frame
   Link link3(dh_3, 0.0, 0.0, 0.0, 0.0, 0.05);

   DH_Params dh_4(m_fLink4_Length_m, 0.0, 0.0, current_thetas[2]);
   Link link4(dh_4, 0.0, PI, 1.0, 3.0, 0.05);

   DH_Params dh_5(m_fLink5_Length_m, PI/2, 0.0, current_thetas[3]);
   Link link5(dh_5, -PI/2, PI/4.0, 1.5, 4.5, 0.05);

   DH_Params dh_6(m_fLink6_Length_m, 0.0, m_fLink6_zOffset_m, current_thetas[4]);
   Link link6(dh_6, -3*PI/4, 3*PI/4, 2.0, 6.0, 0.05);

   links.push_back(link1);
   links.push_back(link2);
   links.push_back(link3);
   links.push_back(link4);
   links.push_back(link5);
   links.push_back(link6);

   Update(current_thetas);

}

void RobotArm::Update(vector<float> thetas)
{
   static bool bFirst = true;
   struct timeval cur_time;
   gettimeofday(&cur_time, NULL);
   time_step = float(cur_time.tv_sec - last_time.tv_sec) + float(cur_time.tv_usec - last_time.tv_usec)/1E6;
   last_time = cur_time;

   float vel_lp_gain = 0.2;

   prev_thetas = current_thetas;
   current_thetas = thetas;

   if (!bFirst)
   {
      for (int i = 0; i < 5; i++)
      {
         float vel_rps = (current_thetas[i] - prev_thetas[i])/time_step;
         theta_dot[i] = (1-vel_lp_gain)*theta_dot[i] + vel_lp_gain*vel_rps;
      }
   }
   bFirst = false;

   int j = 0;
   for (int i = 0; i < NUM_JOINTS; i++)
   {
      if (i == 2)
         continue;
      links[i].joint.update(thetas[j]);
      j++;
   }
   vector<vector<float>> T = links.front().joint.A;
   for (int i = 1; i < NUM_JOINTS; i++)
   {
      base_pts[i].x_m = T[0][3];
      base_pts[i].y_m = T[1][3];
      base_pts[i].z_m = T[2][3];
      T = MatrixMultiply(T, links[i].joint.A);
   }
   base_pts[NUM_JOINTS].x_m = T[0][3];
   base_pts[NUM_JOINTS].y_m = T[1][3];
   base_pts[NUM_JOINTS].z_m = T[2][3];
}

vector<float> RobotArm::GetJointVels()
{
   return theta_dot;
}

RET_CODE RobotArm::InverseKinematics_XY(Point3D ef_pt, float yaw, vector<float>* inv_thetas)
{

  vector<float> thetas(5);

  Point3D p5;
  p5.x_m = ef_pt.x_m - m_fLink6_Length_m*cos(yaw);
  p5.y_m = ef_pt.y_m - m_fLink6_Length_m*sin(yaw);
//  printf("p5 pose: %f, %f\n", p5.x_m, p5.y_m);
  thetas[0] = atan2(p5.y_m, p5.x_m);
//  printf("theta0: %f\n", thetas[0]);
  thetas[4] = 0.0 + yaw - thetas[0]; //refer to how theta is defined
//  printf("theta4: %f\n", thetas[4]);

  Point3D p4;
  p4.x_m = p5.x_m - m_fLink5_Length_m*cos(thetas[0]);
  p4.y_m = p5.y_m - m_fLink5_Length_m*sin(thetas[0]);
  p4.z_m = ef_pt.z_m - m_fLink6_zOffset_m;
//  printf("p4 pose: %f, %f, %f\n", p4.x_m, p4.y_m, p4.z_m);

  float alpha = atan2(m_fLink3_Length_m, m_fLink2_Length_m);
//  printf("alpha: %f\n", alpha);
  float dz = p4.z_m - m_fLink1_Length_m;
  float r = sqrt(pow(p4.x_m,2) + pow(p4.y_m,2));
//  printf("dz: %f, r: %f\n", dz, r);

  float D_num = (pow(r,2) + pow(dz,2) - pow(m_fLink2_Length_m,2) - pow(m_fLink3_Length_m,2) - pow(m_fLink4_Length_m,2));
  float a2_star = sqrt(pow(m_fLink2_Length_m,2)+pow(m_fLink3_Length_m,2));
  float D_den = 2*a2_star*m_fLink4_Length_m;
  float D = D_num/D_den;
//  printf("num, den, a2, D: %f, %f, %f, %f\n", D_num, D_den, a2_star, D);

  if (abs(D) > 0.999)
     return ECODE_ERROR;

  float t3_star = atan2(sqrt(1 - pow(D,2)),D);
  if (t3_star - alpha < 0)
     t3_star = atan2(-sqrt(1 - pow(D,2)),D);

  float t1_1 = atan2(r,dz);
  float t1_2 = atan2(m_fLink4_Length_m*sin(t3_star),(a2_star + m_fLink4_Length_m*cos(t3_star)));

//  printf("%f, %f\n", t1_1, t1_2);

  float t3 = t3_star + alpha;
  float t1 = t1_1 - t1_2 - alpha;
  float t4 = PI/2 - t1 - t3;

  thetas[1] = t1-PI/2;
  thetas[2] = t3;
  thetas[3] = t4;

  for (int i = 0; i < 5; i++)
  {
    int j = i;
    if (i >= 2)
       j++;
    if (thetas[i] < links[j].joint.min_theta || thetas[i] > links[j].joint.max_theta)
    {
      printf("theta %d past limits! %f | %f,%f\n",i,thetas[i],links[j].joint.min_theta, links[j].joint.max_theta); 
      return ECODE_ERROR;
    }
  }

  (*inv_thetas) = thetas;


//  vector<Link> temp_links = links;
//  vector<Point3D> temp_pts = base_pts;

//   int j = 0;
//   for (int i = 0; i < NUM_JOINTS; i++)
//   {
//      if (i == 2)
//         continue;
//      temp_links[i].joint.update(thetas[j]);
//      j++;
//   }
//   vector<vector<float>> T = temp_links.front().joint.A;
//   for (int i = 1; i < NUM_JOINTS; i++)
//   {
//      temp_pts[i].x_m = T[0][3];
//      temp_pts[i].y_m = T[1][3];
//      temp_pts[i].z_m = T[2][3];
//      T = MatrixMultiply(T, temp_links[i].joint.A);
//   }
//   temp_pts[NUM_JOINTS].x_m = T[0][3];
//   temp_pts[NUM_JOINTS].y_m = T[1][3];
//   temp_pts[NUM_JOINTS].z_m = T[2][3];

  // for (int i = 0; i <= NUM_JOINTS; i++)
  // {
  //    printf("Joint %d Target Pose (Global): (%f,%f,%f)\n", i, temp_pts[i].x_m,  temp_pts[i].y_m, temp_pts[i].z_m + 0.015);
  // }


  return ECODE_NO_ERROR;
}

float RobotArm::ClipTheta(float theta, int joint)
{
   if (joint >= 2)
      joint++;
   theta = max(theta,links[joint].joint.min_theta);
   theta = min(theta,links[joint].joint.max_theta);
   return theta;
}

float RobotArm::GetJointViolationDistance(int joint_num, float theta)
{
   if (links[joint_num].joint.min_theta > theta)
      return links[joint_num].joint.min_theta - theta;
   if (links[joint_num].joint.max_theta < theta)
      return theta - links[joint_num].joint.max_theta;
   return 0.0;
}

vector<BoundingSphere> RobotArm::GetAllSurfaceSpheres() {

   vector<BoundingSphere> joint_surface;
   for (int i = 1; i <= NUM_JOINTS; i++)
   {
      float dX = base_pts[i].x_m-base_pts[i-1].x_m;
      float dY = base_pts[i].y_m-base_pts[i-1].y_m;
      float dZ = base_pts[i].z_m-base_pts[i-1].z_m;
      float total_dist = sqrt(pow(dX,2)+pow(dY,2)+pow(dZ,2));
      int nNumSpheres = 1 + int((total_dist+sphere_spacing/4)/sphere_spacing);
      float radius = links[i-1].link_width/2;
      for (int j = 0; j < nNumSpheres; j++)
      {
         BoundingSphere glob_sphere;
         glob_sphere.center.x_m = base_pts[i-1].x_m + float(j)*sphere_spacing*(dX/total_dist);
         glob_sphere.center.y_m = base_pts[i-1].y_m + float(j)*sphere_spacing*(dY/total_dist);
         glob_sphere.center.z_m = base_pts[i-1].z_m + float(j)*sphere_spacing*(dZ/total_dist);
         if (i == NUM_JOINTS)
         {
            float dist_to_ef = 0;
            dist_to_ef += pow(base_pts[i].x_m - glob_sphere.center.x_m,2);
            dist_to_ef += pow(base_pts[i].y_m - glob_sphere.center.y_m,2);
            dist_to_ef += pow(base_pts[i].z_m - glob_sphere.center.z_m,2);
            dist_to_ef = sqrt(dist_to_ef);
            radius = min(links[i-1].link_width/2, dist_to_ef);
         }
         glob_sphere.radius = radius;
         joint_surface.push_back(glob_sphere);
      }
   }
   return joint_surface;
}

Point3D RobotArm::Rotate(vector<vector<float>> m1, Point3D offset)
{
   Point3D res;
   res.x_m = m1[0][3] + m1[0][0]*offset.x_m + m1[0][1]*offset.y_m + m1[0][2]*offset.z_m;
   res.y_m = m1[1][3] + m1[1][0]*offset.x_m + m1[1][1]*offset.y_m + m1[1][2]*offset.z_m;
   res.z_m = m1[2][3] + m1[2][0]*offset.x_m + m1[2][1]*offset.y_m + m1[2][2]*offset.z_m;
   return res;
}

float RobotArm::GetSphereDistanceToTower(BoundingSphere sphere, Pose2D tower_pose)
{
   Point3D glob_point = sphere.center;
   float dX = glob_point.x_m - tower_pose.x_m;
   float dY = glob_point.y_m - tower_pose.y_m;
   Point3D local_point;//in tower frame
   local_point.x_m = dX*fastcos(tower_pose.yaw_rad) + dY*fastsin(tower_pose.yaw_rad);
   local_point.y_m = dY*fastcos(tower_pose.yaw_rad) - dX*fastsin(tower_pose.yaw_rad);
   local_point.z_m = glob_point.z_m;

   return GetDistanceToTowerLocal(local_point) - sphere.radius;
}

float RobotArm::GetDistanceToTower(Pose2D tower_pose)
{

   vector<BoundingSphere> joint_surface = GetAllSurfaceSpheres();

   float min_dist = 1000;

   for (int i = 0; i < joint_surface.size(); i++)
   {
      Point3D glob_point = joint_surface[i].center;
      float dX = glob_point.x_m - tower_pose.x_m;
      float dY = glob_point.y_m - tower_pose.y_m;
      Point3D local_point;//in tower frame
      local_point.x_m = dX*cos(tower_pose.yaw_rad) + dY*sin(tower_pose.yaw_rad);
      local_point.y_m = dY*cos(tower_pose.yaw_rad) - dX*sin(tower_pose.yaw_rad);
      local_point.z_m = glob_point.z_m;

      float dist = GetDistanceToTowerLocal(local_point) - joint_surface[i].radius;
      if (dist < min_dist)
         min_dist = dist;

//      printf("%f, %f\n", local_point.x_m, local_point.y_m);
      printf("%f, %f, %f, %f\n",glob_point.x_m, glob_point.y_m, glob_point.z_m, dist);
   }
   return min_dist;
}

Point3D RobotArm::GetEndEffectorPose()
{
   return base_pts[NUM_JOINTS];
 //  vector<vector<float>> T = links.front().joint.A;
 //  for (int i = 1; i < NUM_JOINTS; i++)
 //  {
 //     T = MatrixMultiply(T, links[i].joint.A);
 //  }
 //  Pose6D ef_pose;
 //  ef_pose.R = ExtractRotMatrix(T);
 //  ef_pose.pos.x_m = T[0][3];
 //  ef_pose.pos.y_m = T[1][3];
 //  ef_pose.pos.z_m = T[2][3];

 //  return ef_pose;
}

vector<vector<float>> RobotArm::ExtractRotMatrix(vector<vector<float>> T)
{
   vector<vector<float>> res;
   vector<float> temp(3);
   for (int i = 0; i < 3; i++)
      res.push_back(temp);

   for (int i = 0; i < 3; i++)
      for (int j = 0; j < 3; j++)
         res[i][j] = T[i][j];

   return res;
}

vector<vector<float>> RobotArm::MatrixMultiply(vector<vector<float>> m1, vector<vector<float>> m2)
{
   vector<vector<float>> res = m1;

   for (int i = 0; i < res.size(); i++)
      for (int j = 0; j < res[0].size(); j++)
         for (int r = 0; r < m2.size(); r++)
         {
            if (r == 0)
               res[i][j] = 0;
            res[i][j] += m1[i][r]*m2[r][j];
         }
   return res;
}

vector<vector<float>> RobotArm::Transpose(vector<vector<float>> m)
{
   vector<vector<float>> res = m;

   for (int i = 0; i < res.size(); i++)
      for (int j = 0; j < res[0].size(); j++)
         res[i][j] = m[j][i];

   return res;
}


vector<vector<float>> RobotArm::Jacobian(vector<float> thetas)
{
   float link1 = m_fLink1_Length_m;
   float link2 = m_fLink2_Length_m;
   float link3 = m_fLink3_Length_m;
   float link4 = m_fLink4_Length_m;
   float link5 = m_fLink5_Length_m;
   float link6 = m_fLink6_Length_m;

   float theta1 = thetas[0];
   float theta2 = thetas[1];
   float theta4 = thetas[2];
   float theta5 = thetas[3];
   float theta6 = thetas[4];

   vector<vector<float>> J;

   float J11 = (-1/2)*sin(theta1)*(2*link2*cos(theta2)+2*link4*cos(theta2+theta4)+2*link5*cos(theta2+theta4+theta5)+link6*cos(theta2+theta4+theta5+(-1)*theta6)+link6*cos(theta2+theta4+theta5+theta6)+(-2)*link3*sin(theta2))+(-1)*link6*cos(theta1)*sin(theta6);
   float J12 = (1/2)*cos(theta1)*((-2)*link3*cos(theta2)+(-2)*link2*sin(theta2)+(-2)*link4*sin(theta2+theta4)+(-2)*link5*sin(theta2+theta4+theta5)+(-1)*link6*sin(theta2+theta4+theta5+(-1)*theta6)+(-1)*link6*sin(theta2+theta4+theta5+theta6));
   float J13 = 0;
   float J14 = (1/2)*cos(theta1)*((-2)*link4*sin(theta2+theta4)+(-2)*link5*sin(theta2+theta4+theta5)+(-1)*link6*sin(theta2+theta4+theta5+(-1)*theta6)+(-1)*link6*sin(theta2+theta4+theta5+theta6));
   float J15 = (1/2)*cos(theta1)*((-2)*link5*sin(theta2+theta4+theta5)+(-1)*link6*sin(theta2+theta4+theta5+(-1)*theta6)+(-1)*link6*sin(theta2+theta4+theta5+theta6));
   float J16 = (-1)*link6*cos(theta6)*sin(theta1)+(1/2)*cos(theta1)*(link6*sin(theta2+theta4+theta5+(-1)*theta6)+(-1)*link6*sin(theta2+theta4+theta5+theta6));

   float J21 = cos(theta1)*cos(theta2)*(link2+link4*cos(theta4))+link5*cos(theta1)*cos(theta2+theta4)*cos(theta5)+link6*cos(theta1)*cos(theta2+theta4+theta5)*cos(theta6)+(-1)*link3*cos(theta1)*sin(theta2)+(-1)*link4*cos(theta1)*sin(theta2)*sin(theta4)+(-1)*link5*cos(theta1)*sin(theta2+theta4)*sin(theta5)+(-1)*link6*sin(theta1)*sin(theta6);
   float J22 = (-1)*link3*cos(theta2)*sin(theta1)+(-1)*(link2+link4*cos(theta4))*sin(theta1)*sin(theta2)+(-1)*link4*cos(theta2)*sin(theta1)*sin(theta4)+(-1)*link5*cos(theta5)*sin(theta1)*sin(theta2+theta4)+(-1)*link5*cos(theta2+theta4)*sin(theta1)*sin(theta5)+(-1)*link6*cos(theta6)*sin(theta1)*sin(theta2+theta4+theta5);
   float J23 = 0;
   float J24 = (-1)*link4*cos(theta4)*sin(theta1)*sin(theta2)+(-1)*link4*cos(theta2)*sin(theta1)*sin(theta4)+(-1)*link5*cos(theta5)*sin(theta1)*sin(theta2+theta4)+(-1)*link5*cos(theta2+theta4)*sin(theta1)*sin(theta5)+(-1)*link6*cos(theta6)*sin(theta1)*sin(theta2+theta4+theta5);
   float J25 = (-1)*link5*cos(theta5)*sin(theta1)*sin(theta2+theta4)+(-1)*link5*cos(theta2+theta4)*sin(theta1)*sin(theta5)+(-1)*link6*cos(theta6)*sin(theta1)*sin(theta2+theta4+theta5);
   float J26 = link6*cos(theta1)*cos(theta6)+(-1)*link6*cos(theta2+theta4+theta5)*sin(theta1)*sin(theta6);

   float J31 = 0;
   float J32 = (-1)*link2*cos(theta2)+(-1)*link4*cos(theta2+theta4)+(-1)*link5*cos(theta2+theta4+theta5)+(-1/2)*link6*cos(theta2+theta4+theta5+(-1)*theta6)+(-1/2)*link6*cos(theta2+theta4+theta5+theta6)+link3*sin(theta2);
   float J33 = 0;
   float J34 = (-1)*link4*cos(theta2+theta4)+(-1)*link5*cos(theta2+theta4+theta5)+(-1/2)*link6*cos(theta2+theta4+theta5+(-1)*theta6)+(-1/2)*link6*cos(theta2+theta4+theta5+theta6);
   float J35 = (-1)*link5*cos(theta2+theta4+theta5)+(-1/2)*link6*cos(theta2+theta4+theta5+(-1)*theta6)+(-1/2)*link6*cos(theta2+theta4+theta5+theta6);
   float J36 = (1/2)*link6*cos(theta2+theta4+theta5+(-1)*theta6)+(-1/2)*link6*cos(theta2+theta4+theta5+theta6);

   float J1[] = {J11, J12, J13, J14, J15, J16};
   float J2[] = {J21, J22, J23, J24, J25, J26};
   float J3[] = {J31, J32, J33, J34, J35, J36};

   //J.push_back(vector<float> vec1(J1, J1+6));
   //J.push_back(vector<float> vec2(J2, J2+6));
   //J.push_back(vector<float> vec3(J3, J3+6));
   return J;
}

float RobotArm::GetDistanceToTowerLocal(Point3D pt)
{

  float hbw = 0.0375; //half block width
  float twh = 0.27 - m_fOrigin_ToSurface_m;  //tower height... should go somewhere else
  //first figure out which of the 9 regions the point is in
  float dist = 0;
  if (pt.x_m < -hbw)
  {
     if (pt.y_m < -hbw)
     {
        dist = sqrt(pow(pt.x_m+hbw,2) + pow(pt.y_m+hbw,2));
        if (pt.z_m > twh)
        {
           dist = sqrt(pow(dist,2) + pow(pt.z_m-twh,2));
        }
     }
     else if (pt.y_m > hbw)
     {
        dist = sqrt(pow(pt.x_m+hbw,2) + pow(pt.y_m-hbw,2));
        if (pt.z_m > twh)
        {
           dist = sqrt(pow(dist,2) + pow(pt.z_m-twh,2));
        }
     }
     else
     {
        dist = -hbw-pt.x_m;
        if (pt.z_m > twh)
        {
           dist = sqrt(pow(dist,2) + pow(pt.z_m-twh,2));
        }
     }
  }
  else if (pt.x_m > hbw)
  {
     if (pt.y_m < -hbw)
     {
        dist = sqrt(pow(pt.x_m-hbw,2) + pow(pt.y_m+hbw,2));
        if (pt.z_m > twh)
        {
           dist = sqrt(pow(dist,2) + pow(pt.z_m-twh,2));
        }
     }
     else if (pt.y_m > hbw)
     {
        dist = sqrt(pow(pt.x_m-hbw,2) + pow(pt.y_m-hbw,2));
        if (pt.z_m > twh)
        {
           dist = sqrt(pow(dist,2) + pow(pt.z_m-twh,2));
        }
     }
     else
     {
        dist = pt.x_m-hbw;
        if (pt.z_m > twh)
        {
           dist = sqrt(pow(dist,2) + pow(pt.z_m-twh,2));
        }
     }
  }
  else
  {
     if (pt.y_m < -hbw)
     {
        dist = hbw-pt.y_m;
        if (pt.z_m > twh)
        {
           dist = sqrt(pow(dist,2) + pow(pt.z_m-twh,2));
        }
     }
     else if (pt.y_m > hbw)
     {
        dist = pt.y_m-hbw;
        if (pt.z_m > twh)
        {
           dist = sqrt(pow(dist,2) + pow(pt.z_m-twh,2));
        }
     }
     else
     {
        dist = -min(hbw-fabs(pt.x_m),hbw-fabs(pt.y_m));
        if (pt.z_m > twh)
        {
           dist = pt.z_m-twh;
        }
     }
  }

//  dist = min(dist, pt.z_m + m_fOrigin_ToSurface_m);

  return dist;
}

