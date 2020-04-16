#ifndef MVN_SAMPLER_H
#define MVN_SAMPLER_H

# include <cstdlib>
# include <cmath>
# include <ctime>
# include <iostream>
# include <iomanip>
# include <fstream>
# include <sstream>
# include <string>
#include <vector>

using namespace std;

class MVN_Sampler
{

public:
   MVN_Sampler() {};
   vector<vector<float>> Sample(int K, int* seed, float noise_scaling);
   vector<vector<float>> GetRinv();

private:

   int i4_max ( int i1, int i2 );
   int i4_min ( int i1, int i2 );
   double *multinormal_sample ( int m, int n, double a[], double mu[], int *seed );
   double r8_uniform_01 ( int *seed );

   double *r8po_fa ( int n, double a[] );
   double *r8vec_normal_01_new ( int n, int *seed );
   double *r8vec_uniform_01_new ( int n, int *seed );

   const static double Rinv[];
};
#endif
