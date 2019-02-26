class Sound {
  String synth;
  PVector pan;
  PVector position;
  boolean blocksVolume, playing;
  int life, liveTo;
  float currentVolume, initialVolume;
  float amp;
  Sound collidedWith;

  Sound(PVector pos_){
    
    this.life = 0;
    this.liveTo = 0;
    this.playing = true;
    this.blocksVolume = true;
    this.currentVolume = 0;
    this.amp = 0;
    
    // namapování pozice
    this.position = pos_;
    this.pan = new PVector(0,0);
    this.pan.x = map( this.position.x,0,width,-1,1 );
    this.pan.y = map( this.position.y,0,height,-1,1 );
    
    this.collidedWith = null;

  }
  
  // spustí daný zvuk
  void play(){
    // přidat tento zvuk do fronty
    
    if (this.blocksVolume){
      s.soundscape.playing.add(this);
    }
    
    s.soundscape.queue.add(this);
  }
  
  // odeslání zprávy
  void send(){
    // implementovat ručně
  }
  
  void update(){
    
    // zkontroluje svůj život
    if (this.blocksVolume){
      this.life++;
      if (this.life>=this.liveTo){
        this.blocksVolume = false;
      }
    }
    
    // zaktualizuje své aktuální volume
    if (this.blocksVolume){
      this.currentVolume = map(this.life,this.liveTo,0,0,this.initialVolume);
    }
  
  }
  
}

class Sequence {
  
  ArrayList<Sound> sounds;
  int current;

  Sequence(){
  
    this.current = 0;
    this.sounds = new ArrayList<Sound>();
    
  }
  
  // Najde nový zvuk v řadě
  public Sound next_sound(){
  
    Sound snd = null;
    
    return snd;
  
  }
  
  // spustí sekvenci
  void start(){
    this.next_sound().play();
  }
  
}

/* */
class Condition{
  Sound soundToPlay;
  Sequence sequenceToStart;
  
  Condition(){
  
  }
  
  boolean isTrue(){
    return false;
  }
  
  // definuje pravidlo pro podmínku
  void trigger(){
    if (this.soundToPlay != null){
      this.soundToPlay.play();
    } else if ( this.sequenceToStart != null ) {
      this.sequenceToStart.start();
    }
  }
  
  Sound next_sound(){
    Sound snd = null;
    return snd;
  }
  
}

/* Pokročilá logika sklatby je volána soundscapem */
class Composition {
  ArrayList<Condition> conditions;
  
  Sequence sequence;
  String baseLineSound; // linka která pohraje na začátku
  boolean acceptsRandom; // pracuej kompozice s náhodnými zvuky?
  int randomAmount; // poměr mezi náhodným zvukem a lineárním zvukem
  ArrayList<String> availableRandomSounds; // z jakých zvuků je možné náhodně stavit
  
  
  Composition(){
    this.conditions = new ArrayList<Condition>();
    
    this.baseLineSound = "Bell";
    this.acceptsRandom = true;
    this.availableRandomSounds = new ArrayList<String>();
    this.randomAmount = 50;
  }
  
  // zkontroluje splnění podmínek
  void resolveConditions(){
    
    if (this.conditions.size()<0) {
      for (Condition cond : this.conditions){
        if (cond.isTrue()) {
          cond.trigger();
        }
      }
    }
    
  }
  
  // najdi další zvuk
  Sound next_sound(PVector pos_){
    Sound snd = null;
    if (this.acceptsRandom && int(random(100)) <= this.randomAmount ) {
      int rx = int( random(0, this.availableRandomSounds.size()) );
      String className = this.availableRandomSounds.get(rx);
      switch (className) {
        case "Sine":
          snd = new Sine(pos_);
          break;
      }
    } else {
      
    }
    return snd;
  }
  
}

/* Základní zvuková krajina může obsahovat několik variant kompozic */
class SoundScape {
  Composition composition; // aktuálně pracující kompozice
  ArrayList<Sound> playing;
  ArrayList<Sound> queue;
  float availableVolume;
  float currentVolume;

  SoundScape(){
    
    this.playing = new ArrayList<Sound>();
    this.queue = new ArrayList<Sound>();
    this.availableVolume = 1;
    this.currentVolume = 0;
  
  }
  
  // Vrátí následující zvuk příslušné kompozice
  Sound get_next_sound( PVector pos_ ) {
    return this.composition.next_sound(pos_);
  }
  
  // vrátí dostupné volume pro nový zvuk
  float availableVolume(){
    return this.availableVolume;
  }
  
  // Zkontroluje podmínky a kdyžtak je spustí
  void update(){
    
    // resetuj aktuální volume
    this.currentVolume = 0;
    
    // zaktualizuji blokující zvuky a odstraním ty neaktivní
    if (this.playing.size()>0){
      for (int i=0;i<this.playing.size();i++) {
        Sound snd = s.soundscape.playing.get(i);
        
        // zaktualizuj aktuální volume
        this.currentVolume += snd.currentVolume;
        
        // zaktualizuj hrající zvuky a vyřaď odumřelé bloky
        if (snd.blocksVolume) {
          snd.update();  
        } else {
          s.soundscape.playing.remove(i);
        }
      }
    }
    
    // po skončení iterace projet hrající prvkyzaktualizovat dostupné volume
    this.availableVolume = 1 - this.currentVolume;
    
    // kompozice projece své podmínky
    // this.composition.resolveConditions();
    
    
    if (debug) {
      this.render();
    }
  }
  
  void resolveTheQueue(){
    if (this.queue.size()>0){
      for (Sound snd : this.queue){
        
        // pokud je fronta větší než 2, uprav proporcionálně volume
        //if ( this.queue.size() > 1 ){
        snd.amp /= this.queue.size();
        snd.initialVolume = snd.amp;
        snd.currentVolume = snd.amp;
        for (Sound sndOp : this.queue){
          if (sndOp != snd && sndOp.collidedWith != snd) {
            float distance = PVector.dist(snd.position,sndOp.position);
            if (distance <= 2*circularGridRayRadius + collisionPrecision) {
              snd.collidedWith = sndOp;
              snd.send();
              println(frameCount + ": " + this + " nová amplituda " + snd.amp);
            }
          }
        }
        
        
        
        // }
        
        // na každý pád pošli zvuk
        
      }
      
      // na konec odesílačky resetuj frontu
      this.queue = null;
      this.queue = new ArrayList<Sound>();
    }
  }
  
  public void render(){
    float topOffset = 100;
    float gutter = 20;
    float hMax = 100;
    color availableCol = color(0,255,0);
    color blockedCol = color(255,0,0);
    color sndCol = color(0,0,255);
    
    noStroke();
    
    pushMatrix();
    translate(gutter, topOffset);
    
    // nejprve vykreslí dostupné volume
    fill(availableCol);
    float availableH = map(this.availableVolume,0,1,0,hMax);
    rect(0,0,gutter,availableH);
    noFill();
    
    // poté vykreslí dostupné volume
    pushMatrix();
    
    translate(gutter*2,0);
    fill(blockedCol);
    float blockedH = map(this.currentVolume,0,1,0,hMax);
    rect(0,0,gutter,blockedH);
    
    
    translate(gutter,-gutter*2);
    text("Aktuálně hraje: " + String.valueOf(this.playing.size()), 0, 0);
    noFill();
    popMatrix();
    
    println(this.playing.size());
    
    
    // následně vykreslí bšechny hrající zvuky
    if (this.playing.size()>0) {
      for ( int i = 0; i< this.playing.size();i++ ) {
        
        Sound snd = this.playing.get(i);
        
        pushMatrix();
        
        float leftOffset = 3 * gutter + i * gutter;
        println(leftOffset);
        translate(leftOffset,0);
        
        float sndH = map(snd.currentVolume,0,1,5,hMax);
        fill(sndCol);
        rect(0,0,gutter,sndH);
        noFill();
        
        popMatrix();
      }
    }
    
    // úplně nakonec vykreslit volumenózní čáru
    stroke(255);
    line(0,hMax,(2+this.playing.size())*gutter,hMax);
    noStroke();
    popMatrix();
  }
}
