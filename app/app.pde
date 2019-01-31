/* Open Kinnect */
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

/** OSC used to communication with SuperCollider and Open Stage Controls */
import oscP5.*;
import netP5.*;


int rayIdCounter = 0;

// globals
System s; // recent group of particles
Canvas c; // main frame 
SoundBuffer b; // soundBuffer managed only by circular system
PApplet app; // link to this app
DepthControl k; // global kinect object
OscP5 oscP5;
NetAddress superCollider;

// visual output for debugging
boolean debug = true;

// Settings of canvas
PVector padding; // stores margin around the canvas
PVector paddingMin = new PVector(40,50); // initial value that serves for calculation of padding

// Settings of circular movement
float circularGridBoxSize = 165;
float circularGridRayRadius = 40;

// settings for circular sound
float bellAmplitude = 1;
float bellFrequency = 80;
float bellRelease = 2;
float bellAmp = 0.8;

// settings for collision sound
float currentVolume = 0;
float maxVolume = 0.8;
float availableVolume = maxVolume;
float collisionMinFreq = 200;
float collisionMaxFreq = 500;
float collisionMinRel = 2;
float collisionMaxRel = 4;
float collisionBlockAmount = 2; // aspect of the collision sound block in the range of 1 to N. the higher is, the bigger the block is.  


void setup(){
  // size(1920,1080);
  fullScreen();
  
  // initialize global variables
  app = this;
  c = new Canvas();
  k = new DepthControl();
  b = new SoundBuffer();
  oscP5 = new OscP5(this,5555);
  superCollider = new NetAddress("127.0.0.1",12000);
  
  // the system itself
  s = new CircularSystem();

}

void draw(){
  
  // regular updates
  currentVolume = 0;
  
  availableVolume = maxVolume;
  
  background(c.bg);
  s.update();
  
  
  if (debug) {
    c.render();
  }
  
  b.render();
  
  text("FR: " + String.valueOf(frameRate),10,20);
  
}
// Run the appripriate controls on mousepressed
void mousePressed(){
  if (s.controls.size()>0) {
    for (ControlGroup c : s.controls ) {
      c.listenMouse( s );
    }
  }
}

// Run the appropriete controls on incoming keyboard signals
void keyPressed() {
  if (s.controls.size()>0) {
    for (ControlGroup c : s.controls ) {
      c.listenKeyBoard( s );
    }
  }
}

// Run the appropriete controls on incoming OSC signals
void oscEvent(OscMessage incoming){
  //if (s.controls.size()<0) {
    for (ControlGroup c : s.controls ) {
      c.listenOSC( s, incoming );
    }
  // }
}
