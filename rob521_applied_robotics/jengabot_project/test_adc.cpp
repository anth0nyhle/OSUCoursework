#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>
#include "I2Cdv.h"
#include "ADS1115.h"
#include "GPIOClass.h"
#include <sys/time.h>

ADS1115 adc0;

int main(int argc, char *argv[])
{

   GPIOClass* relay = new GPIOClass("4");
   relay->export_gpio();
   relay->setdir_gpio("out");

//   adc0.initialize();
   printf("failed to init\n");

   int n;
   int data;
   int c = 0;
   bool on = false;

   struct timeval now, last;
   gettimeofday(&last, NULL);
   long micros;
   while (true)
   {
      gettimeofday(&now, NULL);
      if (now.tv_sec > last.tv_sec) micros = 1000000L + (now.tv_usec - last.tv_usec);
      else micros = (now.tv_usec - last.tv_usec);
      //micros = (now.tv_usec - last.tv_usec);

      if (micros > 10000)
      {
         last = now;
//         int16_t val = adc0.getConversionP0GND();
//         printf("%d\n",val);
         if (c++ > 100)
         {
            on = !on;
            
            if (true)
               relay->setval_gpio("1");
            else
               relay->setval_gpio("0");
            c = 0;
         }
      }
   }
   return 0;
}
