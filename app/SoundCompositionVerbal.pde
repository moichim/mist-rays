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
    
    this.conditions.add( new AcordInHalf() );
    
    
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
    
    // this.collisionSounds.variants.add( new SoundVariant("Tin",10,10,15,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("Bim", 100,0,5,1, trigger_three(0.2,50,0,5,1, 0.5,70,4,15,1, 0.9,30,10,15, 1 )) );
    this.collisionSounds.variants.add( new SoundVariant("Bam" ,100,12,15,1, trigger_three(0.2,75,7,13,1, 0.5,50,3,9,1, 0.9,60,0,6,1 ) ) );
    
    this.conditions.add( new AcordInHalf() );
    
    
  }
  
}

class VerbalCompositionCinCinStars extends Composition {

  VerbalCompositionCinCinStars(){
    super();
    
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    
    // Vždy je to náhodné
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    
    this.availableRandomSounds = router.soundNamesByTag("lahoda");
    
    // this.collisionSounds.variants.add( new SoundVariant("Tin",10,10,15,1, trigger_none() ) );
    this.collisionSounds.variants.add( new SoundVariant("CinLong", 20,0,5,1, trigger_one(0.9,20,0,5,1 )) );
    this.collisionSounds.variants.add( new SoundVariant("Cin" ,100,12,15,1, trigger_three(0.5,100,7,13,1, 0.7,100,3,9,1, 0.9,60,0,6,1 ) ) );
    
    this.conditions.add( new AcordInHalf() );
    
    
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
    
    if ( s.numFreeParticles >= s.numPrisonnersInitial * 0.9 ){
      if ( this.isProbable() ) {
        v = true;
      }
    }
    return v;
  }
  
  @Override
  void callback(){
    PVector pos = new PVector(0,0);
    Acord main = new Acord(pos,3);
    main.pan.x = random(0.5,1);
    main.setAmplitude(0.5);// = 1;
    // umísti zvuk po náhodném kraji
    if (flipACoin()) {
      main.pan.x *= -1;
    }
    
    main.play();
    
    Acord sec = new Acord(pos,2);
    sec.pan.x = main.pan.x * -1; //oppositePosition(mag.pan).x;
    sec.setAmplitude(0.25);
    s.soundscape.playlist.enqueue(sec,5);
    
    Acord third = new Acord(pos,1);
    third.pan.x = 0;
    third.setAmplitude(0.25);
    s.soundscape.playlist.enqueue(third,10);
    
    Acord fourth = new Acord(pos,0);
    fourth.pan.x = 0;
    fourth.setAmplitude(0.25);
    s.soundscape.playlist.enqueue(fourth,20);
    
    this.active = false;
  }
}
