#ifndef COMMON_STRUCTS_H
#define COMMON_STRUCTS_H

#include <list>
#include <vector>
#include <math.h>
#include <stdint.h>

#define PI 3.141592654

using namespace std;

static constexpr float m_fOrigin_ToSurface_m = 0.104;

static constexpr float m_fLink1_Length_m = 0.0653;
static constexpr float m_fLink2_Length_m = 0.1306;
static constexpr float m_fLink3_Length_m = 0.032;
static constexpr float m_fLink4_Length_m = 0.126;
static constexpr float m_fLink5_Length_m = 0.069375;
//static constexpr float m_fLink6_Length_m = 0.023;
//static constexpr float m_fLink6_zOffset_m = 0.030383;
static constexpr float m_fLink6_Length_m = 0.088503;
static constexpr float m_fLink6_zOffset_m = -0.03859;

static constexpr float m_fLink1_Mass_kg = 0.1;
static constexpr float m_fLink2_Mass_kg = 0.14;
static constexpr float m_fLink4_Mass_kg = 0.13;
static constexpr float m_fLink5_Mass_kg = 0.14;

static constexpr float m_fCx1_m = 0.042;
static constexpr float m_fCx2_m = 0.11;
static constexpr float m_fCx4_m = 0.095;
static constexpr float m_fCx5_m = 0.05;

static float GetMomentAtBase(float c12, float s1, float s12, float s13, float s14) {
   float ret = 0;
   ret += m_fLink1_Mass_kg*m_fCx1_m*s1;
   ret += m_fLink2_Mass_kg*(m_fLink1_Length_m*s1 + m_fCx2_m*s12);
   ret += m_fLink4_Mass_kg*(m_fLink1_Length_m*s1 + m_fLink2_Length_m*s12 + m_fLink3_Length_m*c12 + m_fCx4_m*s13);
   ret += m_fLink5_Mass_kg*(m_fLink1_Length_m*s1 + m_fLink2_Length_m*s12 + m_fLink3_Length_m*c12 + m_fLink4_Length_m*s13 + m_fCx5_m*s14);
   return ret*9.806;
}


static float fastcos(float theta)
{
   float x2 = theta*theta;
   float x4 = x2*x2;
   float x6 = x4*x2;
   float x8 = x6*x2;
   return 1 - x2/2 + x4/24 - x6/720 + x8/40320;
}

static float fastsin(float theta)
{
   float x = theta;
   float x2 = x*x;
   float x3 = x*x2;
   float x5 = x3*x2;
   float x7 = x5*x2;
   return x - x3/6 + x5/120 - x7/5040;
}

struct Point3D {
   float x_m;
   float y_m;
   float z_m;
};

struct Pose2D {
   float x_m;
   float y_m;
   float yaw_rad;
};

struct Pose6D {
   Point3D pos;
   vector<vector<float>> R;
};

struct BoundingBox {
   Point3D high;
   Point3D low;
};

struct BoundingSphere {
   Point3D center;
   float radius;
};

struct DH_Params {
   float a;
   float alpha;
   float d;
   float theta;
   DH_Params() {};
   DH_Params(float f_a, float f_alpha, float f_d, float f_theta) { a = f_a; alpha = f_alpha; d = f_d; theta = f_theta; }
};

struct Joint {
   vector<vector<float>> A; //4x4 DH parameters
   float min_theta;
   float max_theta;
   float rot_vel_limit_rps;
   float rot_acc_limit_rps2;
   DH_Params dh_params;
   Joint () {};
   Joint (DH_Params dh, float min_t, float max_t, float vel_limit, float acc_limit)
   {
      vector<float> row(4);
      for (int i = 0; i < 4; i++)
         A.push_back(row);
      A[3][3] = 1;

      dh_params = dh;
      update(dh.theta);
      //create dh matrix using a, alpha, d, and theta
      min_theta = min_t;
      max_theta = max_t;
      rot_vel_limit_rps = vel_limit;
      rot_acc_limit_rps2 = acc_limit;
   }

   void update(float theta)
   {
      float ct = fastcos(theta);
      float st = fastsin(theta);
      float ca = fastcos(dh_params.alpha);
      float sa = fastsin(dh_params.alpha);
      A[0][0] = ct;
      A[0][1] = -st*ca;
      A[0][2] = st*sa;
      A[0][3] = dh_params.a*ct;
      A[1][0] = st;
      A[1][1] = ct*ca;
      A[1][2] = -ct*sa;
      A[1][3] = dh_params.a*st;
      A[2][1] = sa;
      A[2][2] = ca;
      A[2][3] = dh_params.d;
   }
};

struct Link {
   vector<BoundingSphere> surface;
   Pose6D base_frame;
   Pose6D ef_frame;
   Joint joint;
   float link_width;
   Link(DH_Params dh_params, float min_t, float max_t, float rps_limit, float acc_limit, float width)
   {
      joint = Joint(dh_params, min_t, max_t, rps_limit, acc_limit);
      link_width = width;
   }
};

struct Command {
   uint8_t cmd_type;
   uint8_t proceed;
   Point3D point;
   float yaw;
};

typedef enum GRIPPER_STATE {

   GRIPPER_OPEN = 0,
   GRIPPER_CLOSE = 1,
   GRIPPER_MOVING = 2,
   GRIPPER_HOLDING = 3

} GRIPPER_STATE;

typedef enum RET_CODE {
ECODE_NO_ERROR = 0,
ECODE_ACTIVE = 1,
ECODE_ERROR = 2
} RET_CODE;

typedef enum MOVE_STATE {
   MOVE_IDLE = 0,
   MOVE_PLANNED = 1,
   MOVE_ACTIVE = 2
} MOVE_STATE;

typedef enum OP_STATE{
   IDLE = 0,
   PICK = 1,
   PUT = 2,
   GO_HOME = 3,
   SMALL_MOVE = 4
} OP_STATE;

typedef enum ACTION_STATE{
   PLAN = 0,
   GO_TO = 1,
   EXECUTE = 2
} ACTION_STATE;

typedef enum PICK_STATE{
   PICK_WAIT = 0,
   PICK_PLAN = 1,
   PICK_GO_IN = 2,
   PICK_WAIT_IN = 3,
   PICK_GRIP_BLOCK = 4
} PICK_STATE;

typedef enum CMD_TYPE{
   CMD_HOME = 0,
   CMD_PICK = 1,
   CMD_PLACE = 2,
   CMD_SMALL_MOVE = 3
} CMD_TYPE;


struct RobotState {
   uint8_t OpMode;
   vector<float> thetas;
   RET_CODE eMoveState;
};

struct TrajPt {
   vector<float> thetas;
   vector<float> theta_dots;
};

struct CommState {
   list<Command>* cmd_list;
   RobotState* rob_state;
   //TrajectoryGenerator* traj_gen;
};

static vector<vector<float>> Eye(int num)
{
   vector<vector<float>> ret;
   vector<float> temp(num);
   for (int i = 0; i < num; i++)
      ret.push_back(temp);
   for (int i = 0; i < num; i++)
      ret[i][i] = 1.0;
   return ret;
}

#endif
