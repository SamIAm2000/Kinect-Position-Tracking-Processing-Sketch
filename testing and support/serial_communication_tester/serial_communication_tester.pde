import processing.serial.*;
Serial myPort;
void setup(){
   size(848, 512);
   myPort = new Serial(this, Serial.list()[2], 115200);     //Outgoing commands
   
}
void draw(){
}
void walkForward(){
  myPort.write("kwkF");
  //myPort.write('\n');
  println("walk");
}
void stopdog(){
  myPort.write("kbalance");
  //myPort.write('');
  println("stop");
}

void keyPressed() {
  if (keyCode == UP) {
    stopdog();
  } else if (keyCode == DOWN) {
    walkForward();
  }
}
