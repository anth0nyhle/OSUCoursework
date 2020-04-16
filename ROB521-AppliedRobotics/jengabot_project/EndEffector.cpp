#include <stdio.h>
#include <unistd.h>			//Used for UART
#include <fcntl.h>			//Used for UART
#include <termios.h>		//Used for UART
#include <sys/time.h>

#include "EndEffector.h"


using namespace std;

EndEffector::EndEffector() {

   eCommState = eState_Find_COMMAND_0;

   for (int i = 0; i < 3; i++)
      data.push_back(0);

   gripper_state = GRIPPER_MOVING;
   target_gripper_state = 1;
}

int EndEffector::Connect() {

   uart0_filestream = open("/dev/ttyACM0", O_RDWR | O_NOCTTY);
   if (uart0_filestream == -1)
   {
      printf("Error - unable to open arduino serial port\n");
      return -1;
   }

   struct termios options;
   tcgetattr(uart0_filestream, &options);
   options.c_cflag = B115200 | CS8 | CLOCAL | CREAD;		//<Set baud rate
   options.c_iflag = IGNPAR;
   options.c_oflag = 0;
   options.c_lflag = 0;
   tcflush(uart0_filestream, TCIFLUSH);
   tcsetattr(uart0_filestream, TCSANOW, &options);

   //----- TX BYTES -----
   unsigned char tx_buffer[1];
   tx_buffer[0] = 0;
   if (uart0_filestream != -1)
   {
      int count = write(uart0_filestream, &tx_buffer[0], 1);//Filestream, bytes to write, number of bytes to write
      if (count < 0)
      {
         printf("UART TX error\n");
      }
   }

   return 0;
}

RET_CODE EndEffector::Transmit()
{
   uint8_t Packet[1];
   Packet[0] = target_gripper_state;
   if (uart0_filestream != -1)
   {
//      printf("Sending: %d\n", Packet[0]);
      int count = write(uart0_filestream, &Packet[0], 1);//Filestream, bytes to write, number of bytes to write
      if (count < 0)
      {
         printf("UART TX error\n");
      }
   }
   return ECODE_NO_ERROR;
}

bool EndEffector::PacketValid() {

   unsigned long chk32;
   unsigned long checksum;
   const int bytesToCheck = PACKET_LENGTH - 2;
   const int CalcCRC_Len = bytesToCheck / 2;
   unsigned int CalcCRC[CalcCRC_Len];

   uint8_t b1a, b1b, b2a, b2b;
   int ix;

   for (int ix = 0; ix < CalcCRC_Len; ix++)       // initialize 'CalcCRC' array
     CalcCRC[ix] = 0;

   // Perform checksum validity test
   for (ix = 0; ix < bytesToCheck; ix += 2)      // build 'CalcCRC' array
     CalcCRC[ix / 2] = uPacketData[ix] + ((uPacketData[ix + 1]) << 8);

   chk32 = 0;
   for (ix = 0; ix < CalcCRC_Len; ix++)
     chk32 = (chk32 << 1) + CalcCRC[ix];
   checksum = (chk32 & 0x7FFF) + (chk32 >> 15);
   checksum &= 0x7FFF;
   b1a = checksum & 0xFF;
   b1b = uPacketData[OFFSET_TO_CRC_L];
   b2a = checksum >> 8;
   b2b = uPacketData[OFFSET_TO_CRC_M];
   if ((b1a == b1b) && (b2a == b2b))
     return true;                       // okay
   else
     return false;                     // non-zero = bad CRC
}

void EndEffector::ProcessPacket() {

   uint32_t biased_psi = 0;
   for (int i = 3; i >= 0; i--)
      biased_psi = biased_psi << 8 | ((uint32_t)uPacketData[OFFSET_TO_PSI_POS + i]);
   int32_t psi = (uint64_t)biased_psi - (1 << 31 - 1);
   static int nCount = 0;


   data[0] = -float(psi)/1000 - 0.02f;

   uint16_t left_ir = ((uint16_t)uPacketData[OFFSET_TO_LEFT_IR + 1] << 8) | (uint16_t)uPacketData[OFFSET_TO_LEFT_IR];
   uint16_t right_ir = ((uint16_t)uPacketData[OFFSET_TO_RIGHT_IR + 1] << 8) | (uint16_t)uPacketData[OFFSET_TO_RIGHT_IR];
   uint16_t servo_pos = ((uint16_t)uPacketData[OFFSET_TO_SERVO_POS + 1] << 8) | (uint16_t)uPacketData[OFFSET_TO_SERVO_POS];

   if (servo_pos < 200 && servo_pos > 170)
   {
      nCount++;
      if (nCount > 30)
         gripper_state = GRIPPER_HOLDING;
      else
         gripper_state = GRIPPER_MOVING;
   }
   else
   {
      if (servo_pos < 100)
         gripper_state = GRIPPER_OPEN;
      else if (servo_pos > 200)
         gripper_state = GRIPPER_CLOSE;
      else
         gripper_state = GRIPPER_MOVING;
      nCount = 0;
   }

   //float vl = 5.0*float(left_ir)/1023;
   //float vr = 5.0*float(right_ir)/1023;

   //data[1] = 0.13/(vl+0.001) - 0.002;
   //data[2] = 0.12/(vr+0.001) + 0.002;

   data[1] = 14.97/(float(left_ir)+0.001) + 0.024;
   data[2] = 13.36/(float(right_ir)+0.001) + 0.041;

   if (data[1] > 0.3)
      data[1] = 0.3;
   if (data[2] > 0.3)
      data[2] = 0.3;

//   for (int i = 0; i < 3; i++)
//      printf("%f\t", data[i]);

//   printf("%d\n", servo_pos);
}

void EndEffector::Receive() {

   static int msg_idx = 0;

   while (1)
   {
      if (uart0_filestream != -1)
      {
         //read 1 byte from serial port
         unsigned char rx_buffer[1];
         int rx_length = read(uart0_filestream,  (void*)rx_buffer, 1);
         if (rx_length > 0)
         {
            uint8_t rx_byte = rx_buffer[0];
            if (eCommState == eState_Find_COMMAND_0)
            {
               if (rx_byte == COMMAND_0)
               {
                  eCommState++;
                  uPacketData[msg_idx] = rx_byte;
                  msg_idx++;
               }
            }
            else if (eCommState == eState_Find_COMMAND_1)
            {
               if (rx_byte == COMMAND_1)
               {
                  eCommState++;
                  uPacketData[msg_idx] = rx_byte;
                  msg_idx++;
               }
               else {
                  msg_idx = 0;
                  eCommState = eState_Find_COMMAND_0;
               }
            }
            else {
               uPacketData[msg_idx] = rx_byte;
               msg_idx++;
               if (msg_idx == PACKET_LENGTH)
               {
                  if (!PacketValid())
                  {

                     msg_idx = 0;
                     eCommState = eState_Find_COMMAND_0;
                  }
                  else
                  {
                     ProcessPacket();
                     msg_idx = 0;
                     eCommState = eState_Find_COMMAND_0;
                  }

               }
            }
         }

      }
   }
}
