#include "VacuumHandler.h"

using namespace std;

VacuumHandler::VacuumHandler() {

  m_pRelay = new GPIOClass("4");
  m_pRelay->export_gpio();
  m_pRelay->setdir_gpio("out");
  m_pRelay->setval_gpio("1");
  m_bVacState = false;


  m_pCurrentSensor = new ADS1115();
  m_pCurrentSensor->initialize();

}

bool VacuumHandler::Update(bool bRelayState) {

   static bool bFirst = true;
   static bool bLastRelayState = false;
   static bool bLastVacState = false;

   if(bRelayState != bLastRelayState)
   {
      if (bRelayState)
         m_pRelay->setval_gpio("0");
      else
         m_pRelay->setval_gpio("1");
   }

   int16_t val = m_pCurrentSensor->getConversionP0GND();
   if (bFirst)
      m_fVolts = float(val);

   m_fVolts = float(val)*m_fLPGain + (1-m_fLPGain)*m_fVolts;

   //printf("%f\n", m_fVolts);

   if (m_bVacState)
   {
      if (m_fVolts < m_fLowThreshold)
         m_bVacState = false;
   }
   else
   {
      if (m_fVolts > m_fHighThreshold)
         m_bVacState = true;
   }

   if (!bRelayState)
      m_bVacState = false;

   if (bLastVacState != m_bVacState)
      printf("Vac state change: %s\n", (m_bVacState) ? "on" : "off");

   bLastVacState = m_bVacState;
   bFirst = false;
   bLastRelayState = bRelayState;

   return m_bVacState;
}

