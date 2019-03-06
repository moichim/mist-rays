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
    if ( prisCount <= s.numInitialParticles/4 && this.isProbable()){
      v = true;
    }
    return v;
  }
  
  @Override
  void callback(){
    PVector pos = new PVector(0,0);
    Magic1 mag = new Magic1(pos);
    mag.pan.x = random(0.5,1);
    mag.amp = 3;
    // umísti zvuk po náhodném kraji
    if (flipACoin()) {
      mag.pan.x *= -1;
    }
    
    mag.play();
    
    Magic2 mag_feedback = new Magic2(pos);
    mag_feedback.pan.x = mag.pan.x * -1; //oppositePosition(mag.pan).x;
    mag_feedback.amp = 1;
    s.soundscape.playlist.enqueue(mag_feedback, 120);
    
    this.active = false;
  }
}

class MagicalEnding_slow extends Condition {

  MagicalEnding_slow(){
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
    if ( s.particles.size() <= 20 && this.isProbable() ){
      v = true;
    }
    return v;
  }
  
  @Override
  void callback(){
    PVector pos = new PVector(0,0);
    Magic1_slow mag = new Magic1_slow(pos);
    mag.play();
    
    this.active = false;
  }
}
