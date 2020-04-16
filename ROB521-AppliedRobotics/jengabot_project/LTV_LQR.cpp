#include "LTV_LQR.h"

using namespace Eigen;
using namespace std;

LTV_LQR::LTV_LQR()
{
   mQf << 1.0f, 0.0f, 0.0f, 0.0f,
         0.0f, 1.0f, 0.0f, 0.0f,
         0.0f, 0.0f, 0.5f, 0.0f,
         0.0f, 0.0f, 0.0f, 0.5f;

   mQ = 20*mQf;

   mR << 100.0f, 0.0f,
         0.0f, 100.0f;

   m_pDynamics = new ManipulatorDynamics();

   m_bControllerActive = false;
}

int LTV_LQR::StabalizeTrajectory(vector<vector<float>> thetas, vector<vector<float>> theta_dots, vector<float> times)
{

   TrajPts.clear();

   vector<vector<float>> qdd;
   vector<float> row(2);

   for (int i = 0; i < thetas.size()-1; i++)
   {
      row[0] = (theta_dots[i+1][1] - theta_dots[i][1])/(times[i+1] - times[i]);
      row[1] = (theta_dots[i+1][2] - theta_dots[i][2])/(times[i+1] - times[i]);
      qdd.push_back(row);
      printf("%f, %f, %f, %f, %f, %f\n",thetas[i][1], thetas[i][2], theta_dots[i][1], theta_dots[i][2], qdd[i][0], qdd[i][1]);
   }
   row[0] = 0.0f;
   row[1] = 0.0f;
   qdd.push_back(row);

   mS = mQf;

   MatrixXf B = MatrixXf::Zero(4,2);
   Matrix4f A = Matrix4f::Zero();


   //first we need to find the infinite horizon control law for the trajectory end point
   TrajPt wp;

   int i = qdd.size()-1;
   wp.vX(0) = thetas[i][1];
   wp.vX(1) = thetas[i][2];
   wp.vX(2) = theta_dots[i][1];
   wp.vX(3) = theta_dots[i][2];

   wp.vU = m_pDynamics->GetU(wp.vX, qdd[i]);

//   cout << wp.vX << "\n";
//   cout << wp.vU << "\n";

   m_pDynamics->Linearize(wp.vX, wp.vU, &A, &B);

//   cout << A << "\n";
//   cout << B << "\n";

   for (int i = 0; i < 5000; i++)
   {
      mS += (mQ - mS*B*mR.inverse()*B.transpose()*mS + mS*A + A.transpose()*mS)*0.0001;
      LLT<Matrix4f> lltOfS(mS); // compute the Cholesky decomposition of A
      if(lltOfS.info() == NumericalIssue)
      {
        printf("S(T) not semi-positive definite!!!\n");
        return -1;
      }

      //wp.mK = -mR.inverse()*B.transpose()*mS;
   }

//   cout << mS << "\n";

   for (int i = qdd.size()-1; i >= 0; i--)
   {
      wp.vX(0) = thetas[i][1];
      wp.vX(1) = thetas[i][2];
      wp.vX(2) = theta_dots[i][1];
      wp.vX(3) = theta_dots[i][2];

      wp.Qdd = qdd[i];

      wp.vU = m_pDynamics->GetU(wp.vX, qdd[i]);

      m_pDynamics->Linearize(wp.vX, wp.vU, &A, &B);
      //wp.mK = -((B.transpose()*mS*B + mR).inverse())*B.transpose()*mS*A;
      //mS = mQ + A.transpose()*mS*A + A.transpose()*mS*B*wp.mK;
      for (int j = 0; j < 10; j++)
      {
         mS += (mQ - mS*B*mR.inverse()*B.transpose()*mS + mS*A + A.transpose()*mS)*0.01;//poor mans integration
         LLT<Matrix4f> lltOfS(mS); // compute the Cholesky decomposition of A
         if(lltOfS.info() == NumericalIssue)
         {
           cout << mS << "\n";
           printf("S(%d) not semi-positive definite!!!\n", i);
           return -1;
         }
      }
      wp.mK = mR.inverse()*B.transpose()*mS;
//      printf("%f\t%f\t%f\t%f\t%f\t%f\n", wp.vX(0), wp.vX(1), wp.vX(2), wp.vX(3), wp.vU(0), wp.vU(1));
      printf("K matrix:\n");
      cout << wp.mK << "\n";

//      printf("A matrix:\n");
//      cout << A << "\n";

//      printf("B matrix:\n");
//      cout << B << "\n";

      TrajPts.push_back(wp);
   }

   reverse(TrajPts.begin(),TrajPts.end());

   m_bControllerActive = true;

   return 0;

}

vector<float> LTV_LQR::Update(vector<float> thetas, vector<float> theta_dots, int idx)
{

   TrajPt wp = TrajPts[idx];
   Vector4f vX;
   vX(0) = thetas[1];
   vX(1) = thetas[2];
   vX(2) = theta_dots[1];
   vX(3) = theta_dots[2];

   wp.vU = m_pDynamics->GetU(wp.vX, wp.Qdd);

   Vector2f vU = -wp.mK*(vX - wp.vX);
   vector<float> res(2);
   res[0] = vU(0)/m_pDynamics->get_kt();
   res[1] = vU(1)/m_pDynamics->get_kt();

   return res;
}
