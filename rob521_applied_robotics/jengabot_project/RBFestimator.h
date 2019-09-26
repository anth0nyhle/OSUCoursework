#ifndef RBF_ESTIMATOR_H
#define RBF_ESTIMATOR_H

#include <vector>
#include <math.h>       /* fabs */
#include <stdio.h>
#include "Common_Structs.h"
#include <fstream>

#define N_KERNELS 36*36

using namespace std;

class RBFestimator {

public:

   RBFestimator();
   void Update(vector<float> theta, vector<float> err);
   vector<float> GetFF(vector<float> theta);
   void WriteToFile();

private:

   float GetFF(vector<float> theta, int theta_num);
   void Update(vector<float> theta, float err, int theta_num);

   int ThetasToIdx(vector<float> theta);
   vector<float> IdxToThetas(int idx);

   float kernels1[N_KERNELS];
   float kernels2[N_KERNELS];

   static constexpr float learning_rate = 0.25;
   static constexpr float kernel_width = 0.2;
   static const int kernel_size = 7;

};


#endif
