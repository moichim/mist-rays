class LahodaScale extends Sample {

  int baseBuffer; // číslo busu, ve kterém je uložen tón D2 této sekvence
  int numTones; // počet samplů v této škále. Číslo je zmenšené o 1.
  int minTone, maxTone; // minimální a maximální tón dostupný
  int tone;
  
  /* Bez parametru zahraje náhodný tón z celé škály */
  LahodaScale(PVector p_){
    super(p_);
    this.defaultParameters(90,15);
    this.tone = this.chooseTone();
  }
  
  /* S jedním parametrem zahraje konkrétní tón */
  LahodaScale(PVector p_, int tone_){
    super(p_);
    this.defaultParameters(0,15);
    this.tone = this.minTone + tone_;
  }
  
  /* Se dvěma parametry zahraje zvuk z omezeného rozsahu */
  LahodaScale(PVector p_, int minTone_, int maxTone_){
    super(p_);
    this.defaultParameters(0,15);
    this.minTone = minTone_;
    this.maxTone = maxTone_;
    this.tone = this.chooseTone();
  }
  
  // tato metoda může být přepsána implementujícími třídami
  void defaultParameters(int baseBuffer_, int numTones_){
    this.synth = "/playBuf";
    this.baseBuffer = baseBuffer_;
    this.numTones = numTones_;
    this.minTone = this.baseBuffer;
    this.maxTone = this.baseBuffer+this.numTones;
    // this.setAmplitude( s.soundscape.availableVolume() );
    // this.setRate(1);
  }
  
  int chooseTone(){
    return int(random(this.minTone,this.maxTone));
  }
  
}

class Tin extends LahodaScale {

  Tin(PVector p_){
    super(p_);
    this.defaultParameters(90,15);
    this.tone = this.chooseTone();
  }
}
