class Behavior {
  
  boolean active;
  ArrayList<String> conflictingBehaviors;
  int pid;
  Particle parentParticle;
  boolean fullyLoaded;
  
  Behavior(int i_){
    this.active = true;
    this.conflictingBehaviors = new ArrayList<String>();
    this.pid = i_;
    this.fullyLoaded = false;
    //this.parentParticle = this.getParentParticle( this.pid );
  }
 
 
  public Particle getParentParticle( int i_ ) {
    
    Particle p = s.getParticle( i_ );
    
    return p;
  } 
  
  public void updateParentParticle() {
    this.parentParticle = this.getParentParticle( this.pid );
  } 
  
  /* This method performs the actual update */
  public void technicalUpdate(){
    if ( !this.fullyLoaded ) {
      this.parentParticle = s.getParticle( this.pid );
      this.fullyLoaded = true;
      this.initialSetup(); // this method triggers all the initial setups done by the event
    }
    
    this.update();
  }
  
  public void update(){
    // this method is overriden by implementing classes
  }
  
  public void initialSetup(){
    // this method is overriden by implementing classes
    // the purpose of that is implementing classes call parent particles before their constructor is fully finisled
    // therefore any initial setups shall be called on the second frame of the particle's life 
  }
  
  /* Action taken on event removal */
  public void onRemoval( Particle p, boolean take ){
  
  }
  
  
  /* Return the class name of the behavior */
  public String name() {
    return this.getClass().getSimpleName();
  }
  
  /* Optionally check and remove any conflicting beahiors assigned to the particle */
  public void removeConflictingBehaviors( Particle p ){
    if ( this.conflictingBehaviors.size() > 0 ) {
      for ( String conflicting : this.conflictingBehaviors ) {
        if ( p.behaviors.size() > 0 ){
          for (int i=0;i<p.behaviors.size();i++) {
            Behavior b = p.behaviors.get(i);
            if (b.name().equals(conflicting)) {
              p.behaviors.remove(i);
            }
          }
        }
      }
    }
  }
  
}
