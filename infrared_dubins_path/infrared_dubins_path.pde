/*
Thomas Sanchez Lengeling
 http://codigogenerativo.com/
 
 How to use multiple Kinects v2 in the same sketch.
 Should work up n number of Kinects v2 connected to the USB 3.0 port.
 
 https://github.com/shiffman/OpenKinect-for-Processing
 http://shiffman.net/p5/kinect/
 */
// Kinect Library
import org.openkinect.processing.*;

// client
import processing.net.*; 
Client myClient;

// OpenCV Library
import gab.opencv.*;
import java.awt.Rectangle;

// Kinect Stuff
final int NUM_CAMS = 2;
Kinect2 kinect2a, kinect2b;

//Distance parameters in mm
//// CHANGE this to change how far way you can sense objects 
//// need to make Min_Depth smaller to catch dog 
int MAX_D = 4050; //This should be distance to floor 3900
int MIN_D = 2000; //2cm 500

// Depth Map resolution
int RESOLUTION = 2; //changed from 4 to 1
// Is the camera facing right-side up?
int [][] shifts = { { 0, 30}, { -30, 0} };

final int WIDTH = 1920;
final int HEIGHT = 1080;
// This needs to be calibrated
final int CAM_WIDTH = 512;
final int CAM_CENTERX = CAM_WIDTH / 2;
final int CAM_HEIGHT = 424;
final int CAM_CENTERY = CAM_HEIGHT / 2;

// Horizonal FOV of Kinect in degrees
final float HFOV = 70.6;

// Scale camera data (mm) to pixels
// tan(35.3deg)*MAX_D*2 = width of camera in mm (~5500mm)
float mm2px = 0.125; //abs(CAM_WIDTH / ((tan(degrees(HFOV/2))*MAX_D*2))); // Probably ~0.09;

// Scale camera resolution to projection resolution
float cam2proj = 2.25; //WIDTH/(CAM_HEIGHT*2);

// OpenCV Stuff
OpenCV opencv;
// Resolution of contour (1 is highest, 10 is lower)
int polygonFactor = 1;
// Contrast tolerance for detecting foreground v. background
int threshold = 10; // was 10
// How big the contour needs to be
int numPointsMin = 30;      //was 100 (was numPoints), 50 saw the dog,
int numPointsMax = 100;
// Off-screen canvas to draw the depth map point cloud data to
PGraphics pg;
// Image to feed to openCV
PImage img;

void setup() {
  //size(848, 512);
  size(1920, 1080);
  //fullScreen();

  // Set-up image objects to feed to OpenCV
  pg = createGraphics(CAM_HEIGHT*2, CAM_WIDTH);
  img = createImage(pg.width, pg.height, GRAY);

  // Set-up OpenCV
  opencv = new OpenCV(this, pg.width, pg.height);

  // Set-up Kinects 
  kinect2a = new Kinect2(this);
  //kinect2a.initDepth();
  kinect2a.initIR();

  kinect2b = new Kinect2(this);
  //kinect2b.initDepth();
  kinect2b.initIR();
  
  kinect2a.initDevice(0);
  kinect2b.initDevice(1);

  // Draw the background
  background(0);
  frameRate(25);//was 25 originally
  
  myClient = new Client(this, "127.0.0.1", 12345); 
}

void draw() {
  background(0);

   //Fire up the PGraphic
  pg.beginDraw();
  pg.background(0);
  pg.pushMatrix();
  pg.translate(0, 0);
  pg.scale(-1, 1);
  pg.rotate(PI/2);
  //getDepth(kinect2a)
  pg.image(kinect2a.getIrImage(), 0, 0);
  pg.popMatrix();

  pg.pushMatrix();
  pg.translate(240,16); //if kinects intalled perfectly, it should be (394, 0)
  //pg.translate(shifts[1][0], shifts[1][1]);
  //pg.scale(mm2px, -mm2px);
  pg.scale(1, -1);
  pg.rotate(-PI/2);
  //getDepth(kinect2b);
  pg.image(kinect2b.getIrImage(), 0, 0);
  pg.popMatrix();
  pg.endDraw();
  //image(pg,0,0);
   //Transfer PGraphic data over into an PImage
   //openCV won’t accept PGraphic objects and your can’t draw directly to PImage objects

   //Load the pixels for pg and img into memory so you can use them.
  pg.loadPixels();
  img.loadPixels();
  // Set img pixel data equal to pg pixel data
  img.pixels = pg.pixels;
  img.updatePixels();
  //text(frameRate, width/2, height/2 - 100);
  ////what's this for? it just gets you the brightness of a random pixel in img?
  //text(brightness(img.pixels[int(random(img.pixels.length))]), width/2, height/2);
  
  // Send the PImage into OpenCV
  opencv.loadImage(img);
  opencv.gray();
  opencv.threshold(threshold);
  image(opencv.getSnapshot(), 0, 0);        //This is to see what OpenCV sees
  
  // Get some contours
  ArrayList<Contour>contours = opencv.findContours(false, false);
  //println(contours.size());

  pushMatrix();
  //scale(2, 2);
  //scale(cam2proj, cam2proj);
  
  for (Contour contour : contours) {
    // Set resolution of contour
    contour.setPolygonApproximationFactor(polygonFactor);
    if (contour.numPoints() > numPointsMin && contour.numPoints() < numPointsMax) {
      // If the contour is big enough
      stroke(255); //white
      beginShape();
      
      // Get the contour's bounding box
      Rectangle bb = contour.getBoundingBox();
      // Ignore little contours
      //// CHANGE: make smaller to not ignore small dog
      float area = contour.area();
      //if(area < 2) continue; //don't ignore anything
      
      stroke(0, 200, 200);
      noFill();
      rect(bb.x, bb.y, bb.width, bb.height); //uses the java Rectangle to draw a retangle in Processing
      // Calculate the center of the bounding box
      PVector center = new PVector(bb.x + bb.width/2, bb.y + bb.height/2);
      // Add the center to the locations message
      centers.add(center.x * cam2proj + "," + center.y * cam2proj);
      ellipse(center.x, center.y, 10, 10);
      println("x = ", center.x, "y = ", center.y);
      
      myClient.write(center.x + ","+ center.y);
    }
  }
  popMatrix();

  pushMatrix();
  translate(100,80);
  drawgrid(5,5,40);
  popMatrix();
}

void drawgrid(int cols, int rows, int cellSize){
  stroke(255);
  
  for (var x = 0; x <= rows*cellSize; x += cellSize) {
    line(x, 0, x, cols*cellSize);
  }
  //Horizontal Lines
  for (var y = 0; y <= cols*cellSize; y += cellSize) {
    line(0, y, cellSize*rows, y);
  } 
}

void walkForward(){
  newdirection = "kwkF";
}
void walkForwardRight(){
  newdirection = "kwkR";
}
void walkForwardLeft(){
  newdirection = "kwkL";
}
void stopdog(){
  newdirection = "kbalance";
}

void keyPressed() {
  if (keyCode == TAB) {
    Kinect2 kinect3a = kinect2a;
    Kinect2 kinect3b = kinect2b;
    kinect2a = kinect3b;
    kinect2b = kinect3a;
  }
  else if(keyCode == UP) {
   cam2proj += 0.1; 
  }
  else if(keyCode == DOWN) {
   cam2proj -= 0.1; 
  }
}
