#ifndef FF_ESTIMATOR_H
#define FF_ESTIMATOR_H

#include <vector>
#include <math.h>       /* fabs */
#include <stdio.h>
#include "Common_Structs.h"
#include <fstream>

#define N_ANGLE_TILES 18
#define N_VEL_TILES 5
#define N_TOTAL_TILES N_ANGLE_TILES*N_ANGLE_TILES*N_VEL_TILES

using namespace std;

class FFEstimator {

public:

   FFEstimator();
   void Update(vector<float> theta, vector<float> theta_dot, vector<float> err);
   vector<float> GetFF(vector<float> theta, vector<float> theta_dot);
   void WriteToFile();

private:

   int ThetasToIdx(vector<float> theta, float theta_dot);
   int GetVelIdx(float theta_dot);

   float ff_tiles1[N_TOTAL_TILES];
   float ff_tiles2[N_TOTAL_TILES];

   static constexpr float learning_rate = 0.05;

};


#endif
