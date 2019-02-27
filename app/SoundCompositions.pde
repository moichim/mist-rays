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
    
    
  }
  
}
