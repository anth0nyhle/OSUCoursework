#ifndef ARDUINO_DRIVER_H
#define ARDUINO_DRIVER_H

#include <list>
#include <vector>
#include <stdint.h>
#include "Common_Structs.h"

using namespace std;

class ArduinoDriver
{

#define ARDUINO_DATA_SIZE 3

public:

   ArduinoDriver();
   void Receive();
   int Connect();

   RET_CODE TransmitTrajectory(vector<vector<float>> thetas, vector<float> times);

   bool TrajectoryActive() { return bTrajectoryActive; }
   bool TrajectoryComplete() { return bTrajectoryComplete; }

   vector<float> GetThetas() { return cur_theta;}

private:

   int uart0_filestream;

   bool PacketValid();
   void ProcessPacket();

   bool bTrajectoryActive;
   bool bTrajectoryComplete;
   bool m_bCanTx;

   vector<float> cur_theta;

   void TransmitData(std::list<vector<int>>* tx_msg);

   static const int OFFSET_TO_START = 0;
   static const int OFFSET_TO_TRAJ_ACTIVE = OFFSET_TO_START + 2;
   static const int OFFSET_TO_TRAJ_COMPLETE = OFFSET_TO_TRAJ_ACTIVE + 1;
   static const int OFFSET_TO_POS_START = OFFSET_TO_TRAJ_COMPLETE + 1;
   static const int OFFSET_TO_CRC_L = OFFSET_TO_POS_START + 10;
   static const int OFFSET_TO_CRC_M = OFFSET_TO_CRC_L + 1;
   static const int PACKET_LENGTH = OFFSET_TO_CRC_M + 1;

   static const int eState_Find_COMMAND_0 = 0;
   static const int eState_Find_COMMAND_1 = 1;
   static const uint8_t COMMAND_0 = 100;
   static const uint8_t COMMAND_1 = 101;

   uint8_t uPacketData[PACKET_LENGTH];

   int eCommState;
};
#endif
