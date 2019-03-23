class Guitar extends LahodaScale {
  Guitar(PVector pos_){
    super(pos_);
    this.defaultParameters(110,1);
    this.baseBuffer = 110;
    this.tone = 110;
    this.buf = 110;//this.baseBuffer;
  }
  
  @Override
  void parameters(){
    
    this.blocksVolume = true;
    // this.amp = 1;
    this.setRate(random(0.5,2));
    
    // nastavit trvání bloku
    float dur = 1;
    this.setBlockingDuration(dur);
    
  }
}


class Star extends LahodaScale {
  
  Star(PVector p_){
    super(p_);
    this.defaultParameters(106,3);
    this.tone = this.chooseTone();
    this.buf = this.tone;
  }
  
  @Override
  void parameters(){
    // nastavit trvání bloku
    float dur = 2 * random(0.5,1.5);
    this.setBlockingDuration(dur);
    this.setRate(dur);
  }
  
}
