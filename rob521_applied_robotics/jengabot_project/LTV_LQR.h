
#ifndef LTV_LQR_H
#define LTV_LQR_H

#include <iostream>
#include <stdio.h>
#include <vector>
#include <Eigen/Dense>
#include "ManipulatorDynamics.h"

using namespace Eigen;
using namespace std;

class LTV_LQR {

public:

   EIGEN_MAKE_ALIGNED_OPERATOR_NEW

   LTV_LQR();

   int StabalizeTrajectory(vector<vector<float>> thetas, vector<vector<float>> theta_dots, vector<float> times);

   vector<float> Update(vector<float> thetas, vector<float> theta_dots, int idx);


private:

   ManipulatorDynamics* m_pDynamics;

   typedef struct TrajPt {
      EIGEN_MAKE_ALIGNED_OPERATOR_NEW
      MatrixXf mK;
      float time_s;
      Vector4f vX;
      Vector2f vU;
      vector<float> Qdd;
   }TrajPt;

   vector<TrajPt> TrajPts;

   bool m_bControllerActive;

   Matrix4f mQf;
   Matrix4f mQ;
   Matrix2f mR;

   Matrix4f mS;


};

#endif
