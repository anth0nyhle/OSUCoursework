/*
 * Interrupt vs Polling LED race
 * code by John Morrow
 */


// ********** Staging area **********

//pin variables
const int ledpin_interrupt = 4;
const int ledpin_polling = 5;
const int interruptPin = 2;
const int pollingPin = 12;

//variables to store button and time info
volatile int state_interrupt = 0;
int state_polling = 0;

volatile double interrupt_time = 0;
double polling_time = 0;

//flags so serial monitor only prints each time once
int int_flag=1;
int poll_flag=1;

void setup() {
  // for all functions that set things up on the arduino

  //setup pins for LEDS and buttons
  //outputs
  pinMode(ledpin_interrupt, OUTPUT);
  pinMode(ledpin_polling, OUTPUT);
  
  //inputs
  pinMode(interruptPin, INPUT_PULLUP);
  pinMode(pollingPin, INPUT);

  //set up serial monitor
  Serial.begin(9600); 

  //setup interrupt
  attachInterrupt(digitalPinToInterrupt(interruptPin), button_pressed, RISING);

 //delay to make sure everything sets up ok
delay(2000);

Serial.println("The race is ready to start!");

}

void loop() {
  //check that button was pressed
  state_polling = digitalRead(pollingPin);

  //if its on, measure the time
  if(state_polling){
    digitalWrite(ledpin_polling, HIGH);
    polling_time = millis();
  }

  //print the time that we record for interrupts
  if(state_interrupt && int_flag){
    Serial.print("Interrupt triggered! time: ");
    Serial.println(interrupt_time);

    int_flag = 0; //so it only prints once
  }

  //print the time that we record for polling  
  if(state_polling && poll_flag){
    Serial.print("Polling triggered! time: ");
    Serial.println(polling_time);

    poll_flag = 0; //so it only prints once
  }

  // SET DELAY HERE FOR LAB
  delay(1);

}

//when button is pressed and interrupt is triggered, this function will happen immediately
void button_pressed(){
  //turn on LED
  digitalWrite(ledpin_interrupt, HIGH);
  interrupt_time = millis();

  //print interrupt results
  state_interrupt = 1;
}

