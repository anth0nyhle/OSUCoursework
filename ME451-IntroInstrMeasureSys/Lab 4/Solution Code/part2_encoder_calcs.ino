//Code for Lab 4 part 2 calculating velocity etc. 
//Callie Branyan 4/30/2019

//This version resets the angle to keep it within a -360 to 360 deg range over multiple revolutions
//Check student's set up as they might have only implemented a soln for one revolution spin the shaft at least twice for a signoff

//uses motor #3 which counts an average of 698 ticks for 1 revolution of the shaft

//Initialize pins and variables

//Channel A needs to be on interrupt pin 2
const int encoderA = 2;
const int encoderB = 3;
int ticks = 0;

float current_angle = 0.0;
float distance = 0.0;
float velocity = 0.0;
float old_angle = 0.0;

void setup() {

Serial.begin(9600);

pinMode(encoderA, INPUT);
pinMode(encoderB, INPUT);

//If seeing signal on Channel A, jump to interrupt to count ticks
attachInterrupt(digitalPinToInterrupt(encoderA), tick_counts, RISING);
}

void loop() {

//Keeps track of current angle for velocity calc
  current_angle = (360.0/698.0)*ticks;
  
//After really looking at the output on degrees when turning the shaft many revolutions in both directions there's something funky going on so this isn't completely working

//keeps angle on 0 to 360 range by calculating how many revolutions there's been
  if (current_angle >= 360) {
    current_angle = current_angle - (360.0 * (ticks/698));
  }
//keeps angle on -360 to 0 range and dealing with the sign on the ticks
  if (current_angle <= -360)  {
    current_angle = current_angle + (360.0 * (-1*ticks/698));
  }

//Circumference = 9 so you travel 9pi cm for every revolution and my motor has 698 ticks per 1 revolution
  distance = (9.0/698.0)*ticks;

//Use delay as dt so dt = 100ms and get d_theta by subtracting old angle from new angle
  velocity = (current_angle - old_angle) / 0.1; //dt = 100 ms = 0.1s

//Printing in a nice format  
  Serial.print("Ticks = ");
  Serial.print(ticks);
  Serial.print("  ,  ");
  Serial.print("Angle = ");
  Serial.print(current_angle);
  Serial.print(" degs");
  Serial.print("  ,  ");
  Serial.print("Dist. = ");
  Serial.print(distance);
  Serial.print(" cm");
  Serial.print("  ,  ");
  Serial.print("Vel. = ");
  Serial.print(velocity);
  Serial.println(" deg/s");

//Sets old angle to current angle so we can do a velocity calculation
  old_angle = current_angle;
  
//Delay to set dt
  delay(100);

}

//function for counting ticks depending on state of Encoder Channel B
//Based on a check on an initial guess, my Channel B is HIGH when turning the shaft CW and low when turning CCW
void tick_counts() {
  if(digitalRead(encoderB) == HIGH)  {
    ticks = ticks + 1;
  }
  else {
    ticks = ticks - 1;
  }
  
}

