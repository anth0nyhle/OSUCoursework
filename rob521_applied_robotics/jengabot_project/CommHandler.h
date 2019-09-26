#ifndef COMM_HANDLER_H
#define COMM_HANDLER_H

#include <stdio.h>
#include <thread>
#include <list>
#include <vector>
#include <sys/time.h>

#include "Common_Structs.h"
#include "tcp_client.h"

using namespace std;

class CommHandler
{

public:

   CommHandler();
   void ReceiveDataThread(list<Command>* cmd_list);
   bool Connect();

   void SendUpdate(RobotState robot_state, bool bForce = false);
   void SendPlannedTrajectory(vector<vector<float>> theta_traj);

private:

   tcp_client* comm;

   struct timeval last_tx_time;
   static const long m_nTxTime_ms = 250;

};
#endif
