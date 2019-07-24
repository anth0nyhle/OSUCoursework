//Code for Lab 3 part 3 button debouncing
//Callie Branyan 4/22/2019

//Initialize pins and variables
const int buttonPin = 2;
volatile int buttonState = 0;
int count = 0;

//additional variables for implementing software debouncing technique
long debounce_time = 100; //change between 15 and 100 to see difference in debouncing 
volatile unsigned long last_micros;


void setup() {

Serial.begin(9600);
pinMode(buttonPin, INPUT);
//unfiltered button pressing. comment out when implementing software debouncing
attachInterrupt(digitalPinToInterrupt(buttonPin), increase_count, RISING);

// uncomment when implementing the software debouncing
//attachInterrupt(0, debounceInterrupt, RISING);

}

void loop() {

  Serial.println(count);
  delay(100);

}

//interrupt function for software debouncing
void debounceInterrupt() {
  if((long)(micros()-last_micros) >= debounce_time*1000) {
    increase_count();
    last_micros = micros();
  }
}

//function for increasing button count
void increase_count() {
  
  count = count + 1;
  
}

