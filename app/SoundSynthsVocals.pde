class Phrase extends LahodaScale {
  
  float atkTime, atkAmp;
  
  Phrase(PVector p_, int bufNum, float atkTime_, float atkAmp_ ){
    super(p_);
    this.defaultParameters(bufNum,1);
    this.tone = bufNum;
    this.atkTime = atkTime_;
    this.atkAmp = atkAmp_;
    this.blocksVolume = false;
    this.blocksTime = true;
  }
  
  Phrase(PVector p_, float atkTime_, float atkAmp_ ){
    super(p_);
    this.defaultParameters(112,1);
    this.tone = 112;
    this.atkTime = atkTime_;
    this.atkAmp = atkAmp_;
    this.blocksVolume = false;
    this.blocksTime = true;
  }
  
  Phrase(PVector p_, int bufNum){
    super(p_);
    this.defaultParameters(bufNum,1);
    this.tone = bufNum;
    this.atkTime = 0;
    this.atkAmp = 1;
    this.blocksVolume = false;
    this.blocksTime = true;
  }
  
  Phrase(PVector p_){
    super(p_);
    this.defaultParameters(112,1);
    this.tone = 112;
    this.atkTime = 0;
    this.atkAmp = 1;
    this.blocksVolume = false;
    this.blocksTime = true;
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
    int o = 0;
    int index = int(random(0,options.length));
    int selected = options[index];
    // this.tone = selected;
    // this.buf = selected;
    o = selected;
    return o;
  }
  
  public int select(int[] options, int blocked){
    int o = 0;
    ArrayList<Integer> optionsLimited = new ArrayList<Integer>();
    for ( int i = 0; i < options.length; i++ ) {
      if ( options[i] != blocked ) {
        optionsLimited.add( options[i] );
      }
    }
    return optionsLimited.get( int( floor( random( 0, optionsLimited.size() - 0.1 ) ) ) );
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
    //println(first);
    this.buf = first;
    this.tone = this.buf;
    float ampl = 0.5;
    this.blocksVolume = false;
    this.blocksTime = true;
    this.pan.x = random(-0.9,-0.7);
    this.setBlockingDuration(15);
    if ( flipACoin() ){
      this.pan.x = this.pan.x * (-1);
    }
    switch (count) {
      // jedna tretina má jen první disk a amplitudu 1
      case 0:
        this.setAmplitude( 0.7 );
        break;
      // druha tretina má i druhý krok, tedy ¨ vcelkem varianty
      case 1:
        this.setAmplitude( 0.5 );
        ampl = 0.3;
        int second = this.select(bf,first);
        Acord sec = new Acord(p_,second);
        sec.pan.x = 0;
        sec.setAmplitude(0.33);
        s.soundscape.playlist.enqueue(sec,0);
        break;
      // treti varianta má jen nednu variantu a k ní má tichounkou nosnou folii
      case 2:
        this.setAmplitude( 0.7 );
        Acord mono = new Acord(p_,111);
        mono.pan.x = this.pan.x * -1;
        mono.setAmplitude(0.2);
        s.soundscape.playlist.enqueue(mono,0);
        break;
      case 3:
        this.setAmplitude( 0.4 );
        Acord tri1 = new Acord(p_,111);
        tri1.pan.x = this.pan.x * -1;
        tri1.setAmplitude(0.7);
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

class UIcord extends Phrase {

  UIcord(PVector p_){
    super(p_);
    int[] bf = {117,118};
    // int count = (int) floor(random(0,2));
    int first = this.select(bf);
    this.buf = first;
    this.tone = this.buf;
    this.pan.x = random(-0.9,-0.7);
    if ( flipACoin() ){
      this.pan.x = this.pan.x * (-1);
    }
    this.setBlockingDuration(8);
    
    // volba průběhu
    int count = (int) floor(random(0,5));
    boolean hasSecond = true;
    float secAmplitude = 0;
    int delay = 0;
    
    switch ( count ) {
      case 0:
        hasSecond = false;
        this.setAmplitude(1);
        break;
      case 1:
        this.setAmplitude(0.5);
        secAmplitude = 0.5;
        delay = 45;
        break;
      case 2:
        this.setAmplitude(0.75);
        secAmplitude = 0.3;
        delay = 60;
        break;
      case 3:
        this.setAmplitude(0.60);
        secAmplitude = 0.4;
        delay = 100;
        break;
      case 4:
        this.setAmplitude(0.5);
        secAmplitude = 0.5;
        // delay = 100;
        break;
    }
    
    if (hasSecond) {
      
      // nastavení druhého zvuku
      int second;
      if (first==117) { second = 118; } else { second = 117; }
      Phrase sec = new Phrase(p_, second);
      sec.pan.x = this.pan.x * (-1);
      sec.setAmplitude(secAmplitude);
      sec.setBlockingDuration(3);

      // výstup
      s.soundscape.playlist.enqueue(sec,delay);
    }
    
  }
}


class Ucord extends Phrase {

  Ucord(PVector p_){
    super(p_);
    int[] bf = {115,116};
    // int count = (int) floor(random(0,2));
    int first = 116;//this.select(bf);
    this.buf = first;
    this.tone = this.buf;
    this.pan.x = random(-0.9,-0.7);
    if ( flipACoin() ){
      this.pan.x = this.pan.x * (-1);
    }
    this.setBlockingDuration(12);
    
    // volba průběhu
    int count = (int) floor(random(0,3));
    boolean hasSecond = true;
    float secAmplitude = 0;
    int delay = 0;
    
    switch ( count ) {
      case 0:
        hasSecond = false;
        this.setAmplitude(0.9);
        break;
      case 1:
        this.setAmplitude(0.75);
        secAmplitude = 0.75;
        delay = 20;
        break;
      case 2:
        this.setAmplitude(0.75);
        secAmplitude = 0.3;
        // delay = 20;
        break;
      case 3:
        this.setAmplitude(0.80);
        secAmplitude = 0.5;
        // delay = 20;
        break;
    }
    
    if (hasSecond) {
      
      // nastavení druhého zvuku
      int second;
      if (first==117) { second = 118; } else { second = 117; }
      Phrase sec = new Phrase(p_, 115);
      sec.pan.x = this.pan.x * (-1);
      sec.setAmplitude(secAmplitude);
      sec.setBlockingDuration(3);

      // výstup
      s.soundscape.playlist.enqueue(sec,delay);
    }
    
  }
}

class Longcord extends Phrase {

  Longcord(PVector p_){
    super(p_);
    int[] bf = {115,116};
    // int count = (int) floor(random(0,2));
    int first = this.select(bf);
    this.buf = 115;
    this.tone = this.buf;
    this.pan.x = random(-0.9,-0.7);
    if ( flipACoin() ){
      this.pan.x = this.pan.x * (-1);
    }
    this.setBlockingDuration(15);
    this.setAmplitude(0.5);
    
    
      
    // nastavení druhého zvuku
    Phrase sec = new Phrase(p_, 117);
    sec.pan.x = this.pan.x * (-1);
    sec.setAmplitude(0.5);
    sec.setBlockingDuration(3);

    // výstup
    s.soundscape.playlist.enqueue(sec,0);
    
  }
}
