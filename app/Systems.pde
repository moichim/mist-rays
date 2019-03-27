


// systém pro lazení kinectu
class KinectSystem extends System {
  
  KinectSystem(){
    super();
    
    this.controls.add( new KinectControls( this ) );
    
  }
  
  @Override
 public void customSystemUpdate(){
   
   k.render();
 }


}

// systém pro lazení zvuku
class SoundSystem extends System {
  SoundSystem(){
    super();
    this.controls.add( new SoundControls( this ) );
  }
}


// Základní systém aplikace
class CircularSystem extends System {
  int boxCountX, boxCountY; // calculated number of boxes
  float boxSize; // initial sizoé of a box
  float tempo;
  boolean hasPrisons; 
  
  
  CircularSystem(){
    super();
    this.hasPrisons = true;
    
    // add the system controls
    this.controls.add( new CircularControls( this ) );
    this.controls.add(new KinectControls( this ) );
    
    // initialize the controls
    this.tempo = 1;
    
    // create particle's grid
    this.boxCountX = floor( c.w / circularGridBoxSize );
    this.boxCountY = floor( c.h / circularGridBoxSize );
    
    
    // inicializace sound systému
    this.soundscape = new SineScape();
    
    boolean left = true;
    
    for ( int x=0; x < this.boxCountX; x++ ) {
      
      for ( int y=0; y < this.boxCountY; y++ ){
        
        /** Vypočítat box1 */
        float xBox = padding.x + x*circularGridBoxSize;
        float yBox = padding.y + y*circularGridBoxSize;
        PVector box = new PVector(xBox,yBox);
        
        /** Nastaví prvotní fázi */
        int initial = 0;
        if (left) {
          initial = 2;
          left = false;
        } else {
          left = true;
        }
        
        /** Inicializovat boxy */
        Prisonner item = new Prisonner(box,initial);
        item.vel = tempo;
        this.particles.add(item);
        
        /* Zvýšit počítadlo prvotního počtu */
        this.numPrisonnersInitial++;
        
      }
    }
    
    this.numParticles = this.numPrisonnersInitial;
    
  }
 
 @Override
 public void customSystemUpdate(){
   
   //p//rintln(this.soundscape.playing.size());
   if ( this.particles.size() <= 0 && this.soundscape.playing.size() <= 0 ) {
     s = new CircularSystem();
   }
   
   // check if this has prisons
   if ( this.hasPrisons ) {
     
     Particle prison = null;
     for ( Particle p : s.particles ){
       if (p.hasBehavior("BellSound")) {
         prison = p;
       }
     }
     
     if ( prison != null ) {
 
         BellSound snd = (BellSound) prison.getBehavior("BellSound");
         if (snd != null && prison.hasBehavior("Imprisonment")) {
           Imprisonment imp = (Imprisonment) prison.getBehavior("Imprisonment");
          
           if (prison.pos != null) {
             
             if ( imp.destiny != null ) {
             
               if ( PVector.dist(prison.pos, imp.destiny.predestination.get( imp.destiny.current ).pos ) < 1 && !imp.destiny.bounced ) {
                 
                 Sound bell = s.soundscape.composition.base_line_sound();
                 bell.play();
               }
             }
           
           }
           
         }
     } else {
       this.hasPrisons = false;
     }
   }
 }
}
