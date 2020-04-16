#ifndef ROBOT_ARM_H
#define ROBOT_ARM_H

#include <list>
#include <vector>
#include "Common_Structs.h"

#define NUM_JOINTS 6

using namespace std;

class RobotArm {

public:

   RobotArm(vector<float> init_theta);

   float GetJointViolationDistance(int joint_num, float theta);
   float GetDistanceToTower(Pose2D tower_pose);

   void Update(vector<float> thetas);

   Point3D GetEndEffectorPose();

   RET_CODE InverseKinematics_XY(Point3D ef_pt, float yaw, vector<float>* thetas);
   vector<float> GetThetas() { return current_thetas; }

   vector<Point3D> GetBasePoints() { return base_pts; }
   vector<float> GetJointVels();
   float GetSphereDistanceToTower(BoundingSphere sphere, Pose2D tower_pose);
   vector<BoundingSphere> GetAllSurfaceSpheres();

   float GetMaxVel(int joint)
   {
      if (joint >= 2)
         joint++;
      return links[joint].joint.rot_vel_limit_rps;
   }

   float GetMaxAccel(int joint)
   {
      if (joint >= 2)
         joint++;
      return links[joint].joint.rot_acc_limit_rps2;
   }

   float ClipTheta(float theta, int joint);

private:

   struct timeval last_time;
   float time_step;

   vector<Link> links;
   vector<Point3D> base_pts;

   vector<float> current_thetas;
   vector<float> prev_thetas;

   void Update();


   float GetDistanceToTowerLocal(Point3D pt);

   Point3D Rotate(vector<vector<float>> m, Point3D offset);
   vector<float> theta_dot;

   vector<vector<float>> MatrixMultiply(vector<vector<float>> m1, vector<vector<float>> m2);
   vector<vector<float>> Transpose(vector<vector<float>> m);
   vector<vector<float>> ExtractRotMatrix(vector<vector<float>> T);
   vector<vector<float>> Jacobian(vector<float> thetas);

   static constexpr float sphere_spacing = 0.01;

};

#endif
