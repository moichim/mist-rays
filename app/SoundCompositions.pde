class SineComposition extends Composition {

  SineComposition(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    this.availableRandomSounds = new String[1];
    this.availableRandomSounds[0] = "Sine";
    
    // parametry zvuku
    this.collisionMinFreq = 100;
    this.collisionMaxFreq = 300;
  }
  
}

class StarsComposition extends Composition {

  StarsComposition(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    this.availableRandomSounds = router.soundNamesByTag("stars");
    
    this.conditions.add( new MagicalEnding() );
    
    this.conditions.add( new MagicalEnding_slow() );
    
    
  }
  
}
