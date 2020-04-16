#include "ArmHandler.h"

#include <signal.h>

using namespace std;

static volatile int keepRunning = 1;

void intHandler(int dummy) {
    keepRunning = 0;
}

#if REAL_BOT
ArmHandler::ArmHandler(ServoHandler* pServo, EndEffector* pArduino)
#else
ArmHandler::ArmHandler(SimServoHandler* pServo, EndEffector* pArduino)
#endif
{
   m_pServo = pServo;
   m_pArduino = pArduino;
   for (int i = 0; i < 5; i++)
   {
      home_thetas.push_back(0);
      targ_rot_vel.push_back(0);
   }
   for (int i = 0; i < 3; i++)
      ef_data.push_back(0);

   home_thetas[1] = -PI + 0.1;
   home_thetas[2] = PI - 0.1;
   tower_pose.x_m = 10;
   tower_pose.y_m = 10;

   m_bVacPower = false;
   m_bSuctionBlocked = false;
   m_bConstrained = false;

   m_fDeltaZPos_m = 0.005;

   data_logfile.open("data_log.csv", fstream::out);
}

void ArmHandler::Run(list<Command>* cmd_list, CommHandler* pComm)
{

   OP_STATE eState = IDLE;
   static OP_STATE eLastState = IDLE;


   m_pArduino->Transmit();

   vector<float> thetas(5);
   int iRet = m_pServo->GetThetas(&thetas);
   if (iRet != 0)
   {
      printf("Failure reading thetas!\n");
   }
   else
   {
//      printf("Thetas: %f\t%f\t%f\t%f\t%f\n",thetas[0],thetas[1],thetas[2],thetas[3],thetas[4]);
   }
   m_pRobot = new RobotArm(thetas);
   m_pController = new Controller(m_pRobot);
   m_pTrajectory = new TrajectoryGenerator(m_pRobot);
   //m_pVacuum = new VacuumHandler();
   m_pComms = pComm;

   m_pEstimator = new Estimator();

   RobotState robot_state;

   struct timeval cur_time, last_time;
   gettimeofday(&last_time,NULL);

   long mtime;

   RET_CODE eRet = ECODE_ACTIVE;

   float theta_err = 0.0;
   float kf_lowpass = 0.1;


   signal(SIGINT, intHandler);


   while (keepRunning)
   {
      gettimeofday(&cur_time, NULL);
      mtime = ((cur_time.tv_sec - last_time.tv_sec)*1000 + (cur_time.tv_usec - last_time.tv_usec)/1000);
      if (mtime > 9)
      {
         last_time = cur_time;
         iRet = m_pServo->GetThetas(&thetas);
         if (iRet != 0)
         {
            printf("Failure reading thetas!\n");
         }
         else
         {
  //          printf("Thetas: %f\t%f\t%f\t%f\t%f\n",thetas[0],thetas[1],thetas[2],thetas[3],thetas[4]);
         }
         ef_data = m_pArduino->GetMeasurements();
         m_pEstimator->Update(thetas, ef_data[0], ef_data[1], ef_data[2]);
         theta_err = (1-kf_lowpass)*theta_err + kf_lowpass*m_pEstimator->GetBaseDeflection();
         thetas[1] += theta_err;
         m_pRobot->Update(thetas);
         //m_bSuctionBlocked = m_pVacuum->Update(m_bVacPower);
      }


      switch (eState)
      {
         case IDLE:
            if (!cmd_list->empty())
            {
               printf("New Command Received!\n");
               Command cmd = cmd_list->front();
               eRet = ECODE_NO_ERROR;
               if ((CMD_TYPE)cmd.cmd_type == CMD_HOME)
               {
                  tower_pose.x_m = 10;
                  tower_pose.y_m = 10;
                  eState = GO_HOME;
               }
               else if ((CMD_TYPE)cmd.cmd_type == CMD_PICK)
               {
                  PickCommand = cmd;
                  tower_pose = CalculateTowerPose(cmd);
                  eState = PICK;
               }
               else if ((CMD_TYPE)cmd.cmd_type == CMD_PLACE)
               {
                  tower_pose.x_m = 10;
                  tower_pose.y_m = 10;
                  PlaceCommand = cmd;
                  eState = PUT;
               }
               else if ((CMD_TYPE)cmd.cmd_type == CMD_SMALL_MOVE)
               {
                  m_fDeltaZPos_m = cmd.point.z_m;
                  eState = SMALL_MOVE;
               }
               else
               {
                  printf("Unknown command: %d\n", cmd.cmd_type);
                  eRet = ECODE_ERROR;
               }
               cmd_list->pop_front();
            }
            break;

         case PICK:
            eRet = Pick();
            if (eRet == ECODE_NO_ERROR)
            {
               printf("Pick complete!\n");
               if (PickCommand.proceed)
                  eState = IDLE; //change to GO_HOME
               else
                  eState = IDLE;
               printf("Going to %d\n", eState);
            }
            else if (eRet != ECODE_ACTIVE)
               eState = IDLE;
            break;

         case PUT:
            m_bConstrained = false;
            eRet = Put();
            if (eRet == ECODE_NO_ERROR)
               eState = IDLE;
            else if (eRet != ECODE_ACTIVE)
               eState = IDLE;
            break;

         case GO_HOME:
            m_bConstrained = false;
            printf("Go home\n");
            eRet = GoHome();
            if (eRet != ECODE_ACTIVE)
               eState = IDLE;
            break;

         case SMALL_MOVE:
            eRet = GripBlock();
            if (eRet != ECODE_ACTIVE)
            {
               eState = IDLE;
            }
            break;

      }

      m_pArduino->Transmit();
      m_pController->Update(&targ_rot_vel, m_bConstrained);
      m_pServo->Update(targ_rot_vel);

//      vector<Point3D> base_pts = m_pRobot->GetBasePoints();
//      for (int i = 0; i < base_pts.size(); i++)
//         printf("%f\t", base_pts[i].z_m);
//      printf("\n");
//      Point3D ef_pose = m_pRobot->GetEndEffectorPose();
//      vector<float> temp_thetas = m_pRobot->GetThetas();
//      m_pRobot->Update(temp_thetas);
//      Point3D new_ef_pose = m_pRobot->GetEndEffectorPose();
//      printf("X: %f , %f\tY: %f, %f\tZ: %f, %f\tIR: %f, %f\n", ef_pose.x_m, new_ef_pose.x_m, ef_pose.y_m, new_ef_pose.y_m, ef_pose.z_m, new_ef_pose.z_m, ef_data[1]-0.022, ef_data[2]-0.022);
//      printf("X: %f\tY: %f\tZ: %f\tIR: %f, %f\n", new_ef_pose.x_m, new_ef_pose.y_m, new_ef_pose.z_m, ef_data[1]-0.022, ef_data[2]-0.022);

      robot_state.thetas = m_pRobot->GetThetas();
      robot_state.OpMode = eState;
      robot_state.eMoveState = eRet;

      WriteToLog(thetas, targ_rot_vel, ef_data);

      if (eState == IDLE && eLastState != eState)
         m_pComms->SendUpdate(robot_state, true);
      else
         m_pComms->SendUpdate(robot_state, false);

      eLastState = eState;
   }

   m_pServo->HoldPosition();

}

RET_CODE ArmHandler::GripBlock()
{

   static int eState = 0;
   RET_CODE eRet = ECODE_ACTIVE;

   static int fail_count = 0;

   vector<float> temp_targ(5);

   static bool first_time = true;
   static struct timeval start_time;
   if (first_time)
      gettimeofday(&start_time, NULL);
   struct timeval cur_time;
   gettimeofday(&cur_time, NULL);
   first_time = false;

   switch (eState)
   {

      case 0:
         m_pArduino->SetTargetGripperState(0);
         eState = 1;
         break;

      case 1:
         if (m_pArduino->GetGripperState() == GRIPPER_HOLDING)
            eState = 2;
         else if (m_pArduino->GetGripperState() == GRIPPER_CLOSE)
         {
            gettimeofday(&start_time, NULL);
            fail_count++;
            eState = 3;
            m_pArduino->SetTargetGripperState(1);
            if (fail_count > 3)
            {
               eState = 0;
               fail_count = 0;
               return ECODE_ERROR;
            }
            return ECODE_ACTIVE;
         }
         break;

      case 2:
         m_bConstrained = true;
         //eState = 0;
         //return ECODE_NO_ERROR;
         float targ_z_pos;
         Point3D ef_point;
         ef_point = m_pRobot->GetEndEffectorPose();
         ef_point.z_m += m_fDeltaZPos_m;
         eRet = m_pRobot->InverseKinematics_XY(ef_point, tower_pose.yaw_rad, &temp_targ);
         if (eRet == ECODE_NO_ERROR)
         {
            if (PickCommand.proceed == 2)
               temp_targ[4] += 0.1;
            m_pController->SetNewTargetThetas(temp_targ);
            eState = 0;
         }
         break;
       case 3:
          if (cur_time.tv_sec - start_time.tv_sec > 5)
          {
             eState = 0;
          }
          return ECODE_ACTIVE;


   }
   return eRet;
}
RET_CODE ArmHandler::Pick()
{

   static ACTION_STATE eState = PLAN;

   RET_CODE eRet = ECODE_ACTIVE;

   switch (eState)
   {
      case PLAN:
         printf("plan\n");

//         m_pServo->HoldPosition();

         Point3D pick_pt;
         pick_pt.x_m = PickCommand.point.x_m - fPickOffsetDistance_m*cos(PickCommand.yaw);
         pick_pt.y_m = PickCommand.point.y_m - fPickOffsetDistance_m*sin(PickCommand.yaw);
         pick_pt.z_m = PickCommand.point.z_m - m_fOrigin_ToSurface_m;
         m_pServo->HoldPosition(true);
         eRet = m_pTrajectory->Plan(pick_pt, PickCommand.yaw, tower_pose);
         if (eRet == ECODE_NO_ERROR)
         {
            vector<vector<float>> traj = m_pTrajectory->GetPlannedTrajectory();
            traj[0] = m_pRobot->GetThetas();
            m_pComms->SendPlannedTrajectory(traj);
            if (PickCommand.proceed)
            {
               eRet = m_pController->SetNewTrajectory(traj);
               if (eRet != ECODE_NO_ERROR)
               {
                  printf("Couldn't set trajectory!!!\n");
                  return eRet;
               }
               else
               {
                  eState = GO_TO;
               }
            }
            else
               return ECODE_NO_ERROR;
            return ECODE_ACTIVE;
         }
         return eRet;

      case GO_TO:
         if (!m_pController->TrajectoryActive())
         {
            //complete
            m_bVacPower = true;
            eState = EXECUTE;
//            return ECODE_NO_ERROR;
         }
         return ECODE_ACTIVE;

      case EXECUTE:
         eRet = PickBlock();
         if (eRet != ECODE_ACTIVE)
            eState = PLAN;
         break;
   }
   return eRet; //active
}

RET_CODE ArmHandler::Put()
{
   static ACTION_STATE eState = PLAN;

   RET_CODE eRet = ECODE_ACTIVE;

   switch (eState)
   {
      case PLAN:

//         m_pServo->HoldPosition();
         Point3D place_pt;
         place_pt = PlaceCommand.point;
         place_pt.z_m -= m_fOrigin_ToSurface_m;
         m_pServo->HoldPosition(true);
         eRet = m_pTrajectory->Plan(PlaceCommand.point, PlaceCommand.yaw, tower_pose);
         if (eRet == ECODE_NO_ERROR)
         {
            vector<vector<float>> traj = m_pTrajectory->GetPlannedTrajectory();
            if (PlaceCommand.proceed)
            {
               eRet = m_pController->SetNewTrajectory(traj);
               if (eRet != ECODE_NO_ERROR)
               {
                  printf("Couldn't Tx trajectory!!!\n");
                  return eRet;
               }
               else
               {
                  m_pComms->SendPlannedTrajectory(traj);
                  eState = GO_TO;
               }
            }
            return ECODE_ACTIVE;
         }
         return eRet;

      case GO_TO:
         if (!m_pController->TrajectoryActive())
         {
            eState = EXECUTE;
         }
         return ECODE_ACTIVE;

      case EXECUTE:
         eRet = PlaceBlock();
         if (eRet != ECODE_ACTIVE)
            eState = PLAN;
         break;
   }
   return eRet; //active
}

RET_CODE ArmHandler::GoHome()
{
   static ACTION_STATE eState = PLAN;

   RET_CODE eRet = ECODE_ACTIVE;

   switch (eState)
   {
      case PLAN:

//         m_pServo->HoldPosition();
         m_pServo->HoldPosition(true);
         eRet = m_pTrajectory->PlanToTheta(home_thetas, tower_pose);
         if (eRet == ECODE_NO_ERROR)
         {
            vector<vector<float>> traj = m_pTrajectory->GetPlannedTrajectory();
            eRet = m_pController->SetNewTrajectory(traj);
            if (eRet != ECODE_NO_ERROR)
            {
               printf("Couldn't set trajectory!!!\n");
               return eRet;
            }
            else
            {
               m_pComms->SendPlannedTrajectory(traj);
               eState = GO_TO;
               return ECODE_ACTIVE;
            }
         }
         return eRet;

      case GO_TO:
         if (!m_pController->TrajectoryActive())
         {
            eState = PLAN;
            m_bVacPower = false;
            return ECODE_NO_ERROR;
         }
         return ECODE_ACTIVE;
      case EXECUTE:
         return ECODE_ERROR;
   }
   return eRet;
}

Pose2D ArmHandler::CalculateTowerPose(Command cmd)
{
   Pose2D pose;
   pose.x_m = cmd.point.x_m + 0.0375*cos(cmd.yaw);
   pose.y_m = cmd.point.y_m + 0.0375*sin(cmd.yaw);
   pose.yaw_rad = cmd.yaw;
   printf("Tower Pose: %f, %f, %f\n",pose.x_m, pose.y_m, pose.yaw_rad);

   fstream logfile;
   logfile.open("spherelog.csv", fstream::out);
   logfile << pose.x_m << "," << pose.y_m << "," << pose.yaw_rad << ",0,0,0\n";
   logfile.close();

   logfile.open("logfile.csv", fstream::out);
   logfile.close();

   return pose;
}

RET_CODE ArmHandler::PickBlock()
{

   static PICK_STATE ePickState = PICK_WAIT;

   static vector<float> targ_thetas(5);
   vector<vector<float>> traj;

   static int in_out_num = 0;

   RET_CODE eRet = ECODE_ACTIVE;

   static bool first_time = true;
   static struct timeval start_time;
   if (first_time)
      gettimeofday(&start_time, NULL);
   struct timeval cur_time;
   gettimeofday(&cur_time, NULL);
   first_time = false;

   switch (ePickState)
   {
      case PICK_WAIT:

         if (cur_time.tv_sec - start_time.tv_sec > 2)
         {
            ePickState = PICK_PLAN;
         }
         return ECODE_ACTIVE;

      case PICK_PLAN:

         Point3D start_pt;
         start_pt.x_m = PickCommand.point.x_m - fPickOffsetDistance_m*cos(PickCommand.yaw);
         start_pt.y_m = PickCommand.point.y_m - fPickOffsetDistance_m*sin(PickCommand.yaw);
         start_pt.z_m = PickCommand.point.z_m - m_fOrigin_ToSurface_m;

         Point3D end_pt;
         end_pt.x_m = PickCommand.point.x_m + 0.01*cos(PickCommand.yaw);
         end_pt.y_m = PickCommand.point.y_m + 0.01*sin(PickCommand.yaw);
         end_pt.z_m = PickCommand.point.z_m - m_fOrigin_ToSurface_m;

         traj = DiscretizeTrajectory(start_pt, end_pt, 31);
         eRet = m_pController->SetNewTrajectory(traj);
         if (eRet != ECODE_NO_ERROR)
         {
            printf("Couldn't set trajectory!!!\n");
            return eRet;
         }
         else
         {
            m_pComms->SendPlannedTrajectory(traj);
            ePickState = PICK_GO_IN;
            return ECODE_ACTIVE;
         }

      case PICK_GO_IN:
         //if (m_bSuctionBlocked)
         //   printf("Block Detected!!!\n");
         if (!m_pController->TrajectoryActive())
         {
         //   printf("Never detected current drop!!!\n");
            //complete
            ePickState = PICK_WAIT_IN;
            gettimeofday(&start_time, NULL);
         }
         return ECODE_ACTIVE;

      case PICK_WAIT_IN:

         if (cur_time.tv_sec - start_time.tv_sec > 5)
         {
            ePickState = PICK_GRIP_BLOCK;
         }
         return ECODE_ACTIVE;


      case PICK_GRIP_BLOCK:
         eRet = GripBlock();
         if (eRet != ECODE_ACTIVE)
         {
            ePickState = PICK_WAIT;
            return ECODE_NO_ERROR;
         }
         return ECODE_ACTIVE;
   }

   return ECODE_NO_ERROR;
}

RET_CODE ArmHandler::PlaceBlock()
{
   m_pArduino->SetTargetGripperState(1);
   return ECODE_NO_ERROR;
}


void ArmHandler::WriteToLog(vector<float> theta, vector<float> output, vector<float> data)
{
   for (int i = 0; i < 5; i++)
   {
      data_logfile << theta[i] << ",";
   }

   for (int i = 0; i < 5; i++)
   {
      data_logfile << output[i] << ",";
   }

   for (int i = 0; i < 2; i++)
      data_logfile << data[i] << ",";
   data_logfile << data[2] << "\n";
}

RET_CODE ArmHandler::TransmitTrajectory(vector<vector<float>> traj)
{
   float max_dt = 0.1;

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

   vector<float> times(32);
   for (int i = 1; i < 32; i++)
      times[i] = times[i-1] + max_dt;

//   m_pArduino->TransmitTrajectory(traj, times);

   return ECODE_NO_ERROR;
}

vector<vector<float>> ArmHandler::DiscretizeTrajectory(Point3D start_pt, Point3D end_pt, int num_pts)
{
   vector<vector<float>> traj;
   vector<float> row(5);

   float dx = end_pt.x_m - start_pt.x_m;
   float dy = end_pt.y_m - start_pt.y_m;
   float dz = end_pt.z_m - start_pt.z_m;

   RET_CODE eRet = ECODE_ACTIVE;

   for (int i = 0; i <= num_pts; i++)
   {
      vector<float> temp_row;
      Point3D pt;
      pt.x_m = start_pt.x_m + dx*float(i)/float(num_pts);
      pt.y_m = start_pt.y_m + dy*float(i)/float(num_pts);
      pt.z_m = start_pt.z_m + dz*float(i)/float(num_pts);
//      printf("TrajPt: %d |\t%f\t%f\t%f\n",i, pt.x_m, pt.y_m, pt.z_m);
      eRet = m_pRobot->InverseKinematics_XY(pt, tower_pose.yaw_rad, &temp_row);
      if (eRet == ECODE_NO_ERROR)
      {
         row = temp_row;
      }
      else
      {
         printf("Warning point can't be reached!!!\n");
      }
      traj.push_back(row);
   }

   return traj;
}
