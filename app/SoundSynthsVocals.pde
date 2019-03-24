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
  
  private float randomPan(){
    float o = random(0.7,1);
    if (flipACoin()) {
      o *= -1;
    }
    return o;
  }
  
  public float oppositePan(float contra){
    return contra * -1;
  }
  
  public int select(int[] options){
    println(options);
    int o = 0;
    int index = int(random(0,floor(options.length)));
    int selected = options[index];
    // this.tone = selected;
    // this.buf = selected;
    o = selected;
    return o;
  }
  
  public int select(int[] options, int blocked){
    int o = 0;
    int selected = options[int(random(0,floor(options.length)))];
    if (selected == blocked) {
      o = this.select(options,blocked);
    } else {
      o = selected;
    }
    this.tone = selected;
    this.buf = selected;
    return o;
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

// mono se spustí se 30 procentní pravděpodobností
class Polycord extends Phrase {
  int bufs[];
  Polycord(PVector p_){
    super(p_);
    int[] bf = {112,113,113,114,114,115};
    this.bufs = bf;
    int count = (int) floor(random(0,4));
    int first = this.select(bf);
    println(first);
    this.buf = first;
    this.tone = this.buf;
    float ampl = 0.5;
    this.pan.x = random(-0.9,0.7);
    if ( flipACoin() ){
      this.pan.x = this.pan.x * (-1);
    }
    switch (count) {
      // jedna tretina má jen první disk a amplitudu 1
      case 0:
        this.setAmplitude( 1 );
        break;
      // druha tretina má i druhý krok, tedy ¨ vcelkem varianty
      case 1:
        this.setAmplitude( 0.5 );
        ampl = 0.5;
        int second = this.select(bf,first);
        Acord sec = new Acord(p_,second-111);
        sec.pan.x = 0;
        sec.setAmplitude(0.33);
        s.soundscape.playlist.enqueue(sec,0);
        break;
      // treti varianta má jen nednu variantu a k ní má tichounkou nosnou folii
      case 2:
        this.setAmplitude( 0.7 );
        Acord mono = new Acord(p_,111);
        mono.pan.x = this.pan.x * -1;
        mono.setAmplitude(0.33);
        s.soundscape.playlist.enqueue(mono,0);
        break;
      case 3:
        this.setAmplitude( 0.4 );
        Acord tri1 = new Acord(p_,111);
        tri1.pan.x = this.pan.x * -1;
        tri1.setAmplitude(0.33);
        s.soundscape.playlist.enqueue(tri1,0);
        Acord tri2 = new Acord(p_,111);
        tri2.pan.x = 0;
        tri2.setAmplitude(0.33);
        s.soundscape.playlist.enqueue(tri2,0);
        break;
    }
    
    // this.setAmplitude(ampl);
  }
 
}
