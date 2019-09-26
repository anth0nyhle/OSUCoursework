// Basic demo for accelerometer readings from Adafruit LIS3DH

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

float x_volt, y_volt, z_volt;
float x_g, y_g, z_g;
float x_deg, y_deg, z_deg;


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
}

void loop() {
  lis.read();      // get X Y and Z data at once in bits
    
  // Then print out the raw data
//  Serial.print("X:  "); Serial.print(lis.x); 
//  Serial.print("  \tY:  "); Serial.print(lis.y); 
//  Serial.print("  \tZ:  "); Serial.print(lis.z); 

// Convert from bits to volts. 3.3V input to accel, 2^15 bits read by accel with sign bit excluded
// b is +1.65 to account for FSR/2 = 3.3/2
// should be reading about 2.4V for 1G, 0.8V for -1G, and 1.65V for 0G
  x_volt = (3.3/65536) * lis.x + 1.65;
  y_volt = (3.3/65536) * lis.y + 1.65;
  z_volt = (3.3/65536) * lis.z + 1.65;

// Convert from volts to g's using volt values read at 0,1,-1 g's for each axis
  x_g = (x_volt)/0.8 - 2;
  y_g = (y_volt)/0.8 - 2;
  z_g = (z_volt)/0.8 - 2;

// Convert from g's to degrees
  x_deg = 90*x_g;
  y_deg = 90*y_g;
  z_deg = 90*z_g;


// Print out in readable format
Serial.print("X Volts = ");
Serial.print(x_volt);
Serial.print("  \tY Volts = ");
Serial.print(y_volt);
Serial.print("  \tZ Volts = ");
Serial.println(z_volt);

Serial.print("X G's ");
Serial.print(x_g);
Serial.print("  \tY G's ");
Serial.print(y_g);
Serial.print("  \tZ G's ");
Serial.println(z_g);

Serial.print("X degs ");
Serial.print(x_g);
Serial.print("  \tY degs  ");
Serial.print(y_deg);
Serial.print("  \tZ degs  ");
Serial.println(z_deg);
  
  /* Or....get a new sensor event, normalized */ 
  sensors_event_t event; 
  lis.getEvent(&event);
  
  /* Display the results (acceleration is measured in m/s^2) */
//  Serial.print("X Volts = "); Serial.print(z_volt);
//  Serial.print("  \tY Volts =  "); Serial.print(z_volt);
//  Serial.print("  \tZ Volts =   "); Serial.print(z_volt);
//  Serial.print("\tX: "); Serial.print(event.acceleration.x);
//  Serial.print(" \tY: "); Serial.print(event.acceleration.y); 
//  Serial.print(" \tZ: "); Serial.print(event.acceleration.z); 
  //Serial.println(" m/s^2 ");

  Serial.println();
 
  delay(200); 
}
