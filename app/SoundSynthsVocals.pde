class Phrase extends LahodaScale {
  
  float atkTime, atkAmp;
  
  Phrase(PVector p_, int bufNum, float atkTime_, float atkAmp_ ){
    super(p_);
    this.defaultParameters(bufNum,1);
    this.tone = bufNum;
    this.atkTime = atkTime_;
    this.atkAmp = atkAmp_;
  }
  
  Phrase(PVector p_, float atkTime_, float atkAmp_ ){
    super(p_);
    this.defaultParameters(112,1);
    this.tone = 112;
    this.atkTime = atkTime_;
    this.atkAmp = atkAmp_;
  }
  
  Phrase(PVector p_, int bufNum){
    super(p_);
    this.defaultParameters(bufNum,1);
    this.tone = bufNum;
    this.atkTime = 0;
    this.atkAmp = 1;
  }
  
  Phrase(PVector p_){
    super(p_);
    this.defaultParameters(112,1);
    this.tone = 112;
    this.atkTime = 0;
    this.atkAmp = 1;
  }
  
  @Override
  void send(){
    OscMessage msg = new OscMessage(this.synth);
    msg.add( this.tone ); // bufnum samplu
    msg.add( this.amp ); // amplituda
    msg.add( this.ratio ); // rychlost přehrávání
    msg.add( this.pan.x ); // pan X
    msg.add( this.atkTime ); // čas nástupu
    msg.add( this.atkAmp ); //ampliutuda na nástupu
    //println( this.buf );
    oscP5.send( msg, superCollider );
  }
  
}


class Acord extends Phrase {

  Acord(PVector p_, int bufNum_, float atkTime_, float atkAmp_){
    super(p_, bufNum_, atkTime_, atkAmp_);
    this.defaultParameters(112,4);
    this.setAmplitude(0.5);
    this.tone = 112 + bufNum_;
    this.buf = 112 + bufNum_;
    this.blocksVolume = false;
    this.blocksTime = true;
    this.setBlockingDuration(15);
  }
  
  Acord(PVector p_, float atkTime_, float atkAmp_){
    super(p_, atkTime_, atkAmp_);
    this.defaultParameters(112,4);
    this.setAmplitude(0.5);
    this.tone = 112 + this.chooseTone();
    this.buf = 112 + this.tone;
    this.blocksVolume = false;
    this.blocksTime = true;
    this.setBlockingDuration(15);
  }
  
  Acord(PVector p_, int bufNum_){
    super(p_, bufNum_);
    this.defaultParameters(112,4);
    this.setAmplitude(0.5);
    this.tone = 112 + bufNum_;
    this.buf = 112 + bufNum_;
    this.blocksVolume = false;
    this.blocksTime = true;
    this.setBlockingDuration(15);
  }
  
  Acord(PVector p_){
    super(p_);
    this.defaultParameters(112,4);
    this.setAmplitude(0.5);
    this.tone = 112 + this.chooseTone();
    this.buf = 112 + this.tone;
    this.blocksVolume = false;
    this.blocksTime = true;
    this.setBlockingDuration(15);
  }
  
}
