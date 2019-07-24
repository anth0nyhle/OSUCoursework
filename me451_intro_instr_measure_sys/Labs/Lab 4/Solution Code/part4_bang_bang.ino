//Code for Lab 4 part 4 bang-bang controller
//Callie Branyan 5/6/2019

//Initialize pins
//Channel A needs to be on interrupt pin 2
const int encoderA = 2;
const int encoderB = 4;
int ENA = 10;
int IN1 = 9;
int IN2 = 8;

//Initialize variables
int ticks = 0;

void setup() {

Serial.begin(9600);

pinMode(encoderA, INPUT);
pinMode(encoderB, INPUT);
pinMode(ENA, OUTPUT);
pinMode(IN1, OUTPUT);
pinMode(IN2, OUTPUT);

//If seeing signal on Channel A, jump to interrupt to count ticks
attachInterrupt(digitalPinToInterrupt(encoderA), tick_counts, RISING);
}

void loop() {

//Start motor at full speed
  analogWrite(ENA, 255);

  Serial.print("Ticks = ");
  Serial.println(ticks);
  
//Setpoint is 1000 ticks. Switch directions back and forth of 1000 ticks to try and "hover" there. Will never be at steady state
//It definitely goes back and forth around 1000, did not implement anything to deal with overshoot
  
  if(ticks >= 1000)  {
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, HIGH);
  }
  else  {
    digitalWrite(IN1, HIGH);
    digitalWrite(IN2, LOW);
  }
delay(100);
  
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

