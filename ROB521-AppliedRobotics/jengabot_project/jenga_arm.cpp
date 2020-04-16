#include <stdio.h>
#include <vector>
#include <iostream>
#include "RobotArm.h"
#include "Common_Structs.h"
#include "TrajectoryGenerator.h"

using namespace std;

void RunSTOMPTest(vector<float> init_thetas, Point3D ef_pose, float yaw, Pose2D tower_pose)
{

   RobotArm* robot = new RobotArm(init_thetas);
   TrajectoryGenerator stomp = TrajectoryGenerator(robot);

   int iRet = stomp.Plan(ef_pose, yaw, tower_pose);

   if (iRet == 0)
   {
      vector<vector<float>>  traj = stomp.GetPlannedTrajectory();
   }

}

int main(int argc, char *argv[])
{
   vector<float> init_thetas(5);
   init_thetas[1] = -PI;
   init_thetas[2] = PI;

   Point3D pose;
   pose.x_m = float(atoi(argv[1]))/1000;
   pose.y_m = float(atoi(argv[2]))/1000;
   pose.z_m = float(atoi(argv[3]))/1000;
   float yaw = float(atoi(argv[4]))/1000;

   //aim for 20 mm away
   Pose2D tower_pose;
   tower_pose.x_m = pose.x_m + 0.0575*cos(yaw);
   tower_pose.y_m = pose.y_m + 0.0575*sin(yaw);
   tower_pose.yaw_rad = yaw;

   fstream logfile;
   logfile.open("spherelog.csv", fstream::out);
   logfile << tower_pose.x_m << "," << tower_pose.y_m << "," << tower_pose.yaw_rad << ",0,0,0\n";
   logfile.close();

   logfile.open("logfile.csv", fstream::out);
   logfile.close();

   printf("Tower pose: %f, %f, %f\n", tower_pose.x_m, tower_pose.y_m, tower_pose.yaw_rad);

   RunSTOMPTest(init_thetas, pose, yaw, tower_pose);

}
