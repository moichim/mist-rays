class System {
  ArrayList<Particle> particles;
  ArrayList<ControlGroup> controls;
  boolean plays;
  SoundScape soundscape;
  int numInitialParticles;
  
  System() {
    this.particles = new ArrayList<Particle>();
    this.controls = new ArrayList<ControlGroup>();
    this.controls.add( new GlobalControls( this ) );
    this.plays = true;
    this.soundscape = new SoundScape();
    this.numInitialParticles = 0;
  }
  
  public void update(){
    
    // zaktualizuj soundscape podle stavu z předchozího kola
    this.soundscape.update();
    
    
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
    
    // úplně zcela nakonec vyřeš nastřádané zvuky
    this.soundscape.resolveTheQueue();
    
    
  }
  
  public void customSystemUpdate( ) {
    // this method serves for adding custom actions
  }
  
  /* get a particle by ID */
  public Particle getParticle( int i_ ){
    Particle p = null;
    if ( s.particles.size() > 0 ) {
      for ( int i=0; i < s.particles.size(); i++ ) {
        Particle particle = s.particles.get(i);
        if ( particle.id == i_ ) {
          p = s.particles.get(i);
        }
      }
    }
    
    return p;
  }
  
}
