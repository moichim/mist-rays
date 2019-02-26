class Sine extends Sound {
  float freq,atk,rel;
  // Náhodný konstruktor
  Sine(PVector pos_){
    super(pos_);
    
    // parametry zvuku
    this.synth = "/sine";
    this.amp = s.soundscape.availableVolume();
    this.freq = random(collisionMinFreq,collisionMaxFreq);
    this.atk = collisionAtk;
    this.rel = random(collisionMinRel,collisionMaxRel);
    
    // parametry bloku
    this.liveTo = int( this.rel * frameRate);
    this.currentVolume = this.amp;
    this.initialVolume = this.amp;
  }
  
  // parametrický konstruktor
  Sine(PVector pos_, boolean b){
    super(pos_);
  }
  
  @Override
  void send(){
    OscMessage msg = new OscMessage(this.synth);
    msg.add( this.freq ); // frequency
    msg.add( this.atk ); // attack
    msg.add( this.rel ); // release
    msg.add( this.amp ); // amplituda
    msg.add( this.pan.x ); // pan X
    msg.add( this.pan.y ); // pan Y
    
    oscP5.send( msg, superCollider );
  }
  

}
