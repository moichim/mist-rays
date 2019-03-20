/*
 * Hvězdná kompozice
 * Výchozí zvuk: Bell
 * Cinkot: Triangl
 * Podnínky: Magické vokály v polovině
 */

class StarsComposition extends Composition {

  StarsComposition(){
    super();
    
    // definuj základní zvuk
    this.baseLineSounds = new String[1];
    this.baseLineSounds[0] = "Bell";
    this.bellFrequency = 40;
    
    // definuj kolizní zvuky
    this.acceptsRandom = true;
    this.randomAmount = 100; 
    this.availableRandomSounds = router.soundNamesByTag("stars");
    
    // definuj podmínky
    // this.conditions.add( new MagicalEnding() );
    // this.conditions.add( new MagicalEnding_slow() );

  }
  
}
