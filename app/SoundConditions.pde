class MagicalEnding extends Condition {

  MagicalEnding(){
    super();
    this.active = true;
  }
  
  @Override
  boolean isTrue(){
    boolean v = false;
    
    int prisCount = 0;
    
    for ( Particle p : s.particles ){
      
      if ( p.hasBehavior("Imprisonment") ) {
        prisCount++;
      }
    
    }
    if ( prisCount <= s.numInitialParticles/2 ){
      v = true;
    }
    return v;
  }
  
  @Override
  void callback(){
    PVector pos = new PVector(0,0);
    Magic1 mag = new Magic1(pos);
    mag.play();
    
    this.active = false;
  }
}
