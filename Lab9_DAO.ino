//Devin Otwell
//Dr. Mitchell
//ENME351
//Lab9 Final Project

const int motor_pin = 9;
const int button_pin = 2;
const int trig_pin = 7;
const int echo_pin = 6;
const int servo_pin = 11;
const int reset_butt = 4;

int motorState = LOW; 
int state;
int reset_stat;
long duration;

void setup() {
  Serial.begin(9600);
  pinMode(motor_pin, OUTPUT);
  pinMode(button_pin, INPUT_PULLUP); //sets the button state HIGH
  pinMode(reset_butt, INPUT_PULLUP); //sets the button state HIGH
  pinMode(trig_pin, OUTPUT);
  pinMode(echo_pin, INPUT);
  pinMode(servo_pin, OUTPUT);
}

void loop() {
  state = digitalRead(button_pin); //"Science Buddies" on youtube (https://www.youtube.com/watch?v=XrJ_zLWFGFw)
  reset_stat = digitalRead(reset_butt); 

  Serial.print(reset_stat);
  Serial.print("\t");

  if (state == LOW) { //"Science Buddies" on youtube (https://www.youtube.com/watch?v=XrJ_zLWFGFw), they gave me the idea to use the button state, I adjusted it to make the motor run continously
    motorState = !motorState; // This conditional checks if the motor button state is LOW, if it is, it changes the motor state to the opposite of what it was before, toggling the motor on and off. 
    digitalWrite(motor_pin, motorState);

    while(digitalRead(button_pin) == LOW) { //this while loop runs while the button is pressed, safety net to avoid double clicks
      delay(10);
    }
  }

  digitalWrite(trig_pin, LOW); //"Science Buddies" on youtube (https://www.youtube.com/watch?v=n-gJ00GTsNg) 
  delayMicroseconds(2); // "Science Buddies"
  digitalWrite(trig_pin, HIGH); //"Science Buddies"
  delayMicroseconds(10); //"Science Buddies"
  digitalWrite(trig_pin, LOW); //"Science Buddies" 

  duration = pulseIn(echo_pin, HIGH); //"Science Buddies" on youtube (https://www.youtube.com/watch?v=n-gJ00GTsNg)
  float distance = duration / 58; //Converts time from the ultrasonic to cm. 
  Serial.print(distance);
  Serial.print("\t");
  Serial.println(duration);

  if (duration < 300 ) { //This controls the servo, if the reading from the ultrasonic is less than 300, the for loops below move the servo into and out of poisiton. The else statement is always true otherwise.
    for (int i = 0; i < 800; i++) {
      digitalWrite(servo_pin, HIGH);
      delayMicroseconds(1800);
      digitalWrite(servo_pin, LOW);
      delayMicroseconds(20000 - 1800);
    }

    for (int i = 0; i < 25; i++) {
      digitalWrite(servo_pin, HIGH);
      delayMicroseconds(1500);
      digitalWrite(servo_pin, LOW);
      delayMicroseconds(20000 - 1500);
    }
  } else {
    digitalWrite(servo_pin, HIGH);
    delayMicroseconds(1500);
    digitalWrite(servo_pin, LOW);
    delayMicroseconds(20000 - 1500);
  }

  delay(1000);
}
