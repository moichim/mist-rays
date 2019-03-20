class VerbalComposition extends Composition {

  VerbalComposition(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    
    this.availableRandomSounds = router.soundNamesByTag("lahoda");
    
    this.collisionSounds.variants.add( new SoundVariant("Bam",50,0,3,1) );
    this.collisionSounds.variants.add( new SoundVariant("Bim",50,12,15,1) );
    this.collisionSounds.variants.add( new SoundVariant("Guitar",200,0,1,1) );
    
    this.conditions.add( new AcordInHalf() );
    
    //this.conditions.add( new MagicalEnding_slow() );
    
    
  }
  
}


class AcordInHalf extends Condition {

  AcordInHalf(){
    super();
    this.active = true;
  }
  
  @Override
  boolean isTrue(){
    boolean v = false;
    
    if ( s.numFreeParticles >= s.numPrisonnersInitial/4 ){
      if ( this.isProbable() ) {
        v = true;
      }
    }
    return v;
  }
  
  @Override
  void callback(){
    PVector pos = new PVector(0,0);
    Acord main = new Acord(pos,2);
    main.pan.x = random(0.5,1);
    main.setAmplitude(2);// = 1;
    // umísti zvuk po náhodném kraji
    if (flipACoin()) {
      main.pan.x *= -1;
    }
    
    main.play();
    
    Acord sec = new Acord(pos,3);
    sec.pan.x = main.pan.x * -1; //oppositePosition(mag.pan).x;
    sec.setAmplitude(1);
    s.soundscape.playlist.enqueue(sec, 10);
    
    Acord third = new Acord(pos,1);
    third.pan.x = 0;
    third.setAmplitude(1);
    s.soundscape.playlist.enqueue(third, 30);
    
    this.active = false;
  }
}
