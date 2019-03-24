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
PApplet app; // link to this app
OscP5 oscP5;
NetAddress superCollider;
SoundRouter router; // rozbočovač zvuků

// visual output for debugging
boolean debug = false;

// Settings of canvas
PVector padding; // stores margin around the canvas
PVector paddingMin = new PVector(332.5,91.5); // initial value that serves for calculation of padding

// global settings
float speedAspect = 0.5;

// Settings of circular movement
float circularGridBoxSize = 113;// 113 JE ŠIROKOÚHLÝ PROJEKTOR
float circularGridRayRadius = 20.36;// 20.36

// settings for circular sound
float bellAmplitude_ = 1;
float bellFrequency_ = 52;
float bellAtk_ = 0.01;
float bellRelease_ = 2;
float bellAmpCurrent_ = bellAmplitude_;

// settings for collision sound
float collisionPrecision_ = 1;
float maxVolume_ = 0.8;
float collisionMinFreq_ = 100;
float collisionMaxFreq_ = 300;
float collisionAtk_ = 0.05;
float collisionMinRel_ = 1.58;
float collisionMaxRel_ = 4.22;
float collisionBlockAmount_ = 0.5; // aspect of the collision sound block in the range of 1 to N. the higher is, the bigger the block is.  
float volumeAspect_ = 1;

// nastavení kinectu
float kinectDepthMin = 237.78;
float kinectDepthMax = 1002.82; 
float kinectResolution = 9;
float kinectScale = 2.53;
PVector kinectCropTL = new PVector(0,70);
PVector kinectCropBR = new PVector(640,420);
PVector kinectDeviation = new PVector(-169.3,230.24);

KinectSignal k;

void setup(){
  
  // size(1920,1080);
  // fullScreen();
  size(800,800);
  
  // initialize global variables
  app = this;
  c = new Canvas();
  oscP5 = new OscP5(this,5555);
  superCollider = new NetAddress("127.0.0.1",12000);
  k = new KinectSignal();
  router = new SoundRouter();
  
  // the system itself
  s = new SoundSystem();

}

void draw(){

  // regular updates
  //currentVolume = 0;
  
  //availableVolume = maxVolume;
  
  background(c.bg);
  
  
  // pravidelný zpožděný update
  if (frameCount % 5 == 0) {
    k.update();
    s.numFreeParticles = 1;
    s.numParticles = 0;
    int numPrisonners = 0;
    if (s.particles.size() > 0) {
      for (Particle p : s.particles) {
        if ( p.hasBehavior("Imprisonment") ) {
          numPrisonners++;
        }
        if( p.getClass().getSimpleName().equals("Prisonner")) {
        s.numParticles++;
        }
      }
    }
    s.numFreeParticles = s.numPrisonnersInitial - numPrisonners;
    // println( s.numFreeParticles );
    fill(255);
    text( String.valueOf(s.numFreeParticles), width - 40, height - 60 );
    noFill();
  }
  
  s.update();

  
  
  if (debug) {
    c.render();
    
  }
  
  if (debug){
    fill(255);
    text("FR: " + String.valueOf(frameRate),10,20);
    noFill();
  }
  
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
