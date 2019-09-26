
#include "CommHandler.h"
#include <sys/time.h>

using namespace std;

CommHandler::CommHandler() {
   comm = new tcp_client();
   gettimeofday(&last_tx_time, NULL);
}

bool CommHandler::Connect() {
   return comm->conn();
}

void CommHandler::ReceiveDataThread(list<Command>* cmd_list)
{
   while (1)
   {
      Command next_cmd;
      if (comm->receive(&next_cmd))
      {
         cmd_list->push_back(next_cmd);
      }
   }
}

void CommHandler::SendUpdate(RobotState rob_state, bool bForce)
{
   struct timeval cur_tx_time;
   gettimeofday(&cur_tx_time, NULL);

   long mtime = ((cur_tx_time.tv_sec - last_tx_time.tv_sec)*1000.0 + (cur_tx_time.tv_usec - last_tx_time.tv_usec)/1000.0);

   if (mtime > m_nTxTime_ms  || bForce)
   {
      comm->send_state(rob_state.OpMode, (uint8_t)rob_state.eMoveState, rob_state.thetas);
      gettimeofday(&last_tx_time, NULL);
   }
}

void CommHandler::SendPlannedTrajectory(vector<vector<float>> theta_traj)
{
   comm->send_traj(theta_traj);
}
