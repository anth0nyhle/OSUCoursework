#include <stdio.h>
#include "RBFestimator.h"
#include <vector>

using namespace std;

int main()
{

   RBFestimator* m_pRBF = new RBFestimator();

   vector<float> thetas(5);
   thetas[1] = -PI/2;
   thetas[2] = PI/2;

   vector<float> err(2);
   err[0] = -0.5;

   for (int i = 0; i < 100; i++)
      m_pRBF->Update(thetas, err);

   m_pRBF->GetFF(thetas);

   m_pRBF->WriteToFile();

}
