#include "RBFestimator.h"

using namespace std;

RBFestimator::RBFestimator() {
   for (int i = 0; i < N_KERNELS; i++)
   {
      kernels1[i] = 0.0f;
      kernels2[i] = 0.0f;
   }
}

int RBFestimator::ThetasToIdx(vector<float> theta)
{
   int t1 = int((0.00001 + theta[1] + PI)/(PI/36.0f));
   if (t1 < 0)
      t1 = 0;
   if (t1 > 35)
      t1 = 35;
   int t2 = int((0.00001 + theta[2])/(PI/36.0f));
   if (t2 < 0)
      t2 = 0;
   if (t2 > 35)
      t2 = 35;

   return t1*36 + t2;
}

vector<float> RBFestimator::IdxToThetas(int idx)
{
   int t1 = idx/36;
   int t2 = idx - t1*36;
   vector<float> thetas(2);
   thetas[0] = float(t1)*(PI/36.0f) - PI;
   thetas[1] = float(t2)*(PI/36.0f);

   //printf("%d,%d,%d\t%f,%f\n",idx,t1, t2, thetas[0], thetas[1]);
   return thetas;
}

vector<float> RBFestimator::GetFF(vector<float> theta)
{
   vector<float> ret(2);
   ret[0] = GetFF(theta, 0);
   ret[1] = GetFF(theta, 1);
   return ret;
}

float RBFestimator::GetFF(vector<float> theta, int theta_num)
{
   int idx = ThetasToIdx(theta);
   //printf("theta: %f | idx: %d\n", theta[theta_num+1], idx);
   float ret = 0.0f;
   int c = 0;
   float w_total = 0.0f;
   float* kernel = kernels2;
   if (theta_num == 0)
      kernel = kernels1;

   for (int i = 0; i < kernel_size; i++)
   {
      for (int j = 0; j < kernel_size; j++)
      {
         int row = idx/36;
         int col = idx - row*36;
         int col_lookup = col + (j-(kernel_size-1)/2);
         int row_lookup = row + (i-(kernel_size-1)/2);
         if (row_lookup < 0 || row_lookup > 35 || col_lookup < 0 || col_lookup > 35)
            continue;
         int idx_lookup = row_lookup*36 + col_lookup;

         vector<float> kernel_thetas = IdxToThetas(idx_lookup);
         float x_diff = pow(theta[1]-kernel_thetas[0],2) + pow(theta[2]-kernel_thetas[1],2);
         float w = exp(-x_diff/pow(kernel_width,2));
         ret += w*kernel[idx_lookup];
         w_total += w;
      }
   }

   return ret/(0.000001+w_total);
}

void RBFestimator::Update(vector<float> theta, float err, int theta_num)
{
   int idx = ThetasToIdx(theta);

   int c = 0;
   float w_total = 0;
   float* kernel = kernels2;
   if (theta_num == 0)
      kernel = kernels1;

   for (int i = 0; i < kernel_size; i++)
   {
      for (int j = 0; j < kernel_size; j++)
      {
         int row = idx/36;
         int col = idx - row*36;
         int col_lookup = col + (j-(kernel_size-1)/2);
         int row_lookup = row + (i-(kernel_size-1)/2);
         if (row_lookup < 0 || row_lookup > 35 || col_lookup < 0 || col_lookup > 35)
            continue;
         int idx_lookup = row_lookup*36 + col_lookup;

         vector<float> kernel_thetas = IdxToThetas(idx_lookup);
         float x_diff = pow(theta[1]-kernel_thetas[0],2) + pow(theta[2]-kernel_thetas[1],2);
         float w = exp(-x_diff/pow(kernel_width,2));
         kernel[idx_lookup] += w*err*learning_rate;
      }
   }
}

void RBFestimator::Update(vector<float> theta, vector<float> err)
{
   for (int i = 0; i < 2; i++)
      Update(theta, err[i], i);
}

void RBFestimator::WriteToFile()
{
   fstream logfile;
   logfile.open("fflog.csv", fstream::out);

   for (int i = 0; i < 36; i++)
   {
      for (int j = 0; j < 36; j++)
      {
         int idx = i*36 + j;
         logfile << kernels1[idx] << ",";
      }
      logfile << "\n";
   }
   for (int i = 0; i < 36; i++)
   {
      for (int j = 0; j < 36; j++)
      {
         int idx = i*36 + j;
         logfile << kernels2[idx] << ",";
      }
      logfile << "\n";
   }
   logfile.close();
}
