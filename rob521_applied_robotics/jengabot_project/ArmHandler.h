#ifndef ARM_HANDLER_H
#define ARM_HANDLER_H

#include <vector>
#include <list>
#include "Common_Structs.h"
#include "CommHandler.h"
#include "TrajectoryGenerator.h"
#include "RobotArm.h"
#include "Controller.h"
#include "EndEffector.h"
#include "Estimator.h"
#include "VacuumHandler.h"

#ifdef REAL_BOT
#include "ServoHandler.h"
#else
#include "SimServoHandler.h"
#endif

class ArmHandler {

public:
#ifdef REAL_BOT
  ArmHandler(ServoHandler* pServo, EndEffector* pArduino);
#else
  ArmHandler(SimServoHandler* pServo, EndEffector* pArduino);
#endif
  void Run(list<Command>* cmd_list, CommHandler* m_pComm);

private:

  RET_CODE Pick();
  RET_CODE Put();
  RET_CODE GoHome();

  RET_CODE GripBlock();

  RET_CODE PickBlock();
  RET_CODE PlaceBlock();

  RET_CODE TransmitTrajectory(vector<vector<float>> traj);
  vector<vector<float>> DiscretizeTrajectory(Point3D start_pt, Point3D end_pt, int num_pts);

  Pose2D CalculateTowerPose(Command cmd);
  RobotArm* m_pRobot;

  fstream data_logfile;

  bool m_bVacPower;
  bool m_bSuctionBlocked;
  bool m_bConstrained;

  float m_fDeltaZPos_m;

  static constexpr float fPickOffsetDistance_m = 0.02;

  void WriteToLog(vector<float> theta, vector<float> output, vector<float> data);

  Command PickCommand;
  Command PlaceCommand;
#ifdef REAL_BOT
  ServoHandler* m_pServo;
#else
  SimServoHandler* m_pServo;
#endif
  Controller* m_pController;
  TrajectoryGenerator* m_pTrajectory;
  CommHandler* m_pComms;
  EndEffector* m_pArduino;
  Estimator* m_pEstimator;
  VacuumHandler* m_pVacuum;

  Pose2D tower_pose;
  vector<float> home_thetas;
  vector<float> targ_rot_vel;

  vector<float> ef_data;

};

#endif

