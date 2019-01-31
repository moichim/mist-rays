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
    
    // act only if the particle is not blocked by a recent collision
    if (!this.blocked) {
      
      // perform initial setup
      this.isPlaying = true;
      this.blocked = true;
      
      // generate parameters for the sound
      this.amp = maxVolume - constrain(currentVolume, 0, maxVolume);
      this.frequency = random(collisionMinFreq, collisionMaxFreq);
      float release = random( collisionMinRel, collisionMaxRel );
      this.duration = int( release * frameRate );
      this.pan.x = map(p.pos.x, padding.x, c.w - padding.x, -1, 1);
      this.pan.y = map(p.pos.y, padding.y, c.h - padding.y, -1, 1);
    
      // send the amplitode to global volume buffer
      currentVolume += this.amp;
      
      // send the message
      OscMessage msg = new OscMessage("/sine");
      msg.add( this.frequency ); // frequency
      msg.add( 0.01 ); // attack
      msg.add( release ); // release
      msg.add( this.amp ); // amplituda
      msg.add( this.pan.x ); // pan X
      msg.add( this.pan.y ); // pan Y
      
      println(msg);
      
      oscP5.send( msg, superCollider );
    
    }
  }
  
}
