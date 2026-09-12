//Devin Otwell
//Dr. Mitchell
//ENME351
//Lab9 Final Project

import processing.serial.*; // serial library
Serial myPort;

int usonic_val = 0;
int pack_count = 0;
int reset_state = 0;
int x_pos = 0;
float y_pos = 0;
float y_val = 595;
int startTime;

void setup() {
size(612, 612); //Set window size
background(0,0,255); //Background color
fill(0,0,0);
rect(10, 10, 420, 55);
fill(255,255,255);
rect(20, 80, 220, 100); //Bin counter box
line(20, 120, 240, 120); //Everything under here up until println is just prepping the look of the window
line(130, 80, 130, 180);
fill(255,255,255);
textSize(50);
text("Conveyor Statistics", 15, 50);
fill(0,0,0);
textSize(20);
text("Bin #", 55, 105);
text("# Sorted", 145, 105);
text("1", 72, 150);
fill(255,0,0);
rect(15, 200, 580,400);
fill(0,0,0);
rect(15, 200,580,50);
fill(255,255,255);
textSize(30);
text("Package Flowrate (PPH)", 160, 235);
line(15, 320, 595, 320);
line(15, 390, 595, 390);
line(15, 460, 595, 460);
line(15, 530, 595, 530);
line(15, 600, 595, 600);
textSize(15);
text("UID:117512458", 500, 25);
println(Serial.list()); // lists available serial ports, some lines of this code like this one and the 2 below it originated from Lab5
myPort = new Serial(this, Serial.list()[0], 9600); // Input port
myPort.clear(); // Clear port of uneeded data
startTime = millis(); // Start timer
}

void draw () {
x_pos++; //Begin incrementing x counter for my flowrate plot
int timeElapsed = millis() - startTime; // Determines time elapsed
float timeHour = timeElapsed / 3600000.0; //Converts to hours for PPH (flowrate plot)
while (myPort.available () > 0) { // make sure port is open // Sourced from Lab5
String inString = myPort.readStringUntil('\n'); // read input string //Sourced from Lab5
if (inString != null) { // ignore null strings //Sourced from Lab5
inString = trim(inString); // trim off any whitespace // Sourced from Lab5
String[] xyzaRaw = splitTokens(inString, "\t"); // Sourced from Lab5
if (xyzaRaw.length == 2) { //Sourced from Lab5
reset_state = int(xyzaRaw[0]); //Sourced from Lab5
usonic_val = int(xyzaRaw[1]); //Sourced from Lab5
print(reset_state);
print("\t");
println(usonic_val);
if (usonic_val < 300) { //Increments the pack_count variable if the serial monitor reads a value from the ultrasonic below 300
pack_count = pack_count + 1;
fill(255,255,255); //Sets the color of future box to white
stroke(255,255,255); //Sets the borders of the box to white
rect(160, 130, 50, 30); //Draws a box over the old number
fill(0,0,0); //Selects black as the color for the new number
text(pack_count, 175, 150); //Writes the new number
}
if (reset_state == 0) { //Runs if the serial monitor sees the reset button pressed
pack_count = 0; //Resets the pack count to zero
fill(255,255,255); //Sets the color of the box about to be drawn to white.
stroke(255,255,255); //Sets the borders of the box to white
rect(160,130,50,30); //Draws a box over the number
fill(0,0,0); //Color of the new number
text(pack_count, 175,150); //Writes the new number
}
y_pos = pack_count / timeHour; //Gets the y position of the flowrate ticker in terms of packages per hour
y_val = map(y_pos, 0, 900, 595, 255); //Scales this value so that it is drawn in the proper direction and on the area where the plot is supposed to be
if (y_pos >= 874) { //Ensures that the ticker stays within the upper limits of the plot area
y_val = 255;
}
println(y_pos);
}
}
}
fill(0,255,0); //Color of the ticker
ellipse(x_pos, y_val, 10,10); //Ticker
if(x_pos <= 20) { //Keeps the ticker from being written over the left end of the plot area
x_pos = 20;
}
if (x_pos >= 590) { //Keeps the ticker from being written over the right end of the plot area and redraws the plot area so that a new line can be drawn and the old one can be erased.
fill(255,0,0);
rect(15, 200, 580,400);
fill(0,0,0);
rect(15, 200,580,50);
fill(255,255,255);
textSize(30);
text("Package Flowrate (PPH)", 160, 235);
line(15, 320, 595, 320);
line(15, 390, 595, 390);
line(15, 460, 595, 460);
line(15, 530, 595, 530);
line(15, 600, 595, 600);
x_pos = 20;
}
