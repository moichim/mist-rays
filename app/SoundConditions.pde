class AcordInDecay extends Condition {
  
  float moment;

  AcordInDecay( float moment_ ){
    super();
    this.active = true;
    this.moment = moment_;
  }

  @Override
  boolean isTrue(){
    boolean v = false;

    if ( s.numFreeParticles >= s.numPrisonnersInitial * this.moment ){
      if ( this.isProbable() ) {
        v = true;
      }
    }
    return v;
  }

  @Override
  void callback(){
    PVector pos_ = new PVector(0,0);
    Sound ac = new Polycord(pos_);
    ac.play();
    this.active = false;
  }
}

class PhraseInDecay extends Condition {
  float limit;
  String sample;
  float amp;
  
  PhraseInDecay(float l_, String s_, float a_){
    super();
    this.limit = l_;
    this.sample = s_;
    this.amp = a_;
  }
  
  @Override
  boolean isTrue(){
    boolean v = false;

    if ( s.numFreeParticles >= s.numPrisonnersInitial * this.limit ){
      if ( this.isProbable() ) {
        v = true;
      }
    }
    return v;
  }
  
  @Override
  void callback(){
    PVector pos_ = new PVector(0,0);
    Sound ac = router.createInstanceByName(this.sample, pos_);
    ac.play();
    this.active = false;
  }
  
}

class PhraseInLessThan extends Condition {
  String phrase;
  int condition;
  float amp;
  PhraseInLessThan( int count, String phr_, float amp_){
    super();
    this.condition = count;
    this.phrase = phr_;
    this.amp = amp_;
    this.active = true;
  }
  
  @Override
  boolean isTrue(){
    boolean o = false;
    
    int prisCounter = 0;
    for (Particle part : s.particles) {
      if (part.getClass().getSimpleName().equals("Prisonner")) {
        prisCounter++;
      }
    }
    if (prisCounter < this.condition) {
      o = true;
      this.active = false;
    }
    
    // this.active = false;
    
    return o;
  }
  
  @Override
  void callback(){
    PVector pos_ = new PVector(0,0);
    Sound ac = router.createInstanceByName(this.phrase, pos_);
    ac.play();
    this.active = false;
  }
}

class FinalSound extends Condition {}
