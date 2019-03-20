// třída pro výběr náhodného zvuku podle různorodých kritérií
class SoundRouter {
  SoundRouterOption[] available;
  
  SoundRouter(){
    
    // zde se musí definovat počet dostupných zvuků
    this.available = new SoundRouterOption[11];
    
    // Nyní následují syntetické zvuky
    this.available[0] = new SoundRouterOption("Sine", new String[] {"sine", "default"} );
    this.available[1] = new SoundRouterOption( "Bell", new String[] {"sine", "default","base" } );
    
    // Nástroje
    this.available[2] = new SoundRouterOption( "Drum", new String[] {"base"} );
    this.available[3] = new SoundRouterOption( "Guitar", new String[] {"guitar"} );
    this.available[4] = new SoundRouterOption( "Star", new String[] {"stars"} );
    
    // Lahodovic zvuky
    this.available[5] = new SoundRouterOption( "Tin", new String[] {"lahoda"} );
    this.available[6] = new SoundRouterOption( "Bim", new String[] {"lahoda"} );
    this.available[7] = new SoundRouterOption( "Bam", new String[] {"lahoda"} );
    this.available[8] = new SoundRouterOption( "Cin", new String[] {"lahoda"} );
    this.available[9] = new SoundRouterOption( "Lam", new String[] {"lahoda"} );
    
    // Akord
    this.available[10] = new SoundRouterOption("Acord", new String[] {"akord"});
    
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
  
  // najde 1 zvuk podle tagu
  String byTagName(String tag_){
    String output = null;
    
    // vyfiltrovat options
    ArrayList<SoundRouterOption> options = this.getOptionsByTag(tag_);
    
    if ( options.size()>0 ) {
      int randomIndex = int(random( options.size()) );
      // output = this.byName( options.get(randomIndex).name , pos_);
      output = options.get(randomIndex).name;
    }
    
    
    return output;
  }
  
  // vyffiltruje volby pouze podle tagů
  ArrayList<SoundRouterOption> getOptionsByTag(String tag_){
    
    println(tag_);
    
    ArrayList<SoundRouterOption> options = new ArrayList<SoundRouterOption>();
    
    for (int i=0;i<this.available.length;i++){
      SoundRouterOption opt = this.available[i];
      println(opt);
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
       case "Drum":
         output = new Drum(pos_);
         break;
       case "Tin":
         output = new Tin(pos_);
         break;
       case "Bim":
         output = new Bim(pos_);
         break;
       case "Bam":
         output = new Bam(pos_);
         break;
       case "Cin":
         output = new Cin(pos_);
         break;
       case "Lam":
         output = new Lam(pos_);
         break;
       case "Guitar":
         output = new Guitar(pos_);
         break;
       case "Star":
         output = new Star(pos_);
         break;
       case "Acord":
         output = new Acord(pos_);
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

class SoundVariantContainer {
  ArrayList<SoundVariant> variants;
  
  SoundVariantContainer(){
    this.variants = new ArrayList<SoundVariant>();
  }
  
  // vyber jednu variantu
  SoundVariant chooseVariant(){
    SoundVariant sndV = null;
    if (this.variants.size()>1) {
      
      // nejprve spočítat celkovou váhu
      int weightTotal = 0;
      for ( SoundVariant sv : this.variants ) {
        weightTotal += sv.weight;
      }
      
      // poté zvolit správnou variantu podle náhodného hodu
      int chosen = (int)random(weightTotal);
      boolean match = false; // kontroluje, zda se má ještě pokračovat anebo ne
      int containerMin = 0;
      int containerMax = 0;
      for ( SoundVariant sv : this.variants ) {
        containerMin = containerMax;
        containerMax += sv.weight;
        
        if ( !match && chosen >= containerMin && chosen <= containerMax ) {
          match = true;
          sndV = sv;
        }
        
      }
      
    }
    return sndV;
  }
  
  Sound produceSound(PVector pos_){
    Sound snd = this.chooseVariant().produceSound(pos_);
    return snd;
  }
  
}

// Tato věc definuje hodnoty varianty v čase, resp. v počtu dosud uvězněných vězňů
class SoundVariantDynamics{
  float moment; // poměr uvolněných bodů
  int weight; // Momentální váha
  int min;
  int max;
  int reverbVariant;
}

// Tato věc je udána přímo u kompozice.
// Zde je definována statistika i dynamika zvuků.
class SoundVariant {
  String name;
  String[] tags, tagsAnd,tagsNot;
  int weight;
  int min,max;
  int reverbVariant; // varianta reverbu
  
  // Konstruktor používající komplexní query
  SoundVariant(String[] t_, String[] ta_, String[] tn_, int w_, int min_, int max_, int r_){
    this.name = null;
    this.tags = t_;
    this.tagsAnd = ta_;
    this.tagsNot = tn_;
    this.defaultSettings(w_, min_, max_, r_);
  }
  
  // Konstruktor používající jendo jediné jméno
  SoundVariant(String n_, int w_, int min_, int max_, int r_){
    this.name = n_;
    this.defaultSettings(w_, min_, max_, r_);
  }
  
  private void defaultSettings(int w_,int min_, int max_, int r_){
    this.weight = w_;
    this.min = min_;
    this.max = max_;
    this.reverbVariant = r_;
  }
  
  // Vybere jeden zvuk z možných zvuků a vrátí jeho jméno
  String chooseSoundName(){
    println("Vybrano");
    String output = null;
    // pokud je vyplněné jméno, vezmi jej
    if ( this.name != null ) {
      output = this.name;
    }
    // Pokud není vyplněné jméno, proveď query
    else {
      if (this.tags.length > 0) {
        String t_ = this.tags[ (int)random(this.tags.length-1) ];
        output = router.byTagName(t_);
      }
    }
    return output;
  }
  
  Sound produceSound(PVector pos_){
    println("Dotakl jsem až sem");
    Sound snd = null;
    
    String chosen = this.chooseSoundName();
    println("Vybrano "+chosen);
    if ( chosen != null ) {
      snd = router.createInstanceByName( chosen, pos_ );
      // pokud se jedná o podtřídu LahodaSample, uprav její tón podle limitů
      if ( snd.getClass().getSuperclass().getSimpleName().equals("LahodaScale") ) {
        //( (LahodaScale) snd).chooseTone( this.min, this.max );
      }
      
      // pokud se jedná o něco jiného, udělej něco jiného
    }
    
    return snd;
  }
}
