class Magic1 extends Sample {
  Magic1(PVector pos_){
    super(pos_);
  }
  
  @Override
  void parameters(){
    
    // nastavit bufnum
    this.buf = 4;
    
    // nastavit amplitudu
    this.setAmplitude(0.5);
    
    // nastavit délku
    this.setRate(1);
    
    // nastavit trvání bloku
    this.setBlockingDuration(9);
    
    // další parametry
    this.blocksVolume = false;
    this.blocksTime = true;
    this.position = s.soundscape.baseLineCenterOpposite;
    this.panFromPos();

  }
}

class Magic1_slow extends Sample {
  Magic1_slow(PVector pos_){
    super(pos_);
  }
  
  @Override
  void parameters(){
    
    // nastavit bufnum
    this.buf = 4;
    
    // nastavit volume
    this.setAmplitude(2);
    
    // nastavit ratio
    this.setRate(0.9);
    
    // nastavit délku bloku
    this.setBlockingDuration(9);
    
    // další parametry
    this.blocksVolume = false;
    this.blocksTime = true;
    this.position = s.soundscape.baseLineCenterOpposite;
    this.panFromPos();

  }
}

class Magic2 extends Sample {
  Magic2(PVector pos_){
    super(pos_);
  }
  
  @Override
  void parameters(){
    
    // nastavit bufnum
    this.buf = 5;
    
    // nastavit amplitudu
    this.setAmplitude(0.5);
    
    //  nastavit délku trvání
    this.setBlockingDuration(10);
    
    // parametry zvuku
    this.blocksVolume = false;
    this.blocksTime = true;
    this.position = s.soundscape.baseLineCenterOpposite;
    this.panFromPos();
    
  }
}

class Magic2_slow extends Sample {
  Magic2_slow(PVector pos_){
    super(pos_);
  }
  
  @Override
  void parameters(){
    
    // nastavit bufnum
    this.buf = 5;
    
    // nastavit amplitudu
    this.setAmplitude(1);
    
    // nastavit rychlost přehrávání
    this.setRate(0.25);
    
    // nastavit trvání bloku
    this.setBlockingDuration( 9 );
    
    // další parametry
    this.blocksVolume = false;
    this.blocksTime = true;
    this.position = s.soundscape.baseLineCenterOpposite;
    this.panFromPos();
    
  }
}
