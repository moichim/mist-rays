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
