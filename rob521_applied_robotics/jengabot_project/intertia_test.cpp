#include <stdio.h>
#include <vector>
#include <iostream>
#include <thread>
#include <fstream>
#include <sys/time.h>

#include "RobotArm.h"
#include "Common_Structs.h"
#include "InertiaTest.h"

#include <signal.h>

static volatile int keepRunning = 1;

void intHandler(int dummy) {
    keepRunning = 0;
}


using namespace std;

int main(int argc, char *argv[])
{

   signal(SIGINT, intHandler);

   InertiaTest* dynamixel = new InertiaTest();

   while (dynamixel->Connect() != 0)
   {
      printf("Failed to connect to dynamixels... trying once more\n");
      //return -1;
   }

   vector<float> thetas(5);
   int iRet = dynamixel->GetThetas(&thetas);
   if (iRet != 0)
   {
      printf("Failure reading thetas!\n");
   }

   RobotArm* m_pRobot = new RobotArm(thetas);


   float max_out = float(atoi(argv[1]))/1000;

   float targ_theta = -PI/6;

   float Kpp = 200.0;
   float Kpv = 0.0;

   float output1 = 0.0;

   fstream logfile;
   logfile.open("inertia_log.csv", fstream::out);

   struct timeval now, start;
   gettimeofday(&start, NULL);

   float last_delta_time = 0.0;

   while(keepRunning)
   {

      iRet = dynamixel->GetThetas(&thetas);
      if (iRet != 0)
      {
         printf("Failure reading thetas!\n");
      }
      m_pRobot->Update(thetas);
      vector<float> tdot = m_pRobot->GetJointVels();

      float e = targ_theta - thetas[1];
      float edot = -tdot[1];
      float output = Kpp*e + Kpv*edot;
      if (output > max_out)
         output = max_out;
      if (output < -max_out)
         output = -max_out;

      if (fabs(e) < 0.01)
         targ_theta = -targ_theta;

      gettimeofday(&now,NULL);



      float delta_time = float(now.tv_sec - start.tv_sec) + float(now.tv_usec - start.tv_usec)/1000000.0f;
      if (delta_time - last_delta_time > 2.0)
      {
         output1 += 0.25;
         last_delta_time = delta_time;
         if (output1 > 6.0)
            output1 = 0.0;
      }
      vector<float> out(1);
      out[0] = 0.0;//-output1;
      dynamixel->Update(out);



      logfile << float(now.tv_sec - start.tv_sec) + float(now.tv_usec - start.tv_usec)/1000000.0f << "," << thetas[1] << "," << tdot[1] << "," << out[0] << "\n";

   }

   dynamixel->HoldPosition();
   logfile.close();

}

