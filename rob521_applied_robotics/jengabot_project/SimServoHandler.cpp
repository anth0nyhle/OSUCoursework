#include "SimServoHandler.h"
//#include "Common_Structs.h"
#include <sys/time.h>
using namespace std;
using namespace Eigen;

SimServoHandler::SimServoHandler() {

  //constructor... initialize variables here

  for (int i = 0; i < 5; i++)
     theta.push_back(0);
  theta[1] = -3.1415;
  theta[2] = 3.1415;

  m_pDynamics = new ManipulatorDynamics();

}

bool SimServoHandler::Connect() {

//connect to devices here

//return true if successful... false otherwise

//also do any configuration stuff here
return false;
}

int SimServoHandler::GetThetas(vector<float>* thetas)
{

//bulk read 

//for each servo
(*thetas)[0] = theta[0];
(*thetas)[1] = theta[1];
(*thetas)[2] = theta[2];
(*thetas)[3] = theta[3];
(*thetas)[4] = theta[4];

return 0;//if good... if there was a read error return -1;

}

int SimServoHandler::Update(vector<float> output)
{
   struct timeval cur_time;
   gettimeofday(&cur_time, NULL);
   static struct timeval last_time = cur_time;
   static vector<float> theta_dot(5);
   static vector<float> last_theta(5);
   static bool bFirst = true;

   float mtime = (float(cur_time.tv_sec - last_time.tv_sec) + float(cur_time.tv_usec - last_time.tv_usec)/1000000);

   if (output[1] < 0.00001 && output[1] > -0.00001 && output[2] < 0.00001 && output[2] > -0.00001)
   {
      last_time = cur_time;
      bFirst = true;
      return 0;
   }

   if (bFirst)
   {
      last_time = cur_time;
      bFirst = false;
      return 0;
   }

   Vector2f u;
   u(0) = output[1]*m_pDynamics->get_kt();
   u(1) = output[2]*m_pDynamics->get_kt();


   Vector4f vX;
   vX(0) = theta[1];
   vX(1) = theta[2];
   vX(2) = theta_dot[1];
   vX(3) = theta_dot[2];

   Vector4f xd = m_pDynamics->NonlinearDynamics(vX, u);

   theta_dot[1] += xd(2)*mtime;
   theta_dot[2] += xd(3)*mtime;

   theta[1] += theta_dot[1]*mtime;
   theta[2] += theta_dot[2]*mtime;


   //printf("%f, %f, %f, %f, %f\n", u(0), vX(0), xd(2), theta_dot[1], theta[1]);


   for (int i = 0; i < 5; i++)
   {
      if (i == 1 || i == 2)
         continue;
      theta[i] += mtime*output[i];
   }


   last_time = cur_time;

   return 0;//if good... if there was a write error return -1;
}

int SimServoHandler::HoldPosition()
{
//send all zeros for velocity targets
   return 0;
}
