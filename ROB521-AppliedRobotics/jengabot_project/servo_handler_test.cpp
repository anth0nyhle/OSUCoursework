#include "ServoHandler.h"
#include <vector>
#include <stdio.h>
#include <sys/time.h>

int main()
{


   ServoHandler* m_pServo = new ServoHandler();

   bool bConnect = m_pServo->Connect();
   if (bConnect != 0)
   {
      printf("Failed to connect!  Exiting...\n");
      return -1;
   }

   struct timeval cur_time, last_time;
   gettimeofday(&cur_time, NULL);
   last_time = cur_time;

   while (1)
   {
      gettimeofday(&cur_time, NULL);
      long mtime = (cur_time.tv_sec - last_time.tv_sec)*1000 + (cur_time.tv_usec - last_time.tv_usec)/1000;

      if (mtime > 0)
      {
         last_time = cur_time;
         struct timeval next_time = last_time;

         vector<float> thetas(5);

         int iRet = m_pServo->GetThetas(&thetas);
         if (iRet != 0)
         {
            printf("Failure reading thetas!\n");
         }
         else
         {
            printf("Thetas: %f\t%f\t%f\t%f\t%f\n",thetas[0],thetas[1],thetas[2],thetas[3],thetas[4]);
         }

         vector<float> target_vels(5);
         for (int i = 0; i < 5; i++)
            target_vels[i] = (float(i)-2)*0.5;
         iRet = m_pServo->Update(target_vels);
         if (iRet != 0)
         {
            printf("Failure writing velocity!  Exiting...\n");
         }

         gettimeofday(&next_time, NULL);
         mtime = (next_time.tv_sec - last_time.tv_sec)*1000 + (next_time.tv_usec - last_time.tv_usec)/1000;

         printf("%ld\n",mtime);


      }

   }

}
