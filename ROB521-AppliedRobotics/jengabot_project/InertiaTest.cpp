#include "InertiaTest.h"

using namespace std;

InertiaTest::InertiaTest() {

   //constructor... initialize variables here
   //index = 0;
   dxl_comm_result = 0;
   dxl_addparam_result = false;
   dxl_getdata_result = false;

   dxl_error = 0;
   GOAL_TX empty;
   for (int i = 0; i < DOF; i++){
      dxl_id.push_back(i + 102);
      dxl_present_positions.push_back(0);
      dxl_moving_speeds.push_back(0);
      param_goal_positions.push_back(empty);
   }

   //1024 cnts total in joint mode
   //2047 cnts total in wheel mode
   //0-1023 CCW
   //1024-2047 CW
   //1cnt = 0.29deg = 0.00511326929293rad
   cnts_per_radian = 0;

   for (int i = 0; i < DOF; i++)
      zero_pos.push_back(512);
}

bool InertiaTest::Connect() {
   //connect to devices here
   //return true if successful... false otherwise
   //also do any configuration stuff here

   //initialize PortHandler instance
   portHandler = dynamixel::PortHandler::getPortHandler(DEVICENAME);
   //dynamixel::PortHandler *portHandler = dynamixel::PortHandler::getPortHandler(DEVICENAME);

   //initialize PacketHandler instance
   packetHandler = dynamixel::PacketHandler::getPacketHandler(PROTOCOL_VERSION);
   //dynamixel::PacketHandler *packetHandler = dynamixel::PacketHandler::getPacketHandler(PROTOCOL_VERSION);

   int dxl_comm_result = COMM_TX_FAIL;
   uint8_t dxl_error = 0;

   //bool dxl_addparam_result = false;

   //open port
   if (portHandler->openPort())
   {
      printf("Succeeded to open the port!\n");
   }
   else
   {
      printf("Failed to open the port!\n");
      return -1;
   }
   //set port baudrate
   if (portHandler->setBaudRate(BAUDRATE))
   {
      printf("Succeeded to change the baudrate!\n");
   }
   else
   {
      printf("Failed to change the baudrate!\n");
      return -1;
   }


   //enable all torque for all servos
   for (int i = 0; i < DOF; i++) {
      dxl_comm_result = packetHandler->write1ByteTxRx(portHandler, dxl_id[i], ADDR_AX_TORQUE_ENABLE, TORQUE_ENABLE, &dxl_error);
      if (dxl_comm_result != COMM_SUCCESS)
      {
         packetHandler -> printTxRxResult(dxl_comm_result);
         return -1;
      }
      else if (dxl_error != 0)
      {
         packetHandler -> printRxPacketError(dxl_error);
         return -1;
      }
      else
      {
         printf("Dynamixel#%d has been successfully connected \n", dxl_id[i]);
      }
      dxl_comm_result = packetHandler->write2ByteTxRx(portHandler, dxl_id[i], ADDR_AX_CW_LIMIT, 0, &dxl_error);
      if (dxl_comm_result != COMM_SUCCESS)
      {
         printf("Failed setting wheel mode p1\n");
         packetHandler -> printTxRxResult(dxl_comm_result);
         return -1;
      }
      else if (dxl_error != 0)
      {
         printf("Failed setting wheel mode p1\n");
         packetHandler -> printRxPacketError(dxl_error);
         return -1;
      }
      dxl_comm_result=packetHandler->write2ByteTxRx(portHandler, dxl_id[i], ADDR_AX_CCW_LIMIT, 0, &dxl_error);
      if (dxl_comm_result != COMM_SUCCESS)
      {
         printf("Failed setting wheel mode p1\n");
         packetHandler -> printTxRxResult(dxl_comm_result);
         return -1;
      }
      else if (dxl_error != 0)
      {
         printf("Failed setting wheel mode p1\n");
         packetHandler -> printRxPacketError(dxl_error);
         return -1;
      }

   }

   return 0;
}

int InertiaTest::GetThetas(vector<float>* thetas)
{
   for (int i = 0; i < DOF; i++)
   {
      dxl_comm_result = packetHandler->read2ByteTxRx(portHandler, dxl_id[i], ADDR_AX_PRESENT_POSITION, &dxl_present_positions[i], &dxl_error);
      if (dxl_comm_result != COMM_SUCCESS)
      {
        packetHandler->printTxRxResult(dxl_comm_result);
      }
      else if (dxl_error != 0)
      {
        packetHandler->printRxPacketError(dxl_error);
      }
   }

   //1rad = 195.5695825cnts
   cnts_per_radian = 1.0/0.0015339808;

   //for each servo
   for (int i = 0; i < DOF; i++) {
      (*thetas)[i+1] = float(dxl_present_positions[i] - zero_pos[i]) * (1/cnts_per_radian);
      if (i == 4)
         (*thetas)[i] *= -1.0f;
      printf("Position: %f rad\n",(*thetas)[i+1]);
   }

   //thetas[0] = dxl1_present_position * (1/cnts_per_radian);

   return 0;//if good... if there was a read error return -1;
}

int InertiaTest::Update(vector<float> theta_dot)
{
   uint8_t dxl_error = 0;

   //allocate goal positions values into byte array
   for (int i = 0; i < DOF; i++) {
      int vel_cps = 0;
      if (i < 4)
         vel_cps = int(-theta_dot[i] * cnts_per_radian) + 1023;
      else
         vel_cps = int(theta_dot[i] * cnts_per_radian) + 1023;
      if (vel_cps < 0)
         vel_cps = 0;
      if (vel_cps > 2047)
         vel_cps = 2047;
      if (vel_cps <= 1023)
         vel_cps = 1023 - vel_cps;
      vel_cps = 200;
      //param_goal_positions[i].bytes[0] = DXL_LOBYTE(vel_cps);
      //param_goal_positions[i].bytes[1] = DXL_HIBYTE(vel_cps);
      int dxl_comm_result = packetHandler -> write2ByteTxRx(portHandler, dxl_id[i], ADDR_AX_MOVING_SPEED, uint16_t(vel_cps), &dxl_error);
      if (dxl_comm_result != COMM_SUCCESS)
      {
         printf("Failed setting wheel speed\n");
         packetHandler -> printTxRxResult(dxl_comm_result);
         return -1;
      }
      else if (dxl_error != 0)
      {
         printf("Failed setting wheel speed\n");
         packetHandler -> printRxPacketError(dxl_error);
         return -1;
      }

   }

   return 0;//if good... if there was a write error return -1;
}

int InertiaTest::HoldPosition()
{

   return 0;
   //send all zeros for velocity targets
   int dxl_comm_result = COMM_TX_FAIL;

   for (int i = 0; i < DOF; i++) {
      dxl_moving_speeds[i] = 0;
   }

   for (int i = 0; i < DOF; i++) {
      dxl_comm_result = packetHandler -> write2ByteTxRx(portHandler, dxl_id[i], ADDR_AX_MOVING_SPEED, dxl_moving_speeds[i], &dxl_error);
   }

   if (dxl_comm_result != COMM_SUCCESS)
      return -1;

   return 0;
}
