#ifndef SERVO_HANDLER_H
#define SERVO_HANDLER_H

#include <stdio.h>
#include <vector>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
//#include "Common_Structs.h"

//add the other includes here

//include files from Dynamixel SDK
#include "dynamixel/c++/include/dynamixel_sdk.h"

#define DOF 5
#define DEVICENAME  "/dev/ttyACM1"
#define PROTOCOL_VERSION 1.0


using namespace std;

class ServoHandler {

typedef struct {
   uint8_t bytes[2];
} GOAL_TX;

public:
   ServoHandler();

   bool Connect();
   int GetThetas(vector<float>* thetas);
   int Update(vector<float> theta_dot);
   int HoldPosition(bool just_shoulder = false);

private:
   dynamixel::PortHandler *portHandler;
   dynamixel::PacketHandler *packetHandler;
   dynamixel::GroupBulkRead *groupBulkRead;

   vector<uint16_t> zero_pos;

   int index;
   int dxl_comm_result;

   bool dxl_addparam_result;
   bool dxl_getdata_result;

   vector<int> dxl_goal_positions;
   vector<float> prev_thetas;

   bool m_bReadError;

   uint8_t dxl_error;

   vector<uint16_t> dxl_present_positions;
   vector<uint16_t> dxl_moving_speeds;
   vector<GOAL_TX> param_goal_positions;

   float cnts_per_radian;

   //control table addresses
   static const uint16_t ADDR_AX_TORQUE_ENABLE = 24;
   static const uint8_t  TORQUE_ENABLE = 1;

   static const int ADDR_AX_CW_LIMIT = 6;
   static const int ADDR_AX_CCW_LIMIT = 8;

   static const int ADDR_AX_GOAL_POSITION = 30;
   static const int ADDR_AX_PRESENT_POSITION = 36;
   static const int ADDR_AX_MOVING = 46;
   static const int ADDR_AX_MOVING_SPEED = 32; //moving or goal velocity

   //data byte length
   static const int LEN_AX_GOAL_POSITION = 2;
   static const int LEN_AX_PRESENT_POSITION = 2;
   static const int LEN_AX_MOVING = 1;

   //default setting
   static const int BAUDRATE = 1000000;

   static const int TORQUE_DISABLE = 0;

   vector<uint8_t> dxl_id;

   static const int DXL_MIN_POSITION = 24;
   static const int DXL_MAX_POSITION = 1000;
};

#endif
