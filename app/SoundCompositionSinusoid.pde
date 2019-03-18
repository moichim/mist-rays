class SineComposition extends Composition {

  SineComposition(){
    super();
    
    // definuj základní zvuk
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // definuj kolizní zvuk
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    this.availableRandomSounds = new String[1];
    this.availableRandomSounds[0] = "Sine";
    
    // parametry zvuku
    this.collisionMinFreq = 100;
    this.collisionMaxFreq = 300;
  }
  
}
