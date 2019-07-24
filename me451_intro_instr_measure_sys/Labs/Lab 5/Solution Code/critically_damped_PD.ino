//Code for Lab 5 part 1 critically damped PID controller
//Started with the basic example and change accordingly 
/********************************************************
 * PID Basic Example
 * Reading analog input 0 to control analog PWM output 3
 ********************************************************/

#include <PID_v1.h>
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

//PD values for critically damped around 1524 ticks on motor #3 written on mount 
double Kp = 0.12;
double Ki = 0;
double Kd = 0.011;

//PI values for critically damped
//double Kp = 0.19;
//double Ki = 0.2;
//double Kd = 0;

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
  Setpoint = 1500;

  //turn the PID on
  myPID.SetMode(AUTOMATIC);

  //Set output for direction commands
  myPID.SetOutputLimits(-255,255);

  //If seeing signal on Channel A, jump to interrupt to count ticks
attachInterrupt(digitalPinToInterrupt(encoderA), tick_counts, RISING);

}


void loop()
{
  Serial.println(ticks);
  //Input = analogRead(PIN_INPUT);
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

