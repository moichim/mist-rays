class SoundsBell extends Behavior {
  boolean trigger;
  int life, duration; // počítadlo života
  float amp, currentAmplitude; // kontrola volumenu
  float frequency; // kontrola frekvence
  PVector pan; // kontrola zvuku

  SoundsBell(Particle p){
    super(p);
    this.life = 0;
    this.duration = 0;
    this.frequency = 100;
  }
  
  
}

class CollisionSound extends Behavior {
  boolean isPlaying, blocked;
  int life, duration;
  float amp, currentAmp;
  float frequency;
  PVector pan;  
  
  
  CollisionSound( Particle p ){
    super(p);
    
    this.life = 0;
    this.isPlaying = false;
    this.blocked = false;
    
    this.amp = 0;
    this.currentAmp = 0;
    this.pan = new PVector(0,0);
    this.frequency = 0;
    this.duration = 0;
    
    b.playingSounds.add(this);

}
  
  @Override
  public void update( Particle p ){
    
    if ( this.isPlaying ) {
      
      // increment life
      this.life++;
      float colAspect = map( this.life,0,this.duration,0,255 );
      
      p.col = color(255,colAspect,255);
      
      // update the current amplitude
      this.updateAmplitude();
      
      // migrate the current volume
      currentVolume += this.currentAmp;
      
      
      // finally check the life of an object
      if ( this.life >= this.duration ) {
        this.isPlaying = false;
        this.blocked = false;
        this.life = 0;
        this.currentAmp = 0;
        this.amp = 0;
        this.duration = 0;
        p.col = color(255);
      }
      
    } 
    
    // in the middle of the duration, start accepting new
    if ( this.life >= float( this.duration ) /2 && this.blocked ) {
      this.blocked = false;
    }
    
  }
  
  
  /* Volume update */
  private void updateAmplitude(){
    this.currentAmp = map( float(this.life), 0, float(this.duration),  this.amp, 0 );
  }
  
  /*  Ring */
  public void ring(Particle p){
    if (!this.blocked) {
    this.isPlaying = true;
    this.blocked = true;
    this.amp = maxVolume - constrain(currentVolume, 0, maxVolume);
    currentVolume += this.amp;
    this.frequency = 200;
    this.duration = 50;
    this.pan.x = map(p.pos.x, padding.x, c.w - padding.x, -1, 1);
    this.pan.y = map(p.pos.y, padding.y, c.h - padding.y, -1, 1);
    }
  }
  
}
