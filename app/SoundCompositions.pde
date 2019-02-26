class SineComposition extends Composition {

  SineComposition(){
    super();
    
    this.baseLineSound = "Sine";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    this.availableRandomSounds.add("Sine");
    
    
    
  }
  
}

class StarsComposition extends Composition {

  StarsComposition(){
    super();
    
    this.baseLineSound = "Sine";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    this.availableRandomSounds.add("Star1");
    this.availableRandomSounds.add("Star2");
    this.availableRandomSounds.add("Star3");
    
    this.conditions.add( new MagicalEnding() );
    
    
  }
  
}
