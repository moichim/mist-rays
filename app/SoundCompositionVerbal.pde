class VerbalCompositionTinBimStar extends Composition {

  VerbalCompositionTinBimStar(){
    super();

    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";

    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 

    this.availableRandomSounds = router.soundNamesByTag("lahoda");
    this.collisionSounds.variants.add( new SoundVariant("Tin",10,10,15,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("Bim",100,0,5,1, trigger_two(0.5,50,0,5,1, 0.9,20,4,15,1)) );
    this.collisionSounds.variants.add( new SoundVariant("Star" ,10,0,1,1, trigger_two(0.5,50,0,0,1, 1,100,0,0,1 ) ) );
    this.conditions.add( new AcordInDecay( 0.75 ) );
    
    
  }
  
}


class VerbalCompositionBimBamCrossfade extends Composition {

  VerbalCompositionBimBamCrossfade(){
    super();

    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";

    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 

    this.availableRandomSounds = router.soundNamesByTag("lahoda");
    this.collisionSounds.variants.add( new SoundVariant("Bim", 100,0,5,1, trigger_three(0.2,50,0,5,1, 0.5,70,4,15,1, 0.9,30,10,15, 1 )) );
    this.collisionSounds.variants.add( new SoundVariant("Bam" ,100,12,15,1, trigger_three(0.2,75,7,13,1, 0.5,50,3,9,1, 0.9,60,0,6,1 ) ) );
    this.conditions.add( new AcordInDecay( 0.25 ) );
    
    if (flipACoin()) {
      this.conditions.add( new PhraseInLessThan( 4, "LongCord", 1 ) );
    } else {
      this.conditions.add( new PhraseInLessThan( 4, "Polycord", 1 ) );
    }
    

  }
  
}

class VerbalCompositionCinCinStars extends Composition {

  VerbalCompositionCinCinStars(){
    super();
    
    // zlo sračky jděte do prdele zmrdi
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    
    this.availableRandomSounds = router.soundNamesByTag("lahoda");
    this.collisionSounds.variants.add( new SoundVariant("CinLong", 20,0,5,1, trigger_one(0.9,20,0,5,1 )) );
    this.collisionSounds.variants.add( new SoundVariant("Cin" ,100,12,15,1, trigger_three(0.5,100,7,13,1, 0.7,100,3,9,1, 0.9,60,0,6,1 ) ) );
    
    this.conditions.add( new AcordInDecay(0.5) );
    
    if (flipACoin()) {
      this.conditions.add( new PhraseInLessThan( 4, "UIcord", 1 ) );
    } else {
      this.conditions.add( new PhraseInLessThan( 4, "Polycord", 1 ) );
    }
    
  }
  
}

class VerbalCompositionStarCinLamLong extends Composition {

  VerbalCompositionStarCinLamLong(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    
    // this.availableRandomSounds = router.soundNamesByTag("lahoda");
    
    // this.collisionSounds.variants.add( new SoundVariant("Tin",10,10,15,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("Bim",   100,0, 0,1, trigger_two( 0.3,50, 1,1,1, 0.5, 2,1,1,1) ) );
    this.collisionSounds.variants.add( new SoundVariant("Star",   0,0, 0,1, trigger_two( 0.35,10, 1,1,1, 0.4, 50,1,1,1) ) );
    this.collisionSounds.variants.add( new SoundVariant("Lam" ,     10, 5,10,1, trigger_two( 0.70,20,7,12,1, 0.9,10,5,8,1 ) ) );
    if (flipACoin()) {
      this.collisionSounds.variants.add( new SoundVariant("Tin" ,   0, 0,0,1, trigger_two(0.8,10,7,13,1,    0.9,5,7,10,1 ) ) );
    }
    
    // nakonec přidat podmínky
    // this.conditions.add( new PhraseInDecay( 1, "Longcord", 0.9 ) );
    this.conditions.add( new PhraseInLessThan( 4, "Ucord", 0.9 ) );
    
  }
  
}

class VerbalCompositionStarLaLamLong extends Composition {

  VerbalCompositionStarLaLamLong(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    
    // this.availableRandomSounds = router.soundNamesByTag("lahoda");
    
    // this.collisionSounds.variants.add( new SoundVariant("Tin",10,10,15,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("La",   100,0, 0,1, trigger_two( 0.3,50, 1,1,1, 0.5, 2,1,1,1) ) );
    this.collisionSounds.variants.add( new SoundVariant("Star",   0,0, 0,1, trigger_two( 0.35,10, 1,1,1, 0.4, 50,1,1,1) ) );
    this.collisionSounds.variants.add( new SoundVariant("Guitar",   5,0, 0,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("Lam" ,     10, 5,10,1, trigger_two( 0.70,20,7,12,1, 0.9,10,5,8,1 ) ) );
    if (flipACoin()) {
      this.collisionSounds.variants.add( new SoundVariant("Tin" ,   0, 0,0,1, trigger_two(0.8,10,7,13,1,    0.9,5,7,10,1 ) ) );
    }
    
    // nakonec přidat podmínky
    // this.conditions.add( new PhraseInDecay( 1, "Longcord", 0.9 ) );
    this.conditions.add( new PhraseInLessThan( 4, "Polycord", 0.9 ) );
    
  }
  
}

class VerbalCompositionDescendingBimBamLamLong extends Composition {

  VerbalCompositionDescendingBimBamLamLong(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    
    // this.availableRandomSounds = router.soundNamesByTag("lahoda");
    
    // this.collisionSounds.variants.add( new SoundVariant("Tin",10,10,15,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("Bim",   100,0, 5,1, trigger_two( 0.3,75, 3,10,1, 0.5, 30,7,13,1) ) );
    this.collisionSounds.variants.add( new SoundVariant("Bam",   20, 3, 7,1, trigger_two( 0.35,40, 4,10,1, 0.8, 100,8,14,1) ) );
    this.collisionSounds.variants.add( new SoundVariant("Star",   10,0, 0,1, trigger_none() ) );
    // this.collisionSounds.variants.add( new SoundVariant("Lam" ,     10, 5,10,1, trigger_two( 0.70,20,7,12,1, 0.9,10,5,8,1 ) ) );
    if (flipACoin()) {
      this.collisionSounds.variants.add( new SoundVariant("Tin" ,   0, 0,0,1, trigger_two(0.8,10,7,13,1,    0.9,5,7,10,1 ) ) );
    } 
    
    // nakonec přidat podmínky
    this.conditions.add( new PhraseInDecay( 0.5, "Polycord", 0.9 ) );
    this.conditions.add( new PhraseInLessThan( 4, "Longcord", 0.9 ) );
    
  }
  
}

class VerbalCompositionAscendingBimBamLamLong extends Composition {

  VerbalCompositionAscendingBimBamLamLong(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    
    // this.availableRandomSounds = router.soundNamesByTag("lahoda");
    
    // this.collisionSounds.variants.add( new SoundVariant("Tin",10,10,15,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("Bim",   100,10, 15,1, trigger_two( 0.3,75, 5,13,1, 0.5, 30,0,7,1) ) );
    this.collisionSounds.variants.add( new SoundVariant("Bam",   20, 11, 15,1, trigger_two( 0.35,40, 6,14,1, 0.8, 100,0,6,1) ) );
    this.collisionSounds.variants.add( new SoundVariant("Star",   10,0, 0,1, trigger_none() ) );
    // this.collisionSounds.variants.add( new SoundVariant("Lam" ,     10, 5,10,1, trigger_two( 0.70,20,7,12,1, 0.9,10,5,8,1 ) ) );
    if (flipACoin()) {
      this.collisionSounds.variants.add( new SoundVariant("Tin" ,   0, 0,0,1, trigger_two(0.8,10,7,13,1,    0.9,5,7,10,1 ) ) );
    } 
    
    // nakonec přidat podmínky
    this.conditions.add( new PhraseInDecay( 0.5, "Polycord", 0.9 ) );
    this.conditions.add( new PhraseInLessThan( 4, "Longcord", 0.9 ) );
    
  }
  
}
