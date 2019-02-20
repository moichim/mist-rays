class SoundBuffer {
  ArrayList<CollisionSound> playingSounds;
  ArrayList<SCM> concurrentSounds;
  ArrayList<SCM> playing;
  float currentPlayingAmp;
  float available;
  
  SoundBuffer(){
    this.playingSounds = new ArrayList<CollisionSound>();
    this.concurrentSounds = new ArrayList<SCM>();
    this.playing = new ArrayList<SCM>();
    this.currentPlayingAmp = 0;
    this.available = 1;
  }
  
  void update(){
    
    this.concurrentSounds = new ArrayList<SCM>();
    this.currentPlayingAmp = 0;
    this.available = 1;
    
    // inkrementace a smazání hrajících zvuků
    if ( this.playing.size() > 0 ) {
      for (int i=0;i<this.playing.size();i++) {
        SCM m = this.playing.get(i);
        if (m.dur>0) {
          m.dur--;
          m.amp = map( m.dur, 0, m.durOriginal, 0, m.ampOriginal );
          this.currentPlayingAmp += m.amp;
          this.available -= m.amp;
          // println(m.amp);
        } else {
          this.playing.remove(i);
        }
        
        // this.available = constrain(this.available,0,1);
      }
    }
    
    println(1-this.currentPlayingAmp);
  
  }
  
  void resolve() {
  
    if (this.concurrentSounds.size() > 0) {
      for ( SCM m : this.concurrentSounds ){
        m.amp /= float( this.concurrentSounds.size() );
        m.ampOriginal = m.amp;
        m.send();
        println("" + m.amp + " Celkový počet" + this.concurrentSounds.size() );
        this.playing.add(m);
      }
    }
  
  }
  
  void render() {
    
      pushMatrix();
      
      translate(100,100);
     
      float hA = map( this.available, 0,1,1,100 );
      float hP = map( this.currentPlayingAmp, 0,1,1,100 );
      
      fill(255,0,255);
      text(String.format("%.2f",this.available), 0,-20);
      rect(0,0,10,hA);
      noFill();
      
      pushMatrix();
      translate(20,0);
      fill(255,0,0);
      text(String.format("%.2f",this.currentPlayingAmp), 0,-20);
      rect(0,0,10,hP);
      noFill();
      popMatrix();
      
      for ( int i = 0; i < this.playing.size();i++ ) {
        SCM m = this.playing.get(i);
        pushMatrix();
        
        translate(60 + 30*i,0);
        float hM = map( m.amp, 0,1,1,100 );
        fill(0,255,0);
        text(String.format("%.2f",this.currentPlayingAmp), 0,-20);
        rect(0,0,10,hM);
        noFill();
        
        
        popMatrix();
      }
      
      
      popMatrix();
      
  }
  
  
  /* Get currently playing volume */
  float getCurrentVolume(){
    float f = 0;
    
    if ( this.playingSounds.size() > 0 ) {
      for (CollisionSound snd : this.playingSounds ) {
        f += snd.currentAmp;
      }
    }
    
    return f;
  }
  
}
