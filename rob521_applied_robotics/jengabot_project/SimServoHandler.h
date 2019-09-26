#ifndef SERVO_HANDLER_H
#define SERVO_HANDLER_H

#include <stdio.h>
#include <vector>
#include "ManipulatorDynamics.h"
#include <Eigen/Dense>

using namespace Eigen;

//add the other includes here

using namespace std;

class SimServoHandler {

public:
   SimServoHandler();

   bool Connect();
   int GetThetas(vector<float>* thetas);
   int Update(vector<float> theta_dot);
   int HoldPosition();

   vector<float> theta;

   ManipulatorDynamics* m_pDynamics;

};


#endif
