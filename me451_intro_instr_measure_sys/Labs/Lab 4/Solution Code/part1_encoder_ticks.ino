//Code for Lab 4 part 1 encoder counts
//Callie Branyan 4/30/2019

//Initialize pins and variables

//Channel A needs to be on interrupt pin 2
const int encoderA = 2;
const int encoderB = 4;
int count = 0;


void setup() {

Serial.begin(9600);
pinMode(encoderA, INPUT);
//If seeing signal on Channel A, jump to interrupt to count ticks
attachInterrupt(digitalPinToInterrupt(encoderA), tick_counts, RISING);
}

void loop() {
//Continually prints counts
  Serial.println(count);

//Delay for a speed of prints that is readable on monitor  
  delay(100);

}

//function for counting ticks depending on state of Encoder Channel B
//Based on a check on an initial guess, my Channel B is high when turning the shaft CW and low when turning CCW
    //swap LOW/HIGH or -/+ if you're supposed to choose CW or CCW based on looking at the wheel head on
void tick_counts() {
  if(digitalRead(encoderB) == HIGH)  {
    count = count + 1;
  }
  else {
    count = count - 1;
  }
  
}

