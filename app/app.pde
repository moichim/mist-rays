/* Open Kinnect */
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

/** OSC used to communication with SuperCollider and Open Stage Controls */
import oscP5.*;
import netP5.*;

// conter of ray IDS
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
boolean debug = false;

// Settings of canvas
PVector padding; // stores margin around the canvas
PVector paddingMin = new PVector(40,50); // initial value that serves for calculation of padding

// global settings
float speedAspect = 0.7;

// Settings of circular movement
float circularGridBoxSize = 165;
float circularGridRayRadius = 40;

// settings for circular sound
float bellAmplitude = 1;
float bellFrequency = 52;
float bellAtk = 0.01;
float bellRelease = 2;
float bellAmp = 0.8;

// settings for collision sound
float currentVolume = 0;
float maxVolume = 0.8;
float availableVolume = maxVolume;
float collisionMinFreq = 100;
float collisionMaxFreq = 300;
float collisionAtk = 0.05;
float collisionMinRel = 1.58;
float collisionMaxRel = 4.22;
float collisionBlockAmount = 1.25; // aspect of the collision sound block in the range of 1 to N. the higher is, the bigger the block is.  

KinectSignal kn;

void setup(){
  size(1920,1080);
  // fullScreen();
  
  // initialize global variables
  app = this;
  c = new Canvas();
  //k = new DepthControl();
  b = new SoundBuffer();
  oscP5 = new OscP5(this,5555);
  superCollider = new NetAddress("127.0.0.1",12000);
  
  kn = new KinectSignal();
  
  // the system itself
  s = new System();

}

void draw(){
  
  
  // regular updates
  currentVolume = 0;
  
  availableVolume = maxVolume;
  
  background(c.bg);
  
  if (frameCount % 5 == 0) {
    kn.update();
  }
  
  
  kn.render();
  
  
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
