/*
 * Hvězdná kompozice
 * Výchozí zvuk: Bell
 * Cinkot: Triangl
 * Podnínky: Magické vokály v polovině
 */

class StarsComposition extends Composition {

  StarsComposition(){
    super();
    
    // definuj základní zvuk
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    this.bellFrequency = 40;
    
    // definuj kolizní zvuky
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    this.availableRandomSounds = router.soundNamesByTag("stars");
    
    // definuj podmínky
    this.conditions.add( new MagicalEnding() );
    this.conditions.add( new MagicalEnding_slow() );

  }
  
}


// Magický zpěv se spustí v polovině
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


// magický zpěv se spustí až na konci
class MagicalEnding_slow extends Condition {

  MagicalEnding_slow(){
    super();
    this.active = true;
  }
  
  @Override
  boolean isTrue(){
    boolean v = false;
    
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
