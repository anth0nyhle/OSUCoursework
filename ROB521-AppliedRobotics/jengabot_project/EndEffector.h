#ifndef END_EFFECTOR_H
#define END_EFFECTOR_H

#include <list>
#include <vector>
#include <stdint.h>
#include "Common_Structs.h"

using namespace std;

class EndEffector
{

public:

   EndEffector();
   void Receive();
   int Connect();

   RET_CODE Transmit();

   vector<float> GetMeasurements() { return data;}

   GRIPPER_STATE GetGripperState() { return gripper_state; }

   void SetTargetGripperState(uint8_t grip_state) { target_gripper_state = grip_state; }

private:

   int uart0_filestream;

   bool PacketValid();
   void ProcessPacket();

   vector<float> data;

   static const int OFFSET_TO_START = 0;
   static const int OFFSET_TO_PSI_POS = OFFSET_TO_START + 2;
   static const int OFFSET_TO_LEFT_IR = OFFSET_TO_PSI_POS + 4;
   static const int OFFSET_TO_RIGHT_IR = OFFSET_TO_LEFT_IR + 2;
   static const int OFFSET_TO_SERVO_POS = OFFSET_TO_RIGHT_IR + 2;
   static const int OFFSET_TO_CRC_L = OFFSET_TO_SERVO_POS + 2;
   static const int OFFSET_TO_CRC_M = OFFSET_TO_CRC_L + 1;
   static const int PACKET_LENGTH = OFFSET_TO_CRC_M + 1;

   static const uint16_t ir_offset = 0;
   static constexpr float ir_sf = 1.0;

   static const int eState_Find_COMMAND_0 = 0;
   static const int eState_Find_COMMAND_1 = 1;
   static const uint8_t COMMAND_0 = 100;
   static const uint8_t COMMAND_1 = 101;

   uint8_t uPacketData[PACKET_LENGTH];

   uint8_t target_gripper_state;

   int eCommState;
   GRIPPER_STATE gripper_state;
};
#endif
