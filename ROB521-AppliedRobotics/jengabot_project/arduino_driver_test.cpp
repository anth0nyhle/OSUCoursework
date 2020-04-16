#include <stdio.h>
#include <vector>
#include <iostream>
#include <thread>

#include "ArduinoDriver.h"
#include <sys/time.h>

using namespace std;

int main() {

  ArduinoDriver* pArduino = new ArduinoDriver();

  int iRet = pArduino->Connect();

  if (iRet != 0)
  {
    printf("Couldn't connect to arduino!!!\n");
    return -1;
  }

  struct timeval cur_time, last_time;
  gettimeofday(&last_time, NULL);
  while (cur_time.tv_sec - last_time.tv_sec < 5)
     gettimeofday(&cur_time, NULL);

  printf("Connected!\n");

  thread comm_thread(&ArduinoDriver::Receive, pArduino);

  vector<vector<float>> fake_traj;
  vector<float> fake_times(32);
  vector<float> fake_goals(5);
  fake_goals[0] = 1.0;
  fake_goals[1] = -0.1;
  fake_goals[2] = 2.0;
  fake_goals[3] = 1.5;
  fake_goals[4] = -0.5;

  vector<float> row(5);
  fake_traj.push_back(row);
  float time = 0.0;
  fake_times[0] = time;
  for (int i = 1; i < 32; i++)
  {
    time += 0.1;
    fake_times[i] = time;

    for (int j = 0; j < 5; j++)
       row[j] += (fake_goals[j]/31.0f);
    fake_traj.push_back(row);
  }

  RET_CODE eRet = ECODE_ACTIVE;
  while (eRet != ECODE_NO_ERROR)
     eRet = pArduino->TransmitTrajectory(fake_traj, fake_times);

  while (true) { }

  return 0;

}
