#include "FFEstimator.h"

using namespace std;

FFEstimator::FFEstimator() {

   for (int i = 0; i < N_TOTAL_TILES; i++)
   {
      ff_tiles1[i] = 0.0f;
      ff_tiles2[i] = 0.0f;
   }

}

int FFEstimator::GetVelIdx(float theta_dot)
{
   if (fabs(theta_dot) < 0.025)
      return 2;
   if (theta_dot < -0.25)
      return 0;
   if (theta_dot < -0.05)
      return 1;
   if (theta_dot > 0.25)
      return 3;
   if (theta_dot > 0.05)
      return 4;
}

int FFEstimator::ThetasToIdx(vector<float> theta, float theta_dot)
{

   int td1=GetVelIdx(theta_dot);

   int t1 = int((theta[1] + PI)/(PI/18.0f));
   if (t1 < 0)
      t1 = 0;
   if (t1 > 17)
      t1 = 17;
   int t2 = int((theta[2])/(PI/18.0f));
   if (t2 < 0)
      t2 = 0;
   if (t2 > 17)
      t2 = 17;

   return t1*N_ANGLE_TILES*N_VEL_TILES + t2*N_VEL_TILES + td1;
}

vector<float> FFEstimator::GetFF(vector<float> theta, vector<float> theta_dot)
{
   int idx = ThetasToIdx(theta, theta_dot[1]);
   vector<float> ret(2);
   ret[0] = ff_tiles1[idx];
   idx = ThetasToIdx(theta, theta_dot[2]);
   ret[1] = ff_tiles2[idx];
   return ret;
}

void FFEstimator::Update(vector<float> theta, vector<float> theta_dot, vector<float> err)
{
   int idx1 = ThetasToIdx(theta, theta_dot[1]);
   ff_tiles1[idx1] += learning_rate*err[0];
   int idx2 = ThetasToIdx(theta, theta_dot[2]);
   ff_tiles2[idx2] += learning_rate*err[1];
}

void FFEstimator::WriteToFile()
{
   fstream logfile;
   logfile.open("fflog.csv", fstream::out);

   for (int i = 0; i < N_VEL_TILES; i++)
   {
      for (int j = 0; j < N_ANGLE_TILES; j++)
      {
         for (int k = 0; k < N_ANGLE_TILES; k++)
         {
            int idx = k*N_ANGLE_TILES*N_VEL_TILES + j*N_VEL_TILES + i;
            logfile << ff_tiles1[idx] << ",";
         }
         logfile << "\n";
      }
   }

   for (int i = 0; i < N_VEL_TILES; i++)
   {
      for (int j = 0; j < N_ANGLE_TILES; j++)
      {
         for (int k = 0; k < N_ANGLE_TILES; k++)
         {
            int idx = k*N_ANGLE_TILES*N_VEL_TILES + j*N_VEL_TILES + i;
            logfile << ff_tiles2[idx] << ",";
         }
         logfile << "\n";
      }
   }


   logfile.close();
}
