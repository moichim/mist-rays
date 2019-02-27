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
OscP5 oscP5;
NetAddress superCollider;
SoundRouter router; // rozbočovač zvuků

// visual output for debugging
boolean debug = false;

// Settings of canvas
PVector padding; // stores margin around the canvas
PVector paddingMin = new PVector(40,50); // initial value that serves for calculation of padding

// global settings
float speedAspect = 0.5;

// Settings of circular movement
float circularGridBoxSize = 150;//70; // 165;
float circularGridRayRadius = 40;// 20; // 40;

// settings for circular sound
float bellAmplitude = 1;
float bellFrequency = 52;
float bellAtk = 0.01;
float bellRelease = 2;
float bellAmpCurrent = bellAmplitude;

// settings for collision sound
float collisionPrecision = 1;
float currentVolume = 0;
float maxVolume = 0.8;
float availableVolume = maxVolume;
float collisionMinFreq = 100;
float collisionMaxFreq = 300;
float collisionAtk = 0.05;
float collisionMinRel = 1.58;
float collisionMaxRel = 4.22;
float collisionBlockAmount = 0.5; // aspect of the collision sound block in the range of 1 to N. the higher is, the bigger the block is.  
float volumeAspect = 1;

// nastavení kinectu
float kinectDepthMin = 578;//413;
float kinectDepthMax = 909;//465; 
float kinectResolution = 7.3;//9;
float kinectScale = 2.19;//2.85;
PVector kinectCropTL = new PVector(0,70);
PVector kinectCropBR = new PVector(640,420);
PVector kinectDeviation = new PVector(15,73);

KinectSignal k;

void setup(){
  
  // size(1920,1080);
  fullScreen();
  // size(800,800);
  
  // initialize global variables
  app = this;
  c = new Canvas();
  b = new SoundBuffer();
  oscP5 = new OscP5(this,5555);
  superCollider = new NetAddress("127.0.0.1",12000);
  k = new KinectSignal();
  router = new SoundRouter();
  
  // the system itself
  s = new KinectSystem();

}

void draw(){

  // regular updates
  currentVolume = 0;
  
  availableVolume = maxVolume;
  
  background(c.bg);
  
  b.update();
  
  if (frameCount % 5 == 0) {
    k.update();
  }
  
  s.update();
  
  b.resolve();
  // b.render();
  
  
  if (debug) {
    c.render();
    
  }
  
  
  fill(255);
  text("FR: " + String.valueOf(frameRate),10,20);
  noFill();
  
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
