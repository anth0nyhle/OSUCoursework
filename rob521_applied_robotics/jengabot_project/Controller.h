#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <stdio.h>
#include <vector>
#include <sys/time.h>
#include "RobotArm.h"
#include "Common_Structs.h"
#include <iostream>
#include <fstream>
#include "RBFestimator.h"
#include "LTV_LQR.h"

using namespace std;

class Controller {

public:

   Controller(RobotArm* pRobot);

   RET_CODE SetNewTrajectory(vector<vector<float>> traj);
   RET_CODE Update(vector<float>* cur_theta, bool bConstrained);

   void ReverseTrajectory();

   void HoldPosition();
   bool TrajectoryActive() {return m_bTrajectoryActive;}

   void SetNewTargetThetas(vector<float> targ);

private:

   void WriteToFile(int idx, float wp_time_s, float cur_time_s, vector<float> targs, vector<float> cur, vector<float> out);

   LTV_LQR* m_pLQR;
   RobotArm* m_pRobot;
   RBFestimator* m_pFF;

   vector<vector<float>> trajectory_pos;
   vector<vector<float>> trajectory_vel;
   vector<float> trajectory_time;

   vector<float> target_thetas;

   struct timeval start_time;

   vector<float> Kpp;
   vector<float> int_error;
   vector<float> Kpv;
   vector<float> Kiv;
   int m_nActiveIdx;
   float m_fTimeIndex_s;
   bool m_bTrajectoryActive;
   bool m_bControllerActive;
};

#endif
