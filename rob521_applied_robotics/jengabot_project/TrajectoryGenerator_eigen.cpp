#include <algorithm>
#include "TrajectoryGenerator.h"

using namespace std;

const double TrajectoryGenerator::A[]={60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,10000.0000000000,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000,-40000.0000000000,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10000.0000000000,-40000.0000000000,60000.0000000000};

TrajectoryGenerator::TrajectoryGenerator(RobotArm* robot)
{
   m_pRobotArm = robot;
   sampler = MVN_Sampler();

   vector<vector<float>> Rinv = sampler.GetRinv();
   M = Rinv;

   for (int i = 0; i < Rinv[0].size(); i++)
   {
      float max_col = 0.0;
      for (int j = 0; j < Rinv.size(); j++)
         max_col = max(Rinv[j][i],max_col);
      for (int j = 0; j < Rinv.size(); j++)
      {
         M[j][i] = Rinv[j][i]*(1.0/(float)NUM_TRAJ_PTS)/max_col;
      }
   }
//   for (int i = 0; i < NUM_TRAJ; i++)
//   {
//      for (int j = 0; j < NUM_TRAJ - 1; j++)
//         printf("%f\t",M[i][j]);
//      printf("\n");
//   }
   //init noise
   for (int i = 0; i < NUM_TRAJ; i++)
   {
      vector<vector<float>> twodmat;
      for (int j = 0; j < NUM_TRAJ_PTS; j++)
      {
         vector<float> onedmat(5);
         twodmat.push_back(onedmat);
      }
      cov_noise.push_back(twodmat);
      noisy_traj.push_back(twodmat);
      traj_cost.push_back(twodmat);
      P.push_back(twodmat);
      theta_traj = twodmat;
   }

   ATA = Rinv;
   int c = 0;
   for (int i = 0; i < NUM_TRAJ_PTS; i++)
      for (int j = 0; j < NUM_TRAJ_PTS; j++)
         ATA[i][j] = A[c++];

   vector<float> t(5);
   for (int i = 0 ; i < NUM_TRAJ_PTS+2; i++)
      res_traj.push_back(t);

}

RET_CODE TrajectoryGenerator::Plan(Point3D goal_pose, float goal_yaw, Pose2D tower)
{

   vector<float> init_thetas = m_pRobotArm->GetThetas();
   vector<float> targ_thetas(5);

   RET_CODE iRet = m_pRobotArm->InverseKinematics_XY(goal_pose, goal_yaw, &targ_thetas);

   if (iRet != ECODE_NO_ERROR)
   {
      printf("Can't reach goal point!!!\n");
      return iRet;
   }

   iRet = PlanToTheta(targ_thetas, tower);

   return iRet;
}

RET_CODE TrajectoryGenerator::PlanToTheta(vector<float> targ_thetas, Pose2D tower)
{
   vector<float> init_thetas = m_pRobotArm->GetThetas();

   RobotArm robot(init_thetas); //local instance used for joint configurations

   InitializeTrajectory(init_thetas, targ_thetas);

   bool bConverged = false;

   int cost_threshold_count = 0;
   float last_nom_cost = 10000;

   float noise_scale = 1.0;

   while (!bConverged)
   {
      struct timeval start_time, probe_time, end_time;
      gettimeofday(&start_time,NULL);

      UpdateNoise(NUM_TRAJ, noise_scale);

//      gettimeofday(&probe_time,NULL);
//      long mtime = ((probe_time.tv_sec - start_time.tv_sec)*1000.0 + (probe_time.tv_usec - start_time.tv_usec)/1000.0);
//      printf("%ld msec update noisel\n",mtime);

      PerturbTrajectory(theta_traj, cov_noise);

//      gettimeofday(&probe_time,NULL);
//      mtime = ((probe_time.tv_sec - start_time.tv_sec)*1000.0 + (probe_time.tv_usec - start_time.tv_usec)/1000.0);
//      printf("%ld msec perturb\n",mtime);

//      for (int i = 0; i < NUM_TRAJ_PTS; i++)
//      {
//         for (int j = 0; j < NUM_TRAJ; j++)
//            printf("%f\t",noisy_traj[j][i][0]);
//         printf("%f\n", noisy_traj[NUM_TRAJ-1][i][0]);
//      }

      for (int i = 0; i < NUM_TRAJ; i++)
      {
//         printf("Setting: %f, %f, %f, %f, %f\n",init_thetas[0],init_thetas[1],init_thetas[2],init_thetas[3],init_thetas[4]);
         robot.Update(init_thetas);
         traj_cost[i] = EvaluateTrajectoryCost(noisy_traj[i], robot, tower);
//         gettimeofday(&probe_time,NULL);
//         mtime = ((probe_time.tv_sec - start_time.tv_sec)*1000.0 + (probe_time.tv_usec - start_time.tv_usec)/1000.0);
//         printf("%ld msec cost eval\n",mtime);

      }

      NormalizeCost(&traj_cost); //note that traj_cost = exp(-S) now
//      gettimeofday(&probe_time,NULL);
//      mtime = ((probe_time.tv_sec - start_time.tv_sec)*1000.0 + (probe_time.tv_usec - start_time.tv_usec)/1000.0);
//      printf("%ld msec normalize\n",mtime);

      ImportanceWeighting(traj_cost);
//      gettimeofday(&probe_time,NULL);
//      mtime = ((probe_time.tv_sec - start_time.tv_sec)*1000.0 + (probe_time.tv_usec - start_time.tv_usec)/1000.0);
//      printf("%ld msec importance weight\n",mtime);

      UpdateNominalTrajectory(&theta_traj, P, cov_noise);
//      gettimeofday(&probe_time,NULL);
//      mtime = ((probe_time.tv_sec - start_time.tv_sec)*1000.0 + (probe_time.tv_usec - start_time.tv_usec)/1000.0);
//      printf("%ld msec update nominal\n",mtime);

//      for (int i = 0; i < NUM_TRAJ_PTS; i++)
//      {
//         for (int j = 0; j < 4; j++)
//            printf("%f\t",theta_traj[i][j]);
//         printf("%f\n", theta_traj[i][4]);
//      }

      WriteToFile(noisy_traj, P, theta_traj);
      WriteNomTrajectory(theta_traj, robot);

      robot.Update(init_thetas);
      float nom_cost =  SumTrajectoryCost(theta_traj, robot, tower);
      printf("nom cost: %f, %f, %d\n", nom_cost, last_nom_cost - nom_cost, cost_threshold_count);

      bool bCollision = CheckTrajectory(theta_traj, robot, tower);


      if (!bCollision)
         cost_threshold_count+=2;
      else if (last_nom_cost - nom_cost < min_cost_threshold)
         cost_threshold_count++;
      else
         cost_threshold_count = 0;

      if (cost_threshold_count > 10)
         bConverged = true;

//      gettimeofday(&end_time,NULL);
//      mtime = ((end_time.tv_sec - start_time.tv_sec)*1000.0 + (end_time.tv_usec - start_time.tv_usec)/1000.0);
//      printf("%ld msec per iteration\n",mtime);

      last_nom_cost = nom_cost;
   }

   res_traj[0] = init_thetas;
   for (int i = 0; i < NUM_TRAJ_PTS; i++)
      res_traj[i+1] = theta_traj[i];
   res_traj[NUM_TRAJ_PTS+1] = targ_thetas;

   return ECODE_NO_ERROR;
}

bool TrajectoryGenerator::CheckTrajectory(vector<vector<float>> traj, RobotArm robot, Pose2D tower_pose)
{

 for (int j = 0; j < NUM_TRAJ_PTS; j++)
 {
      robot.Update(traj[j]);
      vector<BoundingSphere> surface = robot.GetAllSurfaceSpheres();
      for (int s = 0; s < surface.size(); s++)
      {
         float dist = robot.GetSphereDistanceToTower(surface[s], tower_pose);
         if (dist < min_dist_to_tower/2.0)
         {

            printf("collision: %d | %f, %f, %f | %f\n",s,surface[s].center.x_m,surface[s].center.y_m,surface[s].center.z_m,dist);
            return true;
         }
      }
 }
 return false;
}

vector<vector<float>> TrajectoryGenerator::EvaluateTrajectoryCost(vector<vector<float>> traj, RobotArm robot, Pose2D tower_pose)
{
   vector<vector<float>> traj_cost = traj;
   vector<BoundingSphere> prev_surface = robot.GetAllSurfaceSpheres();
   for (int j = 0; j < NUM_TRAJ_PTS; j++)
   {
      //printf("for traj pt %d\n",j);
      float q = 0;
      robot.Update(traj[j]);
      vector<BoundingSphere> surface = robot.GetAllSurfaceSpheres();
      for (int s = 0; s < min(surface.size(),prev_surface.size()); s++)
      {
         float dist = robot.GetSphereDistanceToTower(surface[s], tower_pose);
         if (dist > 10)
            printf("Something is wrong here!");
         Point3D delta = surface[s].center;
         delta.x_m -= prev_surface[s].center.x_m;
         delta.y_m -= prev_surface[s].center.y_m;
         delta.z_m -= prev_surface[s].center.z_m;
         //printf("%d | (%f, %f, %f) -> (%f, %f, %f)\n",s, prev_surface[s].center.x_m,  prev_surface[s].center.y_m, prev_surface[s].center.z_m,surface[s].center.x_m,surface[s].center.y_m,surface[s].center.z_m);
         float vel = sqrt(pow(delta.x_m,2) + pow(delta.y_m,2) + pow(delta.z_m,2));
         if (vel > 10)
            printf("wtf is going on?!?!?!\n");
         q += 10*max(min_dist_to_tower - dist, (float)0.0)*max((float)0.01,10*vel);
      }
      for (int k = 0; k < 5; k++)
      {
         traj_cost[j][k] = q;
      }
   }

   vector<vector<float>> accels = traj_cost;
   for (int k = 0; k < 5; k++)
   {
      for (int j = 2; j < NUM_TRAJ_PTS-2; j++)
      {
         float accel = 0;
         for (int r = 2; r < NUM_TRAJ_PTS-2; r++)
         {
            accel += ATA[r][j]*traj[r][k]*0.001;
         }
         accels[j][k] = accel;
         traj_cost[j][k] += 0.001*pow(accel,2);
      }
   }

   return traj_cost;
}

float TrajectoryGenerator::SumTrajectoryCost(vector<vector<float>> traj, RobotArm robot, Pose2D tower_pose)
{
   vector<vector<float>> traj_cost = EvaluateTrajectoryCost(traj, robot, tower_pose);
   float sum_cost = 0;
   for (int j = 0; j < NUM_TRAJ_PTS; j++)
      for (int k = 0; k < 5; k++)
         sum_cost += traj_cost[j][k];

   return sum_cost;
}

void TrajectoryGenerator::ImportanceWeighting(vector<vector<vector<float>>> S)
{
   for (int k = 0; k < 5; k++)
   {
      for (int j = 0; j < NUM_TRAJ_PTS; j++)
      {
         float sum_cost = 0;
         for (int i = 0; i < NUM_TRAJ; i++)
         {
            sum_cost += S[i][j][k];
         }
         for (int i = 0; i < NUM_TRAJ; i++)
         {
            P[i][j][k] = S[i][j][k]/sum_cost;
         }
      }
   }
}

void TrajectoryGenerator::NormalizeCost(vector<vector<vector<float>>>* traj_cost)
{
   for (int k = 0; k < 5; k++)
   {
      for (int j = 0; j < NUM_TRAJ_PTS; j++)
      {
         float max_cost = 0;
         float min_cost = 10000;
         for (int i = 0; i < NUM_TRAJ; i++)
         {
            max_cost = max(max_cost, (*traj_cost)[i][j][k]);
            min_cost = min(min_cost, (*traj_cost)[i][j][k]);
         }
         for (int i = 0; i < NUM_TRAJ; i++)
         {
            (*traj_cost)[i][j][k] = exp(-sto_noise_param*((*traj_cost)[i][j][k] - min_cost)/(0.0000000001 + max_cost-min_cost));
         }
      }
   }
}

void TrajectoryGenerator::UpdateNominalTrajectory(vector<vector<float>>* theta_traj, vector<vector<vector<float>>> P, vector<vector<vector<float>>> noise)
{
   vector<vector<float>> del_theta;
   vector<float> row(5);
   for (int i = 0; i < NUM_TRAJ_PTS; i++)
      del_theta.push_back(row);

   for (int i = 0; i < P.size(); i++)
      for (int j = 0; j < P[0].size(); j++)
         for (int k = 0; k < P[0][0].size(); k++)
            del_theta[j][k] += P[i][j][k]*noise[i][j][k];

//   for (int i = 0; i < NUM_TRAJ_PTS; i++)
//   {
//      for (int j = 0; j < 5; j++)
//         printf("%f\t",del_theta[i][j]);
//      printf("\n");
//   }

   for (int i = 0; i < del_theta.size(); i++)
   {
      for (int j = 0; j < del_theta[0].size(); j++)
      {
         for (int r = 0; r < del_theta.size(); r++)
         {
            (*theta_traj)[i][j] += M[i][r]*del_theta[r][j];
         }
//         printf("traj update (%d,%d): %f\n",i,j,(*theta_traj)[i][j]);
      }
   }
}

void TrajectoryGenerator::InitializeTrajectory(vector<float> init_thetas, vector<float> final_thetas)
{
   vector<float> step_size;
   for (int i = 0; i < init_thetas.size(); i++)
   {
      float delta = final_thetas[i] - init_thetas[i];
      step_size.push_back(delta/(NUM_TRAJ_PTS+1));
   }

   for (int i = 0; i < NUM_TRAJ_PTS; i++)
   {
      vector<float> row(init_thetas.size());
      for (int j = 0; j < init_thetas.size(); j++)
      {
         if (i == 0)
            row[j] = init_thetas[j] + step_size[j];
         else
            row[j] = theta_traj[i-1][j] + step_size[j];
      }
      theta_traj[i] = row;
   }
}

void TrajectoryGenerator::UpdateNoise(int K, float noise_scaling)
{
   struct timeval cur_time;
   gettimeofday(&cur_time,NULL);
   int seed = cur_time.tv_sec + cur_time.tv_usec;

   // do 5 times for each of the thetas
   vector<vector<float>> param_noise;
   for (int k = 0; k < 5; k++)
   {
      param_noise = sampler.Sample(K, &seed, noise_scaling);
      for (int i = 0; i < NUM_TRAJ; i++)
      {
         for (int j = 0; j < NUM_TRAJ_PTS; j++)
         {
            cov_noise[i][j][k] = param_noise[i][j];
         }
      }
   }
}

void TrajectoryGenerator::PerturbTrajectory(vector<vector<float>> traj, vector<vector<vector<float>>> noise)
{
   for (int i = 0; i < noise.size(); i++)
      for (int j = 0; j < noise[0].size(); j++)
         for (int k = 0; k < noise[0][0].size(); k++)
         {
            noisy_traj[i][j][k] = traj[j][k] + noise[i][j][k];
            noisy_traj[i][j][k] = m_pRobotArm->ClipTheta(noisy_traj[i][j][k],k);
         }
}

void TrajectoryGenerator::WriteToFile(vector<vector<vector<float>>> traj, vector<vector<vector<float>>> cost, vector<vector<float>> res_traj)
{

   fstream logfile;
   logfile.open("logfile.csv",fstream::app);

   for (int i = 0; i < NUM_TRAJ; i++)
   {
      for (int k = 0; k < 5; k++)
      {
         for (int j = 0; j < NUM_TRAJ_PTS; j++)
         {
            if (k == 4 && j == (NUM_TRAJ_PTS-1))
               continue;
            logfile << traj[i][j][k] << ",";
         }
      }
      logfile << traj[i][NUM_TRAJ_PTS-1][4] << "\n";
   }

   for (int i = 0; i < NUM_TRAJ; i++)
   {
      for (int k = 0; k < 5; k++)
      {
         for (int j = 0; j < NUM_TRAJ_PTS; j++)
         {
            if (k == 4 && j == (NUM_TRAJ_PTS-1))
               continue;
            logfile << cost[i][j][k] << ",";
         }
      }
      logfile << cost[i][NUM_TRAJ_PTS-1][4] << "\n";
   }

   for (int k = 0; k < 5; k++)
   {
      for (int j = 0; j < NUM_TRAJ_PTS; j++)
      {
         if (k == 4 && j == (NUM_TRAJ_PTS-1))
            continue;
         logfile << res_traj[j][k] << ",";
      }
   }
   logfile << res_traj[NUM_TRAJ_PTS-1][4] << "\n";
   logfile.close();
}

void TrajectoryGenerator::WriteNomTrajectory(vector<vector<float>> nom_traj, RobotArm robot)
{
   fstream logfile;
   logfile.open("spherelog.csv", fstream::app);
   for (int i = 0; i < NUM_TRAJ_PTS; i++)
   {
      robot.Update(nom_traj[i]);

      vector<BoundingSphere> surface = robot.GetAllSurfaceSpheres();
      for (int f = 0; f < surface.size(); f++)
         logfile << i << "," << f << "," << surface[f].center.x_m << "," << surface[f].center.y_m << "," << surface[f].center.z_m << "," << surface[f].radius << "\n";
   }
   logfile.close();

}
