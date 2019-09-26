#include <stdio.h>
#include <vector>
#include <iostream>
#include "RobotArm.h"
#include "Common_Structs.h"

using namespace std;

void RunInverseTest(Point3D ef_pose, float yaw, Pose2D tower_pose)
{

   vector<float> thetas(5);

   RobotArm robot = RobotArm(thetas);

   thetas = robot.InverseKinematics_XY(ef_pose, yaw);

   printf("Testing: %f, %f, %f, %f, %f\n",thetas[0],thetas[1],thetas[2],thetas[3],thetas[4]);

   robot.Update(thetas);

   vector<Point3D> base_pts = robot.GetBasePoints();

   for (int i = 0; i < base_pts.size(); i++)
   {
      printf("Frame: %d | %f, %f, %f\n", i, base_pts[i].x_m, base_pts[i].y_m, base_pts[i].z_m);
   }

   Pose6D ef_pose_check = robot.GetEndEffectorPose();
   printf("EF: %f, %f, %f\n",ef_pose_check.pos.x_m, ef_pose_check.pos.y_m, ef_pose_check.pos.z_m);

   float dist = robot.GetDistanceToTower(tower_pose);

}

int main(int argc, char *argv[])
{
   vector<float> init_thetas(5);
   init_thetas[1] = -PI/2;

   Point3D pose;
   pose.x_m = float(atoi(argv[1]))/1000;
   pose.y_m = float(atoi(argv[2]))/1000;
   pose.z_m = float(atoi(argv[3]))/1000;
   float yaw = float(atoi(argv[4]))/1000;

   Pose2D tower_pose;
   tower_pose.x_m = pose.x_m + 0.0375*cos(yaw);
   tower_pose.y_m = pose.y_m + 0.0375*sin(yaw);
   tower_pose.yaw_rad = yaw;

   printf("Tower pose: %f, %f, %f\n", tower_pose.x_m, tower_pose.y_m, tower_pose.yaw_rad);

   RunInverseTest(pose, yaw, tower_pose);

}
