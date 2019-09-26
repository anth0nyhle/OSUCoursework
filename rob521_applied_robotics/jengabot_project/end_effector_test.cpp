#include <stdio.h>
#include <vector>
#include <iostream>
#include <thread>

#include "EndEffector.h"
#include <sys/time.h>

using namespace std;

int main() {

  EndEffector* pArduino = new EndEffector();

  int iRet = pArduino->Connect();

  if (iRet != 0)
  {
    printf("Couldn't connect to arduino!!!\n");
    return -1;
  }

  struct timeval cur_time, last_time;
  gettimeofday(&last_time, NULL);
  while (cur_time.tv_sec - last_time.tv_sec < 1)
     gettimeofday(&cur_time, NULL);

  printf("Connected!\n");

  thread comm_thread(&EndEffector::Receive, pArduino);

  while (true)
  {
     static int c = 0;
     gettimeofday(&cur_time, NULL);
     long mtime = (cur_time.tv_sec - last_time.tv_sec)*1000 + (cur_time.tv_usec - last_time.tv_usec)/1000;
     if (mtime > 9)
     {
        c++;
        if (c == 100)
         pArduino->SetTargetGripperState(1);
        else if (c == 200)
        {
         pArduino->SetTargetGripperState(0);
         c = 0;
        }
        pArduino->Transmit();
        last_time = cur_time;
     }

  }

  return 0;

}
