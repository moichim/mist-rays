class InstrumentalCompositionStarGuitar extends Composition {

  InstrumentalCompositionStarGuitar(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    
    // parametry zvuku
    this.collisionMinFreq = 100;
    this.collisionMaxFreq = 300;
    
    // this.collisionSounds.variants.add( new SoundVariant("Bam",10,5,15,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("Star", 100,0,0,1, trigger_one(0.25,50,0,0,1 )) );
    this.collisionSounds.variants.add( new SoundVariant("Guitar" ,10,0,0,1, trigger_two(0.25,50,0,0,1, 0.7,25,0,0,1 ) ) );
    
    this.conditions.add( new PhraseInDecay( 0.9, "Ucord", 0.75 ) );
    
    this.conditions.add( new PhraseInLessThan( 4, "Acord", 1 ) );
  }
  
}

class InstrumentalCompositionGuitarTinBim extends Composition {

  InstrumentalCompositionGuitarTinBim(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    
    this.availableRandomSounds = router.soundNamesByTag("lahoda");
    
    // this.collisionSounds.variants.add( new SoundVariant("Tin",10,10,15,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("Guitar", 100,0, 0,1, trigger_one(0.25,50,0,0,1 )) );
    this.collisionSounds.variants.add( new SoundVariant("Tin" ,   10, 0,15,1, trigger_two(0.25,100,7,13,1, 0.5,5,3,9, 1 ) ) );
    this.collisionSounds.variants.add( new SoundVariant("Bim" ,   0, 0,15,1, trigger_two(0.6,50,0,5,1,    0.8,30,3,15,1 ) ) );
    
    this.conditions.add( new PhraseInDecay( 0.9, "Longcord", 0.9 ) );
    
    
  }
  
}

class InstrumentalCompositionStarsLamLong extends Composition {

  InstrumentalCompositionStarsLamLong(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    
    this.availableRandomSounds = router.soundNamesByTag("lahoda");
    
    // this.collisionSounds.variants.add( new SoundVariant("Tin",10,10,15,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("Star",   100,0, 0,1, trigger_one(0.25,50,0,0,1 )) );
    this.collisionSounds.variants.add( new SoundVariant("Lam" ,   10, 0,3,1, trigger_two(0.40,7,2,10,1, 0.8,10,5,12, 1 ) ) );
    if (flipACoin()) {
      this.collisionSounds.variants.add( new SoundVariant("Bam" ,   0, 0,0,1, trigger_two(0.5,10,7,13,1,    0.7,5,7,10,1 ) ) );
    } else {
      this.collisionSounds.variants.add( new SoundVariant("Bim" ,   0, 0,0,1, trigger_two(0.5,10,7,13,1,    0.7,5,7,10,1 ) ) );
    }
    
    if (flipACoin()) {
      this.conditions.add( new PhraseInLessThan( 4, "UIcord", 1 ) );
    } else {
      this.conditions.add( new PhraseInLessThan( 4, "Polycord", 1 ) );
    };
    
  }
  
}

class InstrumentalCompositionGuitarLamLong extends Composition {

  InstrumentalCompositionGuitarLamLong(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    
    // this.availableRandomSounds = router.soundNamesByTag("lahoda");
    
    // this.collisionSounds.variants.add( new SoundVariant("Tin",10,10,15,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("Guitar",   100,0, 0,1, trigger_two( 0.3,50, 1,1,1, 0.5, 2,1,1,1) ) );
    this.collisionSounds.variants.add( new SoundVariant("Star",   0,0, 0,1, trigger_two( 0.35,10, 1,1,1, 0.4, 50,1,1,1) ) );
    this.collisionSounds.variants.add( new SoundVariant("Lam" ,     10, 5,10,1, trigger_two( 0.70,20,7,12,1, 0.9,10,5,8,1 ) ) );
    if (flipACoin()) {
      this.collisionSounds.variants.add( new SoundVariant("Tin" ,   0, 0,0,1, trigger_two(0.8,10,7,13,1,    0.9,5,7,10,1 ) ) );
    }
    
    // nakonec přidat podmínky
    if (flipACoin()) {
      this.conditions.add( new PhraseInLessThan( 4, "Ucord", 1 ) );
    } else {
      this.conditions.add( new PhraseInLessThan( 4, "Polycord", 1 ) );
    }
    
  }
  
}
