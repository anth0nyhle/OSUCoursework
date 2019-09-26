#ifndef VACUUM_HANDLER_H
#define VACUUM_HANDLER_H

#include <stdint.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>
#include "I2Cdv.h"
#include "ADS1115.h"
#include "GPIOClass.h"
#include <sys/time.h>


class VacuumHandler {

public:
   VacuumHandler();

   bool Update(bool bRelayState);

private:

   GPIOClass* m_pRelay;
   ADS1115* m_pCurrentSensor;

   float m_fVolts;

   static constexpr float m_fLPGain = 0.1;
   static constexpr float m_fLowThreshold = 21800.0f;
   static constexpr float m_fHighThreshold = 21400.0f;

   bool m_bVacState;

};


#endif
