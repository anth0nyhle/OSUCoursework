#ifndef TRAJECTORY_GENERATOR_H
#define TRAJECTORY_GENERATOR_H

#include <stdio.h>
#include <vector>
#include <sys/time.h>
#include <fstream>

#include "RobotArm.h"
#include "Common_Structs.h"
#include "MVN_Sampler.h"

#define NUM_TRAJ_PTS 30
#define NUM_TRAJ 20

using namespace std;

class TrajectoryGenerator {

public:
   TrajectoryGenerator(RobotArm* robot);

   RET_CODE Plan(Point3D goal_pose, float goal_yaw, Pose2D tower);
   RET_CODE PlanToTheta(vector<float> targ_thetas, Pose2D tower);

   vector<vector<float>> GetPlannedTrajectory() { return res_traj; }

private:

   bool CheckTrajectory(vector<vector<float>> traj, RobotArm robot, Pose2D tower_pose);
   vector<vector<float>> EvaluateTrajectoryCost(vector<vector<float>> traj, RobotArm robot, Pose2D tower_pose);
   float SumTrajectoryCost(vector<vector<float>> traj, RobotArm robot, Pose2D tower_pose);
   void ImportanceWeighting(vector<vector<vector<float>>> S);
   void NormalizeCost(vector<vector<vector<float>>>* traj_cost);
   void UpdateNominalTrajectory(vector<vector<float>>* theta_traj, vector<vector<vector<float>>> P, vector<vector<vector<float>>> noise);
   void InitializeTrajectory(vector<float> init_thetas, vector<float> final_thetas);
   void UpdateNoise(int K, float noise_scaling);
   void PerturbTrajectory(vector<vector<float>> traj, vector<vector<vector<float>>> noise);

   void WriteToFile(vector<vector<vector<float>>> traj, vector<vector<vector<float>>> cost, vector<vector<float>> res_traj);
   void WriteNomTrajectory(vector<vector<float>> nom_traj, RobotArm robot);

   RobotArm* m_pRobotArm;
   MVN_Sampler sampler;

   vector<vector<float>> M;
   vector<vector<float>> ATA;
   vector<vector<vector<float>>> cov_noise;


   vector<vector<float>> res_traj;
   vector<vector<float>> theta_traj;
   vector<vector<vector<float>>> noisy_traj;
   vector<vector<vector<float>>> traj_cost;
   vector<vector<vector<float>>> P;

   const static double A[NUM_TRAJ_PTS*NUM_TRAJ_PTS];

   static constexpr float min_cost_threshold = 1;
   static constexpr float sto_noise_param = 50;
   static constexpr float min_dist_to_tower = 0.01;

};

#endif
