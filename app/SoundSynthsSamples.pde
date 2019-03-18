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
    this.synth = "/playbuf";
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
  
  int chooseTone(int min_,int max_){
    return int(random(this.baseBuffer + min_,this.baseBuffer + max_));
  }
  
}

class Tin extends LahodaScale {

  Tin(PVector p_){
    super(p_);
    this.defaultParameters(90,15);
    this.tone = this.chooseTone();
    this.buf = this.tone;
    this.setBlockingDuration(1);
  }
}

class Bim extends LahodaScale {

  Bim(PVector p_){
    super(p_);
    this.defaultParameters(15,15);
    this.tone = this.chooseTone();
    this.buf = this.tone;
    this.setBlockingDuration(1);
  }
}

class Bam extends LahodaScale {

  Bam(PVector p_){
    super(p_);
    this.defaultParameters(0,15);
    this.tone = this.chooseTone();
    this.buf = this.tone;
    this.setBlockingDuration(1);
  }
}

class Cin extends LahodaScale {

  Cin(PVector p_){
    super(p_);
    this.defaultParameters(60,15);
    this.tone = this.chooseTone();
    this.buf = this.tone;
    this.setBlockingDuration(1);
  }
}

class Lam extends LahodaScale {

  Lam(PVector p_){
    super(p_);
    this.defaultParameters(30,15);
    this.tone = this.chooseTone();
    this.buf = this.tone;
    this.setBlockingDuration(1);
  }
}

class Acord extends LahodaScale {

  Acord(PVector p_){
    super(p_);
    this.defaultParameters(110,4);
    this.setAmplitude(0.5);
    this.tone = this.chooseTone();
    this.buf = this.tone;
    this.setBlockingDuration(15);
  }
  
  Acord(PVector p_, int track){
    super(p_);
    this.defaultParameters(110,4);
    this.setAmplitude(0.5);
    this.tone = 110+track;//this.chooseTone();
    this.buf = this.tone;
    this.setBlockingDuration(15);
  }
}
