#include <stdio.h>
#include <vector>
#include <iostream>
#include <thread>

#include "CommHandler.h"
#include "RobotArm.h"
#include "Common_Structs.h"
#include "TrajectoryGenerator.h"
#include "ArmHandler.h"
#include "EndEffector.h"

#ifdef REAL_BOT
#include "ServoHandler.h"
#else
#include "SimServoHandler.h"
#endif

using namespace std;

int main(int argc, char *argv[])
{

   CommHandler* comms = new CommHandler();
   if (!comms->Connect())
   {
      printf("Failed to connect... returning\n");
      return -1;
   }

#ifdef REAL_BOT
   ServoHandler* dynamixel = new ServoHandler();
#else
   SimServoHandler* dynamixel = new SimServoHandler();
#endif
   while (dynamixel->Connect() != 0)
   {
      printf("Failed to connect to dynamixels... trying once more\n");
      //return -1;
   }

   EndEffector* pArduino = new EndEffector();

   int iRet = pArduino->Connect();

   if (iRet != 0)
   {
     printf("Couldn't connect to arduino!!!\n");
     return -1;
   }

   list<Command>* cmd_list = new list<Command>;
   thread comm_thread(&CommHandler::ReceiveDataThread, comms, cmd_list);

   thread arduino_thread(&EndEffector::Receive, pArduino);

   fstream logfile;
   logfile.open("trajlog.csv", fstream::out);
   logfile.close();

   ArmHandler arm_handler(dynamixel, pArduino);

   arm_handler.Run(cmd_list, comms);
}

