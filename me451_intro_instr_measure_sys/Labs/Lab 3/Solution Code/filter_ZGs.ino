// Code for Lab 3 part 1 moving average filter
//I think it works correctly
//Callie Branyan 4/22/2019

#include <Wire.h>
#include <SPI.h>
#include <Adafruit_LIS3DH.h>
#include <Adafruit_Sensor.h>

// Used for software SPI
#define LIS3DH_CLK 13
#define LIS3DH_MISO 12
#define LIS3DH_MOSI 11
// Used for hardware & software SPI
#define LIS3DH_CS 10

// software SPI
//Adafruit_LIS3DH lis = Adafruit_LIS3DH(LIS3DH_CS, LIS3DH_MOSI, LIS3DH_MISO, LIS3DH_CLK);
// hardware SPI
//Adafruit_LIS3DH lis = Adafruit_LIS3DH(LIS3DH_CS);
// I2C
Adafruit_LIS3DH lis = Adafruit_LIS3DH();

#if defined(ARDUINO_ARCH_SAMD)
// for Zero, output on USB Serial console, remove line below if using programming port to program the Zero!
   #define Serial SerialUSB
#endif

float z_volt, z_volt_avg;
float z_g, z_g_avg;

unsigned long t;

const int numReadings = 10;

float readings[numReadings];      // the readings from the analog input
int readIndex = 0;              // the index of the current reading
float total = 0.0;                  // the running total
float average = 0.0;                // the average

void setup(void) {
#ifndef ESP8266
  while (!Serial);     // will pause Zero, Leonardo, etc until serial console opens
#endif

  Serial.begin(9600);
  Serial.println("LIS3DH test!");
  
  if (! lis.begin(0x18)) {   // change this to 0x19 for alternative i2c address
    Serial.println("Couldnt start");
    while (1);
  }
  Serial.println("LIS3DH found!");
  
  lis.setRange(LIS3DH_RANGE_2_G);   // 2, 4, 8 or 16 G!
  
  Serial.print("Range = "); Serial.print(2 << lis.getRange());  
  Serial.println("G");

    // initialize all the readings to 0:
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
  }
}

void loop() {
  t = millis();
  lis.read();      // get X Y and Z data at once in bits

// Convert raw data from bits to volts
  z_volt = (3.3/65536) * lis.z + 1.65;

// Convert from volts to g's
  z_g = (z_volt)/0.8 - 2;

// subtract the last reading:
  total = total - readings[readIndex];
// read from the sensor:
  readings[readIndex] = z_g;
// add the reading to the total:
  total = total + readings[readIndex];
// advance to the next position in the array:
  readIndex = readIndex + 1;

// if we're at the end of the array...
  if (readIndex >= numReadings) {
    // ...wrap around to the beginning:
    readIndex = 0;
  }

// calculate the average:
  average = total / numReadings;
 
  Serial.print("Time = ");
  Serial.print(t);
  Serial.print("  \tZ_G = ");
  Serial.print(z_g);
  Serial.print("  \tFiltered Z_G = ");
  Serial.println(average);
  delay(1);        // delay in between reads for stability

//
  delay(100); 
}
