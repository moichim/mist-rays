class System {
  ArrayList<Particle> particles;
  ArrayList<ControlGroup> controls;
  boolean plays;
  
  System() {
    this.particles = new ArrayList<Particle>();
    this.controls = new ArrayList<ControlGroup>();
    this.controls.add( new GlobalControls( this ) );
    this.plays = true;
  }
  
  public void update(){
    
    
    // updates done by controls
    if ( this.controls.size() > 0 ) {
      for (ControlGroup g : this.controls) {
        g.controlUpdate(this);
      }
    }
    
    // update particles
    if ( this.plays && this.particles.size() > 0 ) {
      for ( int i = 0; i < this.particles.size();i++ ) {
        Particle p =  this.particles.get(i);
        p.update();
        if ( !p.live ) {
          this.particles.remove(i);
        }
      }
    }
    
    // execute actions added by the system
    this.customSystemUpdate( );
    
  }
  
  public void customSystemUpdate( ) {
    // this method serves for adding custom actions
  }
  
}

class SimpleSystem extends System {
  SimpleSystem(){
    super();
    for (int i = 0; i < 100; i++) {
      Ray r = new Ray();
      this.particles.add(r);
    }
    //this.controls.add( new KinectControls( this ) );
  }
  
  
}
