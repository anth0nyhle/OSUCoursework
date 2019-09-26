#include "Controller.h"

using namespace std;

Controller::Controller(RobotArm* pRobot)
{
   m_pRobot = pRobot;
   for (int i = 0; i < 5; i++)
   {
      Kpp.push_back(10.0);
      Kpv.push_back(1.0);
      Kiv.push_back(1.0);
      int_error.push_back(0.0);
   }
   Kpp[1] = 4.0;
   Kpp[2] = 7.0;
   Kpv[1] = 0.0;
   Kpv[2] = 0.0;

   Kpp[4] = 20.0;

   Kiv[1] = 1.0;
   Kiv[2] = 2.0;
   //Kpp[0] = 0.5;
   //Kpp[1] = 20.0;
   //Kpp[2] = 1.5;
   //Kpp[3] = 3.0;
   //Kpp[4] = 4.0;

   m_pFF = new RBFestimator();
   m_pLQR = new LTV_LQR();

   m_nActiveIdx = 0;
   m_bTrajectoryActive = false;
   m_bControllerActive = false;
}

RET_CODE Controller::SetNewTrajectory(vector<vector<float>> traj)
{
   vector<vector<float>> temp_vel_traj;
   vector<vector<float>> temp_acc_traj;
   vector<float> vels(5);
   vector<float> accs(5);
   temp_vel_traj.push_back(vels);
   temp_acc_traj.push_back(vels);
   float max_dt = 0.05;

   for (int i = 1; i < traj.size()-1; i++)
   {
      for (int j = 0; j < 5; j++)
      {
         float vel = (traj[i+1][j] - traj[i-1][j])/0.2;
         float max_vel = m_pRobot->GetMaxVel(j);
         if (fabs(vel) > max_vel)
         {
            float dt = (0.1*fabs(vel))/max_vel;
            if (dt > max_dt)
            {
               max_dt = dt;
               printf("Max vel exceeded: %d, %d, %f, %f, %f\n",j,i,vel,max_vel,dt);
            }
         }

         float acc = (2*traj[i][j] - traj[i+1][j] - traj[i-1][j])/0.01;
         float max_accel = m_pRobot->GetMaxAccel(j);
         if (fabs(acc) > max_accel)
         {
            float dt = (0.01*fabs(acc))/max_accel;
            if (dt > max_dt)
            {
               max_dt = dt;
               printf("Max acc exceeded: %d, %d, %f, %f, %f\n",j,i,acc,max_accel,dt);
            }
         }
      }
   }

   if (max_dt > 0.05)
   {
      printf("New dt: %f\n",max_dt);
   }

   float dt = 0.02;

   for (int i = 1; i < traj.size()-1; i++)
   {
      for (int j = 0; j < 5; j++)
      {
         float vel = (traj[i+1][j] - traj[i-1][j])/(2*max_dt);
         float acc = (2*traj[i][j] - traj[i+1][j] - traj[i-1][j])/(max_dt*max_dt);
         vels[j] = vel;
         accs[j] = acc;
      }
      temp_vel_traj.push_back(vels);
      temp_acc_traj.push_back(accs);
   }
   for (int j = 0; j < 5; j++)
      vels[j] = 0.0;
   temp_vel_traj.push_back(vels);
   temp_acc_traj.push_back(accs);

//   for (int i = 0; i < 5; i++)
//   {
//      printf("------------Theta %d-----------\n",i);
//      for (int j = 0; j < 32; j++)
//      {
//         printf("%f\t%f\t%f\n", traj[j][i], temp_vel_traj[j][i], temp_acc_traj[j][i]);
//      }
//   }

   trajectory_pos.clear();
   trajectory_vel.clear();
   trajectory_time.clear();

//   for (int i = 1; i < 32; i++)
//   {
//      vector<float> vel(5);
//      vector<float> pos(5);
//      vector<vector<float>> temp_vel;
//      vector<vector<float>> temp_pos;
//      for (int j = 0; j < 5; j++)
//      {
//         float cur_vel = temp_vel_traj[i-1][j];
//         float next_vel = temp_vel_traj[i][j];
//         float accel = (next_vel - cur_vel)/max_dt;
//         int num_pts = int(max_dt/dt);
//         for (int k = 0; k < num_pts; k++)
//         {
//            float targ_vel = cur_vel + accel*float(k)*dt;
//            float targ_theta = traj[i-1][j] + cur_vel*dt*float(k) + 0.5*accel*(dt*float(k)*dt*float(k));
//            if (j == 0)
//            {
//               vel[j] = targ_vel;
//               pos[j] = targ_theta;
//               temp_vel.push_back(vel);
//               temp_pos.push_back(pos);
//               trajectory_time.push_back(float(i-1)*max_dt + float(k)*dt);
//            }
//            else
///            {
//               temp_vel[k][j] = targ_vel;
//               temp_pos[k][j] = targ_theta;
//            }
//         }
//      }
//
//      for (int i = 0; i < temp_vel.size(); i++)
//      {
//         trajectory_vel.push_back(temp_vel[i]);
//         trajectory_pos.push_back(temp_pos[i]);
//      }
//   }

//   trajectory_vel.push_back(temp_vel_traj[31]);
//   trajectory_pos.push_back(traj[31]);
//   trajectory_time.push_back(31.0f*max_dt);

   trajectory_pos = traj;
   for (int i = 0; i < traj.size()-1; i++)
   {
      vector<float> row(5);
      for (int j = 0; j < 5; j++)
         row[j] = (traj[i+1][j] - traj[i][j])/max_dt;
      trajectory_vel.push_back(row);
      trajectory_time.push_back(float(i)*max_dt);
   }
   vector<float> zeros(5);
   trajectory_vel.push_back(zeros);
   trajectory_time.push_back(31.0f*max_dt);

//   int iRet = m_pLQR->StabalizeTrajectory(trajectory_pos, trajectory_vel, trajectory_time);

//   if (iRet != 0)
//   {
//      printf("Failed to stabalize trajectory!!!\n");
//      return ECODE_ERROR;
//   }

//   for (int i = 0; i < 5; i++)
//   {
//      printf("------------Theta %d-----------\n",i);
//      for (int j = 0; j < trajectory_pos.size(); j++)
//      {
//         printf("%f\t%f\t%f\n", trajectory_pos[j][i], trajectory_vel[j][i], trajectory_time[j]);
//      }
//   }

   m_fTimeIndex_s = 0.0;

   m_nActiveIdx = 0;
   m_bControllerActive = true;
   m_bTrajectoryActive = true;
   gettimeofday(&start_time, NULL);

   return ECODE_NO_ERROR;
}

RET_CODE Controller::Update(vector<float>* rot_vel_rps, bool bConstrained)
{
  static bool bFirst = true;
  static vector<float> prev_thetas(5);
  static vector<float> prev_theta_dots(5);
  bool just_finished = false;
  static vector<float> target_vels;


  if (!m_bControllerActive)
  {
     for (int i = 0; i < 5; i++)
        (*rot_vel_rps)[i] = 0.0;
     return ECODE_NO_ERROR;
  }

  if (m_bTrajectoryActive)
  {
     struct timeval cur_time;
     gettimeofday(&cur_time, NULL);

     m_fTimeIndex_s = float(cur_time.tv_sec - start_time.tv_sec) + (float(cur_time.tv_usec - start_time.tv_usec)/1000000);

     for (int i = m_nActiveIdx; i < trajectory_time.size(); i++)
     {
        float time_diff = trajectory_time[i] - m_fTimeIndex_s;
        if (time_diff > 0.0)
        {
           m_nActiveIdx = i;
           break;
        }
        if (i == trajectory_time.size()-1)
        {
           m_nActiveIdx = i;
           just_finished = true;
           m_bTrajectoryActive = false;
        }
     }

     target_thetas = trajectory_pos[m_nActiveIdx];
     target_vels = trajectory_vel[m_nActiveIdx];
  }

  vector<float> cur_thetas = m_pRobot->GetThetas();
  vector<float> cur_theta_dots = m_pRobot->GetJointVels();

  //printf("Target(%d):\t",m_nActiveIdx);
  for (int i = 0; i < 5; i++)
  {
  //   printf("%f\t",target_thetas[i]);
     float de =  Kpp[i]*(target_thetas[i]-cur_thetas[i]);
     float ve = target_vels[i] - cur_theta_dots[i];
     if (((fabs(target_thetas[i]-cur_thetas[i]) > 0.0015 && i == 1) ||
         (fabs(target_thetas[i]-cur_thetas[i]) > 0.0051 && i != 1)) && !bConstrained)
        int_error[i] += (target_thetas[i]-cur_thetas[i])*0.1;
     (*rot_vel_rps)[i] = de + Kpv[i]*ve + Kiv[i]*int_error[i];
  }

  //vector<float> temp = m_pLQR->Update(cur_thetas, cur_theta_dots, m_nActiveIdx);
  //(*rot_vel_rps)[1] = temp[0];
  //(*rot_vel_rps)[2] = temp[1];

//  printf("%f\t%f\n", temp[0], temp[1]);


  vector<float> err(2);
  err[0] = target_thetas[1]-cur_thetas[1];
  err[1] = target_thetas[2]-cur_thetas[2];

  if (!bFirst)
  {
    m_pFF->Update(prev_thetas, err);
    vector<float> ff_terms = m_pFF->GetFF(cur_thetas);
//    (*rot_vel_rps)[1] += ff_terms[0];
//    (*rot_vel_rps)[2] += ff_terms[1];
  }

  if ((*rot_vel_rps)[1] > 1)
     (*rot_vel_rps)[1] = 1;
  if ((*rot_vel_rps)[1] < -1)
     (*rot_vel_rps)[1] = -1;

  prev_thetas = cur_thetas;
  prev_theta_dots = cur_theta_dots;

  //printf("\n");

  if (true)
  {
    WriteToFile(m_nActiveIdx, trajectory_time[m_nActiveIdx], m_fTimeIndex_s, target_thetas, cur_thetas, (*rot_vel_rps));
  }
  if (!bFirst && just_finished && false)
  {
    m_pFF->WriteToFile();
  }

  bFirst = false;

  return ECODE_NO_ERROR;
}

void Controller::ReverseTrajectory()
{
   int idx = m_nActiveIdx-1;
   vector<float> temp_times;
   vector<float> cur_thetas = m_pRobot->GetThetas();
   vector<float> zeros(5);
   vector<vector<float>> temp_traj;
   vector<vector<float>> temp_traj_vel;
   temp_traj.push_back(cur_thetas);
   temp_traj_vel.push_back(zeros);
   temp_times.push_back(0.0);
   float cur_active_time_s = trajectory_time[m_nActiveIdx];
   for (int i = idx; i >= 0; i--)
   {
      temp_traj.push_back(trajectory_pos[i]);
      for (int j = 0; j < 5; j++)
         trajectory_vel[i][j] *= -1.0f;
      temp_traj_vel.push_back(trajectory_vel[i]);
      temp_times.push_back(cur_active_time_s - trajectory_time[i]);
   }

   trajectory_vel = temp_traj_vel;
   trajectory_time = temp_times;
   trajectory_pos = temp_traj;

//   for (int i = 0; i < temp_times.size(); i++)
//   {
//      for (int j = 0; j < 5; j++)
//         printf("%f\t", trajectory_pos[i][j]);

//      for (int j = 0; j < 5; j++)
//         printf("%f\t", trajectory_vel[i][j]);
//      printf("\n");
//   }

   m_fTimeIndex_s = 0.0;

   m_nActiveIdx = 0;
   m_bControllerActive = true;
   m_bTrajectoryActive = true;
   gettimeofday(&start_time, NULL);

}


void Controller::WriteToFile(int idx, float wp_time_s, float cur_time_s, vector<float> targs, vector<float> cur, vector<float> out)
{

   fstream logfile;
   logfile.open("trajlog.csv", fstream::app);
   logfile << idx << ",";
   logfile << wp_time_s << ",";
   logfile << cur_time_s << ",";
   for (int i = 0; i < 5; i++)
   {
      logfile << targs[i] << ",";
   }
   for (int i = 0; i < 5; i++)
   {
      logfile << cur[i] << ",";
   }
   for (int i = 0; i < 4; i++)
   {
      logfile << out[i] << ",";
   }
   logfile << out[4] << "\n";
   logfile.close();



}

void Controller::HoldPosition()
{
   target_thetas = m_pRobot->GetThetas();
   m_bControllerActive = true;
}

void Controller::SetNewTargetThetas(vector<float> targ)
{
   if (!m_bControllerActive || m_bTrajectoryActive)
      return;
   target_thetas = targ;
}
