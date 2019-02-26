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

class Sample extends Sound {
  float ratio;
  int buf;
  
  Sample(PVector pos_){
    super(pos_);
    this.synth = "/sample";
    
    this.amp = s.soundscape.availableVolume();
    this.ratio = 1;
    this.buf = 1;
    
    this.currentVolume = this.amp;
    this.initialVolume = this.amp;
    
    // konkrétní samply budoou hookovat své parametry skrze následující metodui
    this.parameters();
  }
  
  // metora pro nastavení konkrétního trvání konkrétního zvuku
  void parameters(){
    // implementovat
    // this.liveTo = int( this.rel * frameRate);
    // this.currentVolume = this.amp;
    // this.initialVolume = this.amp;
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
    
    // nastavit délku
    float dur = 4;
    this.liveTo = int( dur * frameRate);
    
    // nastavit bufnum
    this.buf = 1;
    
  }
}

class Star2 extends Sample {
  Star2(PVector pos_){
    super(pos_);
  }
  
  @Override
  void parameters(){
    
    // nastavit délku
    float dur = 4;
    this.liveTo = int( dur * frameRate);
    
    // nastavit bufnum
    this.buf = 2;
    
  }
}

class Star3 extends Sample {
  Star3(PVector pos_){
    super(pos_);
  }
  
  @Override
  void parameters(){
    
    // nastavit délku
    float dur = 10;
    this.liveTo = int( dur * frameRate);
    
    // nastavit bufnum
    this.buf = 3;
    
  }
}

class Magic1 extends Sample {
  Magic1(PVector pos_){
    super(pos_);
  }
  
  @Override
  void parameters(){
    
    this.amp = 0.5;
    this.blocksVolume = false;
    
    // nastavit délku
    float dur = 10;
    this.liveTo = int( dur * frameRate);
    
    // nastavit bufnum
    this.buf = 4;
    
  }
}
