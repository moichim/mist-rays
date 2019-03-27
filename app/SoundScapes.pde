class SineScape extends SoundScape {

  SineScape(){
    super();
    this.composition = cr.getNext();// new VerbalCompositionStarCinLamLong(); //cr.getNext();

  }

}

class CompositionRouter {
  
  ArrayList<String> compositions;
  String lastOne, previous;
  
  CompositionRouter(){
    this.lastOne = null;
    this.previous = null;
    this.compositions = new ArrayList<String>();
    
    this.compositions.add( "VerbalCompositionTinBimStar" );
    this.compositions.add( "VerbalCompositionBimBamCrossfade" );
    this.compositions.add( "VerbalCompositionCinCinStars" );
    this.compositions.add( "VerbalCompositionStarCinLamLong" );
    // Dobré kompozice
    this.compositions.add( "InstrumentalCompositionGuitarTinBim" ); // TinBim jedeš
    this.compositions.add( "InstrumentalCompositionStarGuitar" );
    this.compositions.add( "InstrumentalCompositionStarsLamLong");
    this.compositions.add( "InstrumentalCompositionGuitarLamLong" );
    this.compositions.add( "VerbalCompositionStarLaLamLong" );
    this.compositions.add( "VerbalCompositionDescendingBimBamLamLong" );
    this.compositions.add( "VerbalCompositionAscendingBimBamLamLong" );
    
    
  }
  
  public String selectNext() {
    String next = null;
    
    // pokud je prázdno, zvol náhodnou
    if ( lastOne != null ) {
      next = this.compositions.get( int( floor( random(0, this.compositions.size() - 0.1 ) ) ) );
      this.lastOne = next;
    }
    
    // pokud již není prázdno, zvol náhodnou, která není tato
    else {
      
      // vytvořit limitovanou kopii původního array listu
      ArrayList<String> limitedList = new ArrayList<String>();
      for ( String comp : this.compositions ) {
        if ( !comp.equals( this.lastOne ) && !comp.equals( this.previous ) ) {
          limitedList.add( comp );
        }
      }
      
      // vybrat náhodnou kompozici z dostupných
      next = this.compositions.get(int( floor( random( 0, limitedList.size() - 0.1 ) ) ) );
      
      // přidat kompozici k instancování
      this.previous = this.lastOne;
      this.lastOne = next;
      
    }
    
    return next;
  }
  
  Composition createInstance(String cls){
    Composition cmp = null;
    switch ( cls ) {
      case "VerbalCompositionTinBimStar":
        cmp = new VerbalCompositionTinBimStar();
        break;
      case "VerbalCompositionBimBamCrossfade":
        cmp = new VerbalCompositionBimBamCrossfade();
        break;
      case "VerbalCompositionCinCinStars":
        cmp = new VerbalCompositionCinCinStars();
        break;
      case "VerbalCompositionStarCinLamLong":
        cmp = new VerbalCompositionStarCinLamLong();
        break;
      case "InstrumentalCompositionGuitarTinBim":
        cmp = new InstrumentalCompositionGuitarTinBim();
        break;
      case "InstrumentalCompositionStarGuitar":
        cmp = new InstrumentalCompositionStarGuitar();
        break;
      case "InstrumentalCompositionStarsLamLong":
        cmp = new InstrumentalCompositionStarsLamLong();
      case "InstrumentalCompositionGuitarLamLong":
        cmp = new InstrumentalCompositionGuitarLamLong();
        break;
      case "VerbalCompositionStarLaLamLong":
        cmp = new VerbalCompositionStarLaLamLong();
      case "VerbalCompositionDescendingBimBamLamLong":
        cmp = new VerbalCompositionDescendingBimBamLamLong();
      case "VerbalCompositionAscendingBimBamLamLong":
        cmp = new VerbalCompositionAscendingBimBamLamLong();

    }
    return cmp;
    
  }
  
  Composition getNext(){
    String selected = this.selectNext();
    return this.createInstance( selected );
  }
  
}
