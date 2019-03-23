class InstrumentalComposition extends Composition {

  InstrumentalComposition(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    this.availableRandomSounds = router.soundNamesByTag("guitar");
    
    // parametry zvuku
    this.collisionMinFreq = 100;
    this.collisionMaxFreq = 300;
  }
  
}

class InstrumentalCompositionGuitarTin extends Composition {

  InstrumentalCompositionGuitarTin(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    
    this.availableRandomSounds = router.soundNamesByTag("lahoda");
    
    // this.collisionSounds.variants.add( new SoundVariant("Tin",10,10,15,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("Guitar", 100,0,0,1, trigger_one(0.25,50,0,0,1 )) );
    this.collisionSounds.variants.add( new SoundVariant("Tin" ,10,0,15,1, trigger_two(0.25,100,7,13,1, 0.7,150,3,9,1 ) ) );
    
    // this.conditions.add( new AcordInHalf() );
    
    
  }
  
}
