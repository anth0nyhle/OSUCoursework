#ifndef ESTIMATOR_H
#define ESTIMATOR_H

#include <vector>
#include <list>
#include "Common_Structs.h"
#include <Eigen/Dense>

using namespace Eigen;

class Estimator {

public:

   EIGEN_MAKE_ALIGNED_OPERATOR_NEW

   Estimator();

   void Update(vector<float> thetas, float imu_psi, float IR1, float IR2);

   float GetBaseDeflection() {return vX(0);}

private:

   static constexpr float fIRlowpass = 0.1;
   static constexpr float m_fBase_Stiffness_Nm = 0.1;

   Vector3f vZ;
   Vector2f vX;

   Matrix2f mF;
   Matrix2f mQ;
   Matrix3f mR;
   Matrix2f mP;
   Matrix<float, 3, 2,DontAlign> mH;
   Matrix<float, 2, 3,DontAlign> mK;
   Matrix2f mI;





};

#endif
