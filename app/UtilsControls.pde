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
  
    println(m);
    
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
    
    // the speed of particles
    if (m.addrPattern().equals("/speedAspect")) {
      speedAspect = m.get(0).floatValue();
    }
    
    // the speed of particles
    if (m.addrPattern().equals("/modus")) {
      float type = m.get(0).floatValue();
      if ( type == 1.0 ) {
        s = new CircularSystem();
      }
      if ( type == 2.0 ) {
        s = new SimpleSystem();
      }
      if ( type == 3.0 ) {
        s = new KinectSystem();
      }
    }
    
    
    
    
  }
  
  @Override
  public void listenKeyBoard( System sys ){ 
  
    if (key == 'q') { s = new SimpleSystem(); }
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
    if (m.addrPattern().equals("/gridBoxRadius")) {
      circularGridRayRadius = m.get(0).floatValue();
    }
    
    
    
    // size of the box
    if (m.addrPattern().equals("/collisionBlockTime")) {
      collisionBlockAmount = m.get(0).floatValue();
    }
  
  }
  
  @Override
  public void listenKeyBoard( System sys ){
    
    if (key=='c') {
      if ( s.particles.size()>0 ) {
        for ( int i = 0; i < sys.particles.size(); i++ ) {
          s.particles.get(i).radius++;
        }
      }
    }
    
    if (key=='v') {
      Group moving = new Group("Moving");
      moving.setColor(color(150));
    }
    
    if (key=='a') {
    
    }
    
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
    
    println(m);
    
    // the scale of the kinnect
    if (m.addrPattern().equals("/kinectScale")) {
      k.scale = m.get(0).floatValue();
      k.updateDimensions();
    }
    
    // the resolution of the kinnect
    if (m.addrPattern().equals("/kinectResolution")) {
      k.resolution = int( m.get(0).floatValue() );
      k.updateDimensions();
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
  
  }
  
  @Override
  public void listenKeyBoard( System sys ){ 
  
    if (keyCode == UP) { k.moveDeviceUp(); }
    if (keyCode == DOWN) { k.moveDeviceDown(); }
  
  }
  
  @Override
  public void listenMouse( System sys ){ }
  
  @Override
  public void controlUpdate( System sys ) {
    
      k.render();
    
    
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
