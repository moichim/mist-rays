class MagicalEnding extends Condition {

  MagicalEnding(){
    super();
    this.active = true;
  }
  
  @Override
  boolean isTrue(){
    boolean v = false;
    
    int prisCount = 0;
    int freeCount = 0;
    
    for ( Particle p : s.particles ){
      
      if ( p.free && p.getClass().getSimpleName().equals("Prisonner") ) {
        freeCount++;
      }
      
      if ( p.getClass().getSimpleName().equals("Prisonner") ) {
        prisCount++;
      }
    
    }
    
    if ( int( freeCount ) > 3 ){
      v = true;
    }
    println("FreeCount "+ freeCount);
    println("PrisonerCount "+ prisCount);
    return v;
  }
  
  @Override
  void callback(){
    PVector pos = new PVector(0,0);
    Magic1 mag = new Magic1(pos);
    mag.play();
    
    this.active = false;
    
    println("//////");
  }
}
