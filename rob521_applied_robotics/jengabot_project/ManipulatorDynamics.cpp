#include "ManipulatorDynamics.h"

using namespace Eigen;
using namespace std;

ManipulatorDynamics::ManipulatorDynamics() {


}

void ManipulatorDynamics::Linearize(Vector4f x, Vector2f u, Matrix4f* A, MatrixXf* B)
{

   x(0) += pi/2;

   Matrix2f mH = GetInertiaMatrix(x);
   Matrix2f mC = GetCoriolisMatrix(x);
   Vector2f mG = GetGravityMatrix(x);

   Matrix2f mH_inv = mH.inverse();

   Vector2f q;
   q(0) = x(0);
   q(1) = x(1);
   Vector2f qd;
   qd(0) = x(2);
   qd(1) = x(3);

   for (int i = 0; i < 2; i++)
   {
      if (u(i) > max_torque)
         u(i) = max_torque;
      if (u(i) < -max_torque)
         u(i) = -max_torque;
      if (qd(i) < 0)
         u(i) += (static_friction_torque + damping_friction_torque*qd(i));
      if (qd(i) > 0)
         u(i) -= (static_friction_torque + damping_friction_torque*qd(i));
   }

   (*A) = Matrix4f::Zero();
   (*A)(0,2) = 1.0f;
   (*A)(1,3) = 1.0f;

    Matrix2f dHinvdq1 = GetdHinvdq(x, 0);
    Matrix2f dCdq1 = GetdCdq(x,0);
    Vector2f dGdq1 = GetdGdq(x,0);
    Vector2f dtdd_dq1 = dHinvdq1*(u - mC*qd - mG) - mH_inv*dCdq1*qd - mH_inv*dGdq1;

    Matrix2f dHinvdq2 = GetdHinvdq(x, 1);
    Matrix2f dCdq2 = GetdCdq(x,1);
    Vector2f dGdq2 = GetdGdq(x,1);
    Vector2f dtdd_dq2 = dHinvdq2*(u - mC*qd - mG) - mH_inv*dCdq2*qd - mH_inv*dGdq2;

    (*A)(2,0) = dtdd_dq1(0);
    (*A)(3,0) = dtdd_dq1(1);
    (*A)(2,1) = dtdd_dq2(0);
    (*A)(3,1) = dtdd_dq2(1);

    Matrix2f dCdqd1 = GetdCdq(x,2);
    Matrix2f mH_invmC = -mH_inv*mC;
    Vector2f mH_invmC1;
    mH_invmC1(0) = mH_invmC(0,0);
    mH_invmC1(1) = mH_invmC(1,0);
    Vector2f mH_invmC2;
    mH_invmC2(0) = mH_invmC(0,1);
    mH_invmC2(1) = mH_invmC(1,1);
    Vector2f dtd_dq1 = mH_invmC1 - mH_inv*dCdqd1*qd;
    Matrix2f dCdqd2 = GetdCdq(x,3);
    Vector2f dtd_dq2 = mH_invmC2 - mH_inv*dCdqd2*qd;

    (*A)(2,2) = dtd_dq1(0);
    (*A)(2,3) = dtd_dq2(0);
    (*A)(3,2) = dtd_dq1(1);
    (*A)(3,3) = dtd_dq2(1);

    (*B) = MatrixXf::Zero(4,2);
    (*B)(2,0) = mH_inv(0,0);
    (*B)(2,1) = mH_inv(0,1);
    (*B)(3,0) = mH_inv(1,0);
    (*B)(3,1) = mH_inv(1,1);

}

Vector2f ManipulatorDynamics::limit_inputs(Vector4f x, Vector2f u)
{

   for (int i = 0; i < 2; i++)
   {
      if (u(i) > max_torque)
         u(i) = max_torque;
      if (u(i) < -max_torque)
         u(i) = -max_torque;
      if (x(2+i) < 0)
         u(i) += (static_friction_torque + damping_friction_torque*x(2+i));
      if (x(2+i) > 0)
         u(i) -= (static_friction_torque + damping_friction_torque*x(2+i));
   }

   return u;
}

Vector4f ManipulatorDynamics::NonlinearDynamics(Vector4f x, Vector2f u)
{
   x(0) += pi/2;


   u = limit_inputs(x,u);

   Matrix2f mH = GetInertiaMatrix(x);
   Matrix2f mC = GetCoriolisMatrix(x);
   Vector2f mG = GetGravityMatrix(x);

   Matrix2f mH_inv = mH.inverse();

   Vector2f qd;
   qd(0) = x(2);
   qd(1) = x(3);

   Vector2f tdd = mH_inv*(u - mC*qd - mG);

   Vector4f res;
   res(0) = qd(0);
   res(1) = qd(1);
   res(2) = tdd(0);
   res(3) = tdd(1);

   return res;
}

Vector2f ManipulatorDynamics::GetU(Vector4f x, vector<float> qdd)
{
   x(0) += pi/2;
   Matrix2f mH = GetInertiaMatrix(x);
   Matrix2f mC = GetCoriolisMatrix(x);
   Vector2f mG = GetGravityMatrix(x);
   Vector2f xdd;
   xdd(0) = qdd[0];
   xdd(1) = qdd[1];

   Vector2f qd;
   qd(0) = x(2);
   qd(1) = x(3);

   return mH*xdd + mC*qd + mG;
}

Matrix2f ManipulatorDynamics::GetdHinvdq(Vector4f x, int elem)
{
   Matrix2f mHr;
   Matrix2f mHl;
   Matrix2f mHr_inv;
   Matrix2f mHl_inv;

   Vector4f lx = x;
   Vector4f rx = x;
   lx(elem) -= 0.01;
   rx(elem) += 0.01;
   mHr = GetInertiaMatrix(rx);
   mHl = GetInertiaMatrix(lx);
   mHr_inv = mHr.inverse();
   mHl_inv = mHl.inverse();

   return (mHr_inv - mHl_inv)/0.02;
}

Matrix2f ManipulatorDynamics::GetdCdq(Vector4f x, int elem)
{
   Matrix2f mCr;
   Matrix2f mCl;

   Vector4f lx = x;
   Vector4f rx = x;
   lx(elem) -= 0.01;
   rx(elem) += 0.01;
   mCr = GetCoriolisMatrix(rx);
   mCl = GetCoriolisMatrix(lx);

   return (mCr - mCl)/0.02;
}

Vector2f ManipulatorDynamics::GetdGdq(Vector4f x, int elem)
{
   Vector2f mGr;
   Vector2f mGl;

   Vector4f lx = x;
   Vector4f rx = x;
   lx(elem) -= 0.01;
   rx(elem) += 0.01;
   mGr = GetGravityMatrix(rx);
   mGl = GetGravityMatrix(lx);

   return (mGr - mGl)/0.02;
}

Matrix2f ManipulatorDynamics::GetInertiaMatrix(Vector4f x)
{
   Matrix2f mH;

   float c2 = cos(x(1));

   float m2l1lc2c2 = m_fLink2Mass_kg*m_fLink1Length_m*m_fCx2_m*c2;

   mH(0,0) = m_fLink1Inertia + m_fLink2Inertia + m_fLink2Mass_kg*pow(m_fLink1Length_m,2) + 2*m2l1lc2c2;
   mH(0,1) = m_fLink2Inertia + m2l1lc2c2;
   mH(1,0) = mH(0,1);
   mH(1,1) = m_fLink2Inertia;

   return mH;
}

Matrix2f ManipulatorDynamics::GetCoriolisMatrix(Vector4f x)
{
   Matrix2f mC;

   float s2 = sin(x(1));

   float m2l1lc2s2 = m_fLink2Mass_kg*m_fLink1Length_m*m_fCx2_m*s2;

   mC(0,0) = -2*m2l1lc2s2*x(3);
   mC(0,1) = -m2l1lc2s2*x(3);
   mC(1,0) = m2l1lc2s2*x(2);
   mC(1,1) = 0.0f;

   return mC;
}

Vector2f ManipulatorDynamics::GetGravityMatrix(Vector4f x)
{
   Vector2f mG;

   float s1 = sin(x(0));
   float s12 = sin(x(0) + x(1));

   mG(0) = -(m_fLink1Mass_kg*m_fCx1_m + m_fLink2Mass_kg*m_fLink1Length_m)*g*s1 - m_fLink2Mass_kg*m_fLink2Length_m*g*s12;
   mG(1) = -m_fLink2Mass_kg*m_fLink2Length_m*g*s12;

  return mG;
}
