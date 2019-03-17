class SoundQueryItem {
  Sound sound;
  int time;
  SoundQueryItem( Sound snd_, int time_){
    this.sound = snd_;
    this.time = new Integer(frameCount) + time_;
  }
}

class SoundQuery {
  ArrayList<SoundQueryItem> query;
  int rate;
  SoundQuery(){
    query = new ArrayList<SoundQueryItem>();
    this.rate = 4;
  }
  
  // přidá zvuk do query
  void enqueue(Sound snd, int time){
    this.query.add(new SoundQueryItem(snd, time));
  }
  
  // parsuje query
  void update(){
    // if ( frameCount % this.rate == 0 ) {
      if (this.query.size() > 0) {
        
        for ( int i=0; i < this.query.size(); i++ ) {
          SoundQueryItem sndq = this.query.get(i);
          if ( frameCount >= sndq.time ){
            sndq.sound.play();
            this.query.remove(i);
          }
        }
        
      }
    // }
  }
  
}



// třída pro výběr náhodného zvuku podle různorodých kritérií
class SoundRouter {
  SoundRouterOption[] available;
  
  SoundRouter(){
    
    // zde se musí definovat počet dostupných zvuků
    this.available = new SoundRouterOption[9];
    
    // Nyní následují syntetické zvuky
    this.available[0] = new SoundRouterOption("Sine", new String[] {"sine", "default"} );
    this.available[1] = new SoundRouterOption( "Bell", new String[] {"sine", "default","base" } );
    
    // cinkací samply
    this.available[2] = new SoundRouterOption( "Star1", new String[] {"stars" } );
    this.available[3] = new SoundRouterOption( "Star2", new String[] {"stars" } );
    this.available[4] = new SoundRouterOption( "Star3", new String[] {"stars", "superstars" } );
    
    // vokály
    this.available[5] = new SoundRouterOption( "Magic1", new String[] {"vocals","ending"} );
    this.available[6] = new SoundRouterOption( "Magic2", new String[] {"vocals","ending"} );
    
    this.available[7] = new SoundRouterOption( "Drum", new String[] {"base"} );
    this.available[8] = new SoundRouterOption( "Tin", new String[] {"lahoda"} );
    
  }
  
  Sound byName( String name_, PVector pos_ ){
    Sound output = null;
    
    // pokud není žádný dostupný, nedělej nic
    if (this.available.length==0 ) {
      return null;
    }
    
    // pokud je jen jeden dostupný, vrať robnou jej
    else if (this.available.length == 1) {
      String n = this.available[0].name;
      output = this.createInstanceByName(n,pos_);
    }
    
    // pokud je vícero dostupných, vrať jeden náhodný
    else {
      for (int i = 0; i < this.available.length;i++){
         SoundRouterOption sndOpt = this.available[i];
         if (sndOpt.name.equals(name_)){
           
           output = this.createInstanceByName(sndOpt.name,pos_);
           
         }
      }
    }
    return output;
  }
  
  Sound byTag(String tag_,PVector pos_){
    Sound output = null;
    
    // vyfiltrovat options
    ArrayList<SoundRouterOption> options = this.getOptionsByTag(tag_);
    
    if ( options.size()>0 ) {
      int randomIndex = int(random( options.size()) );
      output = this.byName( options.get(randomIndex).name , pos_);
    }
    
    
    return output;
  }
  
  // vyffiltruje volby pouze podle tagů
  ArrayList<SoundRouterOption> getOptionsByTag(String tag_){
    
    ArrayList<SoundRouterOption> options = new ArrayList<SoundRouterOption>();
    
    for (int i=0;i<this.available.length;i++){
      SoundRouterOption opt = this.available[i];
      if (opt.tags.length>0) {
        for (int y=0; y<opt.tags.length; y++ ) {
          String tag = opt.tags[y];
          if (tag.equals(tag_)){
            options.add(opt);
          }
        }
      }
    }

    return options;
  
  }
  
  String[] soundNamesByTag(String tag_){
    ArrayList<SoundRouterOption> opts = this.getOptionsByTag(tag_);
    String output[] = new String[ opts.size() ];
    
    for (int i=0;i<opts.size();i++ ) {
      output[i] = opts.get(i).name;
    }
    
    return output;
  }
  
  // Vytvoří instanci zvuku podle zadaného jména
  // Zde je ten hlavní router
  Sound createInstanceByName(String name_, PVector pos_) {
    Sound output = null;
    switch (name_){
       case "Sine":
         output = new Sine(pos_);
         break;
       case "Bell":
         output = new Bell(pos_);
         break;
       case "Star1":
         output = new Star1(pos_);
         break;
       case "Star2":
         output = new Star2(pos_);
         break;
       case "Star3":
         output = new Star3(pos_);
         break;
       case "Magic1":
         output = new Magic1(pos_);
         break;
       case "Magic2":
         output = new Magic2(pos_);
         break;
       case "Drum":
         output = new Drum(pos_);
         break;
       case "Tin":
         output = new Tin(pos_);
         break;
    }
    
    return output;
  }

}

// třída pro zvuk do zásobníku zvuků
class SoundRouterOption {
  String name;
  String[] tags;
  
  SoundRouterOption( String name_, String[] tags_ ){
    this.name = name_;
    this.tags = tags_;
  }
  
}


class Sound {
  String synth;
  PVector pan;
  PVector position;
  boolean blocksVolume, blocksTime, playing;
  int life, liveTo;
  float currentVolume, initialVolume;
  float amp;
  Sound collidedWith;
  float ratio;

  Sound(PVector pos_){
    
    this.life = 0;
    this.liveTo = 0;
    this.playing = true;
    this.blocksVolume = true;
    this.blocksTime = false;
    this.amp = 0;
    
    // namapování pozice
    this.position = pos_;
    this.pan = new PVector(0,0);
    this.panFromPos();
    
    this.collidedWith = null;
    
    this.parameters();
    
    this.initialVolume = this.amp;
    this.currentVolume = this.amp;

  }
  
  // metora pro nastavení konkrétního trvání konkrétního zvuku
  void parameters(){
    // implementovat
    // this.liveTo = int( X * this.ratio * frameRate);
    // this.currentVolume = this.amp;
    // this.initialVolume = this.amp;
  }
  
  void panFromPos(){
    this.pan.x = map( this.position.x,0,width,-1,1 );
    this.pan.y = map( this.position.y,0,height,-1,1 );
  }
  
  // spustí daný zvuk
  void play(){
    
    if (this.blocksVolume || this.blocksTime ){
      // přidat tento zvuk k hrajícím
      s.soundscape.playing.add(this);
      // přidat tento zvuk do fronty
      s.soundscape.queue.add(this);
    } else {
      this.send();
    }
    
    
    
  }
  
  // odeslání zprávy
  void send(){
    // implementovat ručně
  }
  
  void update(){
    
    // zkontroluje svůj život
    if (this.blocksVolume || this.blocksTime){
      this.life++;
      if (this.life>=this.liveTo){
        this.blocksVolume = false;
        this.blocksTime = false;
      }
    }
    
    // zaktualizuje své aktuální volume
    if (this.blocksVolume || this.blocksTime){
      this.currentVolume = map(this.life,this.liveTo,0,0,this.initialVolume);
    }
  
  }
  
  // funkce pro systémové nastavení amplitudy
  void setAmplitude( float amp_ ){
    this.amp = amp_;
    this.initialVolume = amp_;
  }
  
  // metoda pro systémové nastavení ratia
  void setRate( float rate_ ){
    this.ratio = rate_;
  }
  
  void setBlockingDuration( float dur_ ){
    float dur = dur_ / this.ratio / this.ratio;
    this.liveTo = int( dur * frameRate);
  }
  
}


/* */
class Condition{
  boolean loop;
  boolean active;
  int count;
  int probability;
  
  Condition(){
    
    this.count = 0;
    this.loop = false;
    this.active = true;
    this.probability = 100;
  
  }
  
  Condition( int probability_){
    
    this.count = 0;
    this.loop = false;
    this.active = true;
    this.probability = probability_;
  
  }
  
  
  // funkce ověřující platnost podmínky. Přepsat v konkrétní podmínce
  boolean isTrue(){
    return false;
  }
  
  boolean isProbable(){
    boolean output = false;
    if ( int(random(100)) <= this.probability ) {
      output = true;
    }
    return output;
  }
  
  // definuje akce provedené při spuštění
  void trigger(){
    // spusť ručně definovanou funkci
    this.callback();
    // inkrementuj počet
    this.count++;
  }
  
  // Funkce vykonaná při triggeru 
  public void callback(){
    // implementovat v konkrétní podmínce
  }
  
  
  
}

/* Pokročilá logika sklatby je volána soundscapem */
class Composition {
  ArrayList<Condition> conditions;
  String[] baseLineSounds; // linka která pohraje na začátku
  boolean acceptsRandom; // pracuej kompozice s náhodnými zvuky?
  int randomAmount; // poměr mezi náhodným zvukem a lineárním zvukem
  String[] availableRandomSounds; // z jakých zvuků je možné náhodně stavit
  
  // přepis glopbálních parametrů
  
  // výchozí zvuk
  float bellAmplitude;
  float bellFrequency;
  float bellAtk;
  float bellRelease;
  float bellAmpCurrent;
  
  // kolizní zvuk
  float collisionPrecision = 1;
  float maxVolume = 0.8;
  float collisionMinFreq = 100;
  float collisionMaxFreq = 300;
  float collisionAtk = 0.05;
  float collisionMinRel = 1.58;
  float collisionMaxRel = 4.22;
  float collisionBlockAmount = 0.5; // aspect of the collision sound block in the range of 1 to N. the higher is, the bigger the block is.  
  float volumeAspect = 1;
  
  
  Composition(){
    this.conditions = new ArrayList<Condition>();
    
    this.baseLineSounds = new String[0];
    this.acceptsRandom = true;
    this.availableRandomSounds = new String[0];
    this.randomAmount = 50;
    
    
    // inicializace globálních parametrů
    
    // nastavení výchozího zvuku
    this.bellAmplitude = bellAmplitude_;
    this.bellFrequency = bellFrequency_;
    this.bellAtk = bellAtk_;
    this.bellRelease = bellRelease_;
    this.bellAmpCurrent = this.bellAmplitude;
    
    // nastavení kolizního zvuku
    this.collisionPrecision = collisionPrecision_;
    this.maxVolume = maxVolume_;
    this.collisionMinFreq = collisionMinFreq_;
    this.collisionMaxFreq = collisionMaxFreq_;
    this.collisionAtk = collisionAtk_;
    this.collisionMinRel = collisionMinRel_;
    this.collisionMaxRel = collisionMaxRel_;
    this.collisionBlockAmount = collisionBlockAmount_; // aspect of the collision sound block in the range of 1 to N. the higher is, the bigger the block is.  
    this.volumeAspect = volumeAspect_;
    
  }
  
  // zkontroluje splnění podmínek, vykoná je a odstraní neaktivní
  void resolveConditions(){
    
    if (this.conditions.size()>0) {
      for (int i=0; i<this.conditions.size();i++){
        Condition cond = this.conditions.get(i);
        if (cond.active){
          if (cond.isTrue()) {
            cond.trigger();
          }
        } else {
          this.conditions.remove(i);
        }
      }
    }
    
  }
  
  // najdi další zvuk
  Sound next_sound(PVector pos_){
    Sound snd = null;
    if (this.acceptsRandom && int(random(100)) <= this.randomAmount ) {
      int rx = int( random(0, this.availableRandomSounds.length) );
      String className = this.availableRandomSounds[rx];
      snd = router.byName(className,pos_);
    } else {
      
    }
    return snd;
  }
  
  // vrať další zvuk
  Sound base_line_sound(){
    
    int rx = int( random(0, this.baseLineSounds.length) );
    String className = this.baseLineSounds[rx];
    println(className);
    Sound snd = router.byName(className,s.soundscape.baseLineCenter);
    println(snd);
    snd.amp = s.soundscape.baseLineAmplitude;
    
    return snd;
  }
  
}

/* Základní zvuková krajina může obsahovat několik variant kompozic */
class SoundScape {
  Composition composition; // aktuálně pracující kompozice
  ArrayList<Sound> playing;
  ArrayList<Sound> queue;
  SoundQuery playlist;
  float availableVolume;
  float currentVolume;
  PVector baseLineCenter, baseLineCenterOpposite; //střed base lajny
  float baseLineAmplitude; // aktuální amplituda base liny
  float bellAmpCurrent;
  

  SoundScape(){
    
    this.playing = new ArrayList<Sound>();
    this.queue = new ArrayList<Sound>();
    this.playlist = new SoundQuery();
    this.availableVolume = 1;
    this.currentVolume = 0;
    
    this.composition = new Composition();
    
    this.bellAmpCurrent = bellAmplitude_;
    this.baseLineCenter = new PVector(0,0);
    this.baseLineCenterOpposite = new PVector(0,0);
    this.baseLineAmplitude = 1;
    
    
  
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
    
    // zkontroluje podmínky
    this.composition.resolveConditions();
    
    // zkontroluje playlist
    if (frameCount % this.playlist.rate == 0) {
      this.playlist.update();
    }
    
    
    // resetuj aktuální volume
    this.currentVolume = 0;
    
    // zaktualizuji blokující zvuky a odstraním ty neaktivní
    if (this.playing.size()>0){
      for (int i=0;i<this.playing.size();i++) {
        Sound snd = s.soundscape.playing.get(i);
        
        // zaktualizuj aktuální volume
        this.currentVolume += snd.currentVolume;
        
        // zaktualizuj hrající zvuky a vyřaď odumřelé bloky
        if (snd.blocksVolume || snd.blocksTime) {
          snd.update();  
        } else {
          s.soundscape.playing.remove(i);
        }
      }
      
    }
    
    // po skončení iterace projet hrající prvkyzaktualizovat dostupné volume
    this.availableVolume = 1 - this.currentVolume;
    
    // zaktualizuj baseline vlastnosti
    if (frameCount % 5 == 0) {
      
      int prisCount = 0;
      PVector prisCenter = new PVector(0,0);
      for (Particle p : s.particles ) {
        if (p.hasBehavior("Imprisonment")) {
          prisCount++;
          prisCenter.x += p.pos.x;
          prisCenter.y += p.pos.y;
        }
      }
      
      this.baseLineAmplitude = map(prisCount,0,s.numInitialParticles,0, s.soundscape.composition.bellAmplitude );
      prisCenter.x /= prisCount;
      prisCenter.y /= prisCount;
      this.baseLineCenter = prisCenter;
      this.baseLineCenterOpposite = this.baseLineCenter.copy().sub( new PVector(width,height) ).mult(-1);
      
    }
    
    
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
        snd.send();
        for (Sound sndOp : this.queue){
          if (sndOp != snd && sndOp.collidedWith != snd) {
            float distance = PVector.dist(snd.position,sndOp.position);
            if (distance <= 2*circularGridRayRadius + s.soundscape.composition.collisionPrecision) {
              snd.collidedWith = sndOp;
              //snd.send();
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
    
    // println(this.playing.size());
    
    
    // následně vykreslí bšechny hrající zvuky
    if (this.playing.size()>0) {
      for ( int i = 0; i< this.playing.size();i++ ) {
        
        Sound snd = this.playing.get(i);
        
        if (snd.blocksTime) { sndCol = color(255,255,0); } else { sndCol = color(0,0,255); }
        
        pushMatrix();
        
        float leftOffset = 3 * gutter + i * gutter;
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
