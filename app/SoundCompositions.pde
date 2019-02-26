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
