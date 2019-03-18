class Sine extends Sound {
  float freq,atk,rel;
  // Náhodný konstruktor
  Sine(PVector pos_){
    super(pos_);
    
    // parametry zvuku
    this.synth = "/sine";
    this.amp = s.soundscape.availableVolume();
    this.freq = random(s.soundscape.composition.collisionMinFreq,s.soundscape.composition.collisionMaxFreq);
    this.atk = s.soundscape.composition.collisionAtk;
    this.rel = random(s.soundscape.composition.collisionMinRel,s.soundscape.composition.collisionMaxRel);
    
    // parametry bloku
    this.liveTo = int( this.rel * frameRate);
    this.currentVolume = this.amp;
    this.initialVolume = this.amp;
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

class Bell extends Sound {
  float freq,atk,rel;
  // Náhodný konstruktor
  Bell(PVector pos_){
    super(pos_);
    
    // parametry zvuku
    this.synth = "/sine";
    this.amp = s.soundscape.baseLineAmplitude;
    this.freq = s.soundscape.composition.bellFrequency;
    this.atk = s.soundscape.composition.bellAtk;
    this.rel = s.soundscape.composition.bellRelease;
    
    // parametry bloku
    this.liveTo = int( this.rel * frameRate);
    this.currentVolume = this.amp;
    this.initialVolume = this.amp;
    this.blocksVolume = false;
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

class Sample extends Sound {

  int buf;
  
  Sample(PVector pos_){
    super(pos_);
    this.synth = "/playbuf";
    
    this.setAmplitude( s.soundscape.availableVolume() );
    this.setRate(1);
    this.buf = 1;
    // this.liveTo = 1; //toto musí být přepsáno vkonkrétních parametrech a vynásobeno frameRate!!!
    
    // konkrétní samply budoou hookovat své parametry skrze následující metodui
    this.parameters();
  }
  
  
  
  @Override
  void send(){
    OscMessage msg = new OscMessage(this.synth);
    msg.add( this.buf ); // bufnum samplu
    msg.add( this.amp ); // amplituda
    msg.add( this.ratio ); // rychlost přehrávání
    msg.add( this.pan.x ); // pan X
    msg.add( this.pan.y ); // pan Y
    oscP5.send( msg, superCollider );
  }
}

class Star1 extends Sample {
  Star1(PVector pos_){
    super(pos_);
  }
  
  @Override
  void parameters(){
    
    // nastavit bufnum
    this.buf = 1;
    
    // nastavit trvání bloku
    float dur = 2 * random(0.5,1.5);
    this.setBlockingDuration(dur);
    
  }
}

class Drum extends Sample {
  Drum(PVector pos_){
    super(pos_);
  }
  
  @Override
  void parameters(){
    
    // nastavit bufnum
    this.buf = 9;
    this.blocksVolume = false;
    this.amp = 2;
    
    // nastavit trvání bloku
    float dur = 2;
    this.setBlockingDuration(dur);
    
  }
}

class Star2 extends Sample {
  Star2(PVector pos_){
    super(pos_);
  }
  
  @Override
  void parameters(){
    
    // nastavit bufnum
    this.buf = 2;
    
    // nastavit trvání bloku
    float dur = 2 * random(0.5,1.5);
    this.setBlockingDuration(dur);
    
  }
}

class Star3 extends Sample {
  Star3(PVector pos_){
    super(pos_);
  }
  
  @Override
  void parameters(){
    
    // nastavit bufnum
    this.buf = 3;
    
    // nastavit rychost přehrávání
    this.setRate(1);
    
    // nastavit trvání bloku
    float dur = 2 * random(0.5,1.5);
    this.setBlockingDuration(dur);
    
  }
}
