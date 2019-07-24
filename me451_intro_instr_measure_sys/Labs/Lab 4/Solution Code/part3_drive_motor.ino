//Code for Lab 4 part 3 driving the motor
//Callie Branyan 5/1/2019

//uses motor #3 which counts an average of 698 ticks for 1 revolution of the shaft

//Does not account for overshoot, though at slow speed it's not much

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

//Start running motor with speed 50 on range of 0-255
  analogWrite(ENA, 50);

  Serial.print("Ticks = ");
  Serial.println(ticks);
  
//Change direction when passing 1000 ticks
  if(ticks >= 1000)  {
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, HIGH);
  }
//Change direction when passing 0 ticks
  if(ticks <= 0)  {
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

