#ifndef MANIPULATOR_DYNAMICS_H
#define MANIPULATOR_DYNAMICS_H

#include <vector>
#include <Eigen/Dense>

using namespace Eigen;
using namespace std;

class ManipulatorDynamics {

public:

   EIGEN_MAKE_ALIGNED_OPERATOR_NEW

   ManipulatorDynamics();

   void Linearize(Vector4f x, Vector2f u, Matrix4f* A, MatrixXf* B);

   Vector4f NonlinearDynamics(Vector4f x, Vector2f u);

   Vector2f GetU(Vector4f vX, vector<float> qdd);

   float get_kt() {return m_fKt;}

   Vector2f limit_inputs(Vector4f x, Vector2f u);

private:

   Matrix2f GetdHinvdq(Vector4f x, int elem);
   Matrix2f GetdCdq(Vector4f x, int elem);
   Vector2f GetdGdq(Vector4f x, int elem);
   Matrix2f GetInertiaMatrix(Vector4f x);
   Matrix2f GetCoriolisMatrix(Vector4f x);
   Vector2f GetGravityMatrix(Vector4f x);


   static constexpr float m_fLink1Inertia = 0.0025;
   static constexpr float m_fLink2Inertia = 0.009;

   static constexpr float m_fLink1Mass_kg = 0.1259;
   static constexpr float m_fLink2Mass_kg = 0.283;

   static constexpr float m_fLink1Length_m = 0.1306;
   static constexpr float m_fLink2Length_m = 0.265375;

   static constexpr float m_fCx1_m = 0.112;
   static constexpr float m_fCx2_m = 0.135;
   static constexpr float g = 9.806;
   static constexpr float pi = 3.141592654;

   static constexpr float max_torque = 0.77;
   static constexpr float static_friction_torque = 0.07;
   static constexpr float damping_friction_torque = 0.12;

   static constexpr float m_fKt = 0.1936;

};


#endif
