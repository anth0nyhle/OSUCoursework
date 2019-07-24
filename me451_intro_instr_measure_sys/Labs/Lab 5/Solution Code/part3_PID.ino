//Code for Lab 5 part 3 PID control following a sine wave setpoint
//Started with the basic example and change accordingly 
/********************************************************
 * PID Basic Example
 * Reading analog input 0 to control analog PWM output 3
 ********************************************************/

#include <PID_v1.h>

unsigned long timer;

//Defining encoder pins
const int encoderA = 2;
const int encoderB = 4;
int IN1 = 9;
int IN2 = 8;

//#define PIN_INPUT 0
//#define PIN_OUTPUT 3

#define PIN_INPUT 0
//ENA pin
#define PIN_OUTPUT 10

//Define Variables we'll be connecting to
double Setpoint, Input, Output;

//Specify the links and initial tuning parameters

//PD values for critically damped around 1500 ticks on motor #3 written on mount: Kp = 0.12 and Kd = 0.018 
double Kp = 0.12;
double Ki = 0;
double Kd = 0.018;

PID myPID(&Input, &Output, &Setpoint, Kp, Ki, Kd, DIRECT);


int ticks = 0;
void setup()
{
  Serial.begin(9600);

  pinMode(encoderA, INPUT);
  pinMode(encoderB, INPUT);
  //pinMode(ENA, OUTPUT);
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  
  //initialize the variables we're linked to
  //Input = analogRead(PIN_INPUT);
  Input = ticks;

  //turn the PID on
  myPID.SetMode(AUTOMATIC);

  //Set output for direction commands
  myPID.SetOutputLimits(-255,255);

  //If seeing signal on Channel A, jump to interrupt to count ticks
attachInterrupt(digitalPinToInterrupt(encoderA), tick_counts, RISING);

}


void loop()
{
  timer = millis();
  
  //sine wave with 750 tick amp and a 0.1Hz frequency
  //f = 0.1Hz period = 2pif
  Setpoint = 750*sin(2*3.14*0.1*timer/1000);
  
  //Serial.print(timer);
  //Serial.print("  ,  ");
  Serial.print(Setpoint);
  Serial.print("  ,  ");
  Serial.println(ticks);
  
  Input = ticks;
  myPID.Compute();

//If statements for setting pos/neg sign to opposite directions on motor
  if(Output > 0)  {
    digitalWrite(IN1, HIGH);
    digitalWrite(IN2, LOW);   
  }

  if(Output < 0)  {
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, HIGH);    
  }
  
  analogWrite(PIN_OUTPUT, abs(Output));

  delay(1);
}


//function for counting ticks depending on state of Encoder Channel B
//Based on a check on an initial guess, my Channel B is HIGH when turning the shaft CW and low when turning CCW

void tick_counts() {
  if(digitalRead(encoderB) == HIGH)  {
    ticks = ticks - 1;
  }
  else {
    ticks = ticks + 1;
  }
  
}

