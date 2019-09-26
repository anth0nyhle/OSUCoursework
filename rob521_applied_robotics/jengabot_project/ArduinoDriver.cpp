#include <stdio.h>
#include <unistd.h>			//Used for UART
#include <fcntl.h>			//Used for UART
#include <termios.h>		//Used for UART
#include <sys/time.h>

#include "ArduinoDriver.h"


using namespace std;

ArduinoDriver::ArduinoDriver() {

   eCommState = eState_Find_COMMAND_0;

   for (int i = 0; i < 5; i++)
      cur_theta.push_back(0);

   m_bCanTx = false;
}

int ArduinoDriver::Connect() {

   uart0_filestream = open("/dev/ttyUSB0", O_RDWR | O_NOCTTY);
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

RET_CODE ArduinoDriver::TransmitTrajectory(vector<vector<float>> traj, vector<float> times)
{
   uint8_t Packet[16];
   static int k = 0;

   struct timeval cur_time;
   gettimeofday(&cur_time, NULL);
   static struct timeval last_time = cur_time;

   long mtime = (cur_time.tv_sec - last_time.tv_sec)*1000 + (cur_time.tv_usec - last_time.tv_usec)/1000;

   if (mtime > 5 && m_bCanTx)
   {
      Packet[0] = 0xFF;
      Packet[1] = (uint8_t)k;
      uint16_t traj_time = (uint16_t)(times[k]*1000);
      Packet[2] = (uint8_t)(traj_time & 0xFF);
      Packet[3] = (uint8_t)((traj_time >> 8) & 0xFF);
      for (int j = 0; j < 5; j++)
      {
         int16_t traj_pt = (int16_t)(traj[k][j]*1000);
         Packet[4+j*2] = (uint8_t)(traj_pt & 0xFF);
         Packet[5+j*2] = (uint8_t)((traj_pt >> 8) & 0xFF);
      }

      uint16_t calc_crc[7] = {0, 0, 0, 0, 0, 0, 0};
      for (int i = 0; i < 7; i++)
         calc_crc[i] = (uint16_t)Packet[i*2] + ((uint16_t)Packet[i*2 + 1] << 8);
      uint32_t chk32 = 0;
      for (int i = 0; i < 7; i++)
        chk32 = (chk32 << 1) + calc_crc[i];
      uint32_t checksum = (chk32 & ((1 << 15) - 1)) + (chk32 >> 15);
      checksum = (uint16_t)(checksum & ((1 << 15) - 1));

      Packet[14] = (uint8_t)(checksum & 0xFF);
      Packet[15] = (uint8_t)(checksum >> 8);
      if (uart0_filestream != -1)
      {
         int count = write(uart0_filestream, &Packet[0], 16);//Filestream, bytes to write, number of bytes to write
         if (count < 0)
         {
            printf("UART TX error\n");
         }
      }
      last_time = cur_time;
      k++;
   }
   if (k == 32)
   {
      k = 0;
      return ECODE_NO_ERROR;
   }
   return ECODE_ACTIVE;
}

bool ArduinoDriver::PacketValid() {

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

void ArduinoDriver::ProcessPacket() {

   bTrajectoryActive = uPacketData[OFFSET_TO_TRAJ_ACTIVE] > 0;
   bTrajectoryComplete = uPacketData[OFFSET_TO_TRAJ_COMPLETE] > 0;

   printf("%d\t%d\t",(int)bTrajectoryActive,(int)bTrajectoryComplete);

   for (int i = 0; i < 5; i++)
   {
      uint8_t low_byte = uPacketData[OFFSET_TO_POS_START + 2*i];
      uint8_t high_byte = uPacketData[OFFSET_TO_POS_START + 2*i + 1];
      int16_t mrad = (int16_t)(high_byte << 8) | low_byte;
      cur_theta[i] = float(mrad)/1000;
      printf("%f\t",cur_theta[i]);
   }
   printf("\n");
}

void ArduinoDriver::Receive() {

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
            m_bCanTx = false;
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
                  m_bCanTx = true;
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
