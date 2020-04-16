#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>
#include "I2Cdv.h"
#include "MPU6000.h"
#include <sys/time.h>

MPU6000 imu;

int16_t ax, ay, az;
int16_t gx, gy, gz;

void error(char *msg) {
	perror(msg);
	exit(1);
}

int func(int a) {
	return 2 * a;
}

int main(int argc, char *argv[])
{
//   printf("Initializing I2C devices...\n");
//   imu.initialize();

   // verify connection
//   printf("Testing device connections...\n");
//   printf(imu.testConnection() ? "MPU6000 connection successful\n" : "MPU6000 connection failed\n");

   int n;
   int data;

   struct timeval now, last;
   gettimeofday(&last, NULL);
   long micros;
   while (true)
   {
      gettimeofday(&now, NULL);
      if (now.tv_sec > last.tv_sec) micros = 1000000L + (now.tv_usec - last.tv_usec);
      else micros = (now.tv_usec - last.tv_usec);
      //micros = (now.tv_usec - last.tv_usec);

      if (micros > 100000)
      {
         last = now;
	 // read raw accel/gyro measurements from device
//	 imu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
         uint8_t buffer[2] = {0};
         I2Cdv::readBytes(0x04, 0, 2, buffer);
         printf("%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",ax, ay, az, gx, gy, gz, buffer[0], buffer[1]);
//         printf("%d\t%d\t%d\t%d\t%d\t%d\n",ax, ay, az, gx, gy, gz);
         
      }
   }
   return 0;
}
