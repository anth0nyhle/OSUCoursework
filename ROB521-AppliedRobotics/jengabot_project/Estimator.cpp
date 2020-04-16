#include "Estimator.h"

using namespace Eigen;

Estimator::Estimator()
{
   mQ << 0.1f, 0.0f,
         0.0f, 0.01f;

   mP << 10.0f, 0.0f,
         0.0f, 10.0f;

   mR << 0.005f, 0.0f, 0.0f,
           0.0f, 0.05f, 0.0f,
           0.0f, 0.0f, 0.05f;

   mH = MatrixXf::Zero(3,2);
   mH(0,0) = 1.0f;

   mI = MatrixXf::Zero(2,2);
   mI(0,0) = 1.0f;
   mI(1,1) = 1.0f;

   mF = mI;

}

void Estimator::Update(vector<float> thetas, float imu_psi, float IR1, float IR2)
{

   static bool bFirstIteration = true;

   IR1 = IR1 - 0.007;
   IR2 = IR2 - 0.007;

   if (bFirstIteration)
   {
      vZ(1) = IR1;
      vZ(2) = IR2;
   }
   else
   {
      vZ(1) = vZ(1)*(1-fIRlowpass) + IR1*fIRlowpass;
      vZ(2) = vZ(2)*(1-fIRlowpass) + IR2*fIRlowpass;
   }

   vZ(0) = imu_psi + PI/2;//map into frame where all of this math was done...

   bFirstIteration = false;

   thetas[1] += PI/2;

   float c1 = cos(vX(0));
   float c12 = cos(vX(0) + thetas[1]);
   float c13 = cos(vX(0) + thetas[1] + thetas[2]);
   float c14 = cos(vX(0) + thetas[1] + thetas[2] + thetas[3]);

   float s1 = sin(vX(0));
   float s12 = sin(vX(0) + thetas[1]);
   float s13 = sin(vX(0) + thetas[1] + thetas[2]);
   float s14 = sin(vX(0) + thetas[1] + thetas[2] + thetas[3]);

   mF = mI;
   mF(1,0) = -m_fLink1_Length_m*s1;
   mF(1,0) += -m_fLink2_Length_m*s12;
   mF(1,0) += -m_fLink3_Length_m*c12;
   mF(1,0) += -m_fLink4_Length_m*s13;
   mF(1,0) += -m_fLink5_Length_m*s14;


   vX(1) = m_fOrigin_ToSurface_m;
   vX(1) += m_fLink1_Length_m*c1;
   vX(1) += m_fLink2_Length_m*c12;
   vX(1) += -m_fLink3_Length_m*s12;
   vX(1) += m_fLink4_Length_m*c13;
   vX(1) += m_fLink5_Length_m*c14;

   vX(0) = m_fBase_Stiffness_Nm*GetMomentAtBase(c1, s1, s12, s13, s14);

   mP = mF*mP*mF.transpose() + mQ;

   Vector3f vY;
   if (fabs(vZ(1)-vZ(2)) > 0.01 || fabs(s14) < 0.01)
   {
      vY(1) = 0.0f;
      vY(2) = 0.0f;
   }
   else if (fabs(s14) < 0.01)
   {
      mH(1,0) = 0.0f;
      mH(1,1) = 0.0f;
      vY(1) = 0.0f;
      vY(2) = 0.0f;
   }
   else
   {
      vY(1) = vZ(1) - vX(1)/s14;
      vY(2) = vZ(2) - vX(1)/s14;
      mH(1,0) = -(c14/s14)*(1/s14)*vX(1);
      mH(1,1) = 1/s14;
   }
   vY(0) = vZ(0) - vX(0) - thetas[1] - thetas[2] - thetas[3];
   mH(0,0) = 1.0f;

   mH(2,0) = mH(1,0);
   mH(2,1) = mH(1,1);

   Matrix3f dyn_R = mR;
   dyn_R(1,1) += vZ(1)*vZ(1);
   dyn_R(2,2) += vZ(2)*vZ(2);

   Matrix3f mS = mH*mP*mH.transpose() + dyn_R;

   mK = (mP*mH.transpose())*mS.inverse();

   vX += mK*vY;

//   printf("%f, %f, %f\n", vX(0), vY(0), vY(1));

   mP = (mI - mK*mH)*mP;
}

