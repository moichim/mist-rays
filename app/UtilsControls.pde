/* 
 * This file sets various classes of control modes.
 * Each system comes along with its controls and those are defined here.
 * The controls are modular so that they can be reused for varius purposes.
 */

// the base class
class ControlGroup {
  String name;
  
  ControlGroup( System sys ){  }
  

  public void listenOSC( System sys, OscMessage m ){
    // override this in a particular control
  }
  
  public void listenMouse( System sys ){
    // override this in a particular control
  }
  
  public void listenKeyBoard( System sys ) {
    // override this in a particular control
  }
  
  public void controlUpdate( System sys ) {
    // override this in a particular control
  }

}

// template for other classes
class ControlTemplate extends ControlGroup {
  ControlTemplate( System s ) {
    super(s);
  }
  
  @Override
  public void listenOSC( System sys, OscMessage m ) { }
  
  @Override
  public void listenKeyBoard( System sys ){ }
  
  @Override
  public void listenMouse( System sys ){ }
}


// Global Controls
class GlobalControls extends ControlGroup {
  GlobalControls( System sys ) {
    super(sys);
  }
  
  @Override
  public void listenOSC( System sys, OscMessage m ) {
    
    // the scale of the canvas
    if (m.addrPattern().equals("/paddingX")) {
      paddingMin.x = m.get(0).floatValue();
      c.calculateDimensions();
    }
    
    // the scale of the canvas
    if (m.addrPattern().equals("/paddingY")) {
      paddingMin.y = m.get(0).floatValue();
      c.calculateDimensions();
    }
    
    // the scale of the canvas
    if (m.addrPattern().equals("/speed")) {
      speedAspect = m.get(0).floatValue();
      // c.calculateDimensions();
    }
    
    // the speed of particles
    if (m.addrPattern().equals("/speedAspect")) {
      speedAspect = m.get(0).floatValue();
    }
    
    // the speed of particles
    if (m.addrPattern().equals("/debug")) {
      if (m.get(0).floatValue() == 1) {
        debug = true;
      } else {
        debug = false;
      }
      
    }
    
    // the speed of particles
    if (m.addrPattern().equals("/mode")) {
      
      float type = m.get(0).floatValue();
      if ( int(type) == 1 ) {
        s = new CircularSystem();
      }
      if ( int(type) == 2 ) {
        s = new SoundSystem();
      }
      if ( int(type) == 3 ) {
        s = new KinectSystem();
      }
    }
  }
  
  @Override
  public void listenKeyBoard( System sys ){ 
  
    if (key == 'q') { s = new SoundSystem(); }
    if (key == 'w') { s = new CircularSystem(); }
    if (key == 'e') { s = new KinectSystem(); }
    if (key == 'd') {
      if ( debug == true ) { debug = false; } else { debug = true; }
    }
    
  }
  
  @Override
  public void listenMouse( System sys ){
    

  }
}



// Controls for circular movement
class CircularControls extends ControlGroup {
  CircularControls( System sys ) {
    super(sys);
  }
  
  @Override
  public void listenOSC( System sys, OscMessage m ) {
  
    // size of the box
    if (m.addrPattern().equals("/gridBoxSize")) {
      circularGridBoxSize = m.get(0).floatValue();
    }
    
    // size of the box
    if (m.addrPattern().equals("/gridRayRadius")) {
      circularGridRayRadius = m.get(0).floatValue();
    }
    
    
    
    // size of the box
    if (m.addrPattern().equals("/collisionBlockTime")) {
      s.soundscape.composition.collisionBlockAmount = m.get(0).floatValue();
    }
  
  }
  
  @Override
  public void listenKeyBoard( System sys ){
    
    
    
  }
  
  @Override
  public void listenMouse( System sys ){
    // when clicked release the clicked particle from the circular movement
    
    // iterate all particles for distance
    for ( Particle p : s.particles ) {
    
      // check only relevant particles
      if (p.getClass().getSimpleName().equals("Prisonner") && p.hasBehavior("Imprisonment")) {
        
        // distance check
        float distance = PVector.dist( p.pos, new PVector(mouseX, mouseY) );
        if ( distance <= p.radius ) {
          
          Prisonner pris = (Prisonner) p;
          pris.release( );
        }
        
      }
    }
      
  }
  
  
}


class KinectControls extends ControlGroup {
  KinectControls( System s ) {
    super(s);
  }
  
  @Override
  public void listenOSC( System sys, OscMessage m ) {
    
    // the scale of the kinnect
    if (m.addrPattern().equals("/kinectScale")) {
      k.scale = m.get(0).floatValue();
      //k.updateDimensions();
    }
    
    // the resolution of the kinnect
    if (m.addrPattern().equals("/kinectResolution")) {
      k.resolution = int( m.get(0).floatValue() );
      //k.updateDimensions();
    }
    
    // the resolution of the kinnect
    if (m.addrPattern().equals("/kinectRayRadius")) {
      k.radius = m.get(0).floatValue();
    }
    
    // the depth field of the kinnect
    if (m.addrPattern().equals("/kinectDepth")) {
      k.minDepth = int ( m.get(0).floatValue() );
      k.maxDepth = int( m.get(1).floatValue() );
    }
    
    // the kinect image position devilation
    if (m.addrPattern().equals("/kinectDeviation")) {
      
      k.deviation.x = m.get(0).floatValue();  
      k.deviation.y = m.get(1).floatValue();
      //k.updateDimensions();
    
    }
    
    // the kinect image crop
    if ( m.addrPattern().equals("/kinectCrop") ) {
      
      float tlX = m.get(0).floatValue();
      float tlY = m.get(1).floatValue();
      float brX = m.get(2).floatValue();
      float brY = m.get(3).floatValue();
      
      // nastavit ořezové body
      k.cropTL = new PVector(tlX,tlY);
      k.cropBR = new PVector(brX,brY);
      // aktualizovat rozměr
      //k.updateDimensions();
    }
  
  }
  
  @Override
  public void listenKeyBoard( System sys ){ 
    
    if (key==CODED) {
      
      if (keyCode == UP) { k.moveDeviceUp(); }
      if (keyCode == DOWN) { k.moveDeviceDown(); }
    
    }
  
    
  
  }
  
  @Override
  public void listenMouse( System sys ){ }
  
  @Override
  public void controlUpdate( System sys ) {
    
     if (debug) {
       k.render();
     }
    
    
    if (frameCount % 4 == 0) {
      k.update();
     
      
      if ( sys.particles.size() > 0 ) {
        for (int i=0;i<sys.particles.size();i++) {
          Particle p = sys.particles.get(i);
          if (p.vel==0) {
            sys.particles.remove(i);
          }
        }
      }
      
      
      
      if (k.matrix.size()>0) {
      for (PVector v : k.matrix) {
        Collider collider = new Collider(v, k.radius);
        sys.particles.add(collider);
      }
    }
      
    }
    
    
    // override this in a particular control
  }
}


// template for other classes
class SoundControls extends ControlGroup {
  SoundControls( System s ) {
    super(s);
  }
  
  @Override
  public void listenOSC( System sys, OscMessage m ) { }
  
  @Override
  public void listenKeyBoard( System sys ){
    if (key == 's') { Sound snd = new Star(new PVector(width/2,0)); snd.play(); }
    if (key == 'x') { Sound snd = new Star(new PVector(width/2,0)); snd.play(); }
    if (key == 'a') { Sound snd = new Acord(new PVector(width/2,0), 0); snd.play(); }
    if (key == 'A') { Sound snd = new Acord(new PVector(width/2,0), 1); snd.play(); }
    if (key == 'y') { Sound snd = new Acord(new PVector(width/2,0), 2); snd.play(); }
    if (key == 'Y') { Sound snd = new Acord(new PVector(width/2,0), 3, 3, 0); snd.play(); }
    if (key == 'g') { Sound snd = new Guitar(new PVector(width/2,0)); snd.play(); }
    if (key == 't') { Sound snd = new Tin(new PVector(width/2,0)); snd.play(); }
    if (key == 'b') { Sound snd = new Bim(new PVector(width/2,0)); snd.play(); }
    if (key == 'B') { Sound snd = new Bam(new PVector(width/2,0)); snd.play(); }
    if (key == 'c') { Sound snd = new Cin(new PVector(width/2,0)); snd.play(); }
    if (key == 'C') { Sound snd = new CinLong(new PVector(width/2,0)); snd.play(); }
    if (key == 'l') { Sound snd = new La(new PVector(width/2,0)); snd.play(); }
    if (key == 'L') { Sound snd = new Lam(new PVector(width/2,0)); snd.play(); }
    if (key == 'p') { Sound snd = new Polycord(new PVector(width/2,0)); snd.play(); }
    if (key == 'u') { Sound snd = new UIcord(new PVector(width/2,0)); snd.play(); }
    if (key == 'U') { Sound snd = new Ucord(new PVector(width/2,0)); snd.play(); }
    if (key == 'k') { Sound snd = new Longcord(new PVector(width/2,0)); snd.play(); }
  }
  
  @Override
  public void listenMouse( System sys ){ }
}
