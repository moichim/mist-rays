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
    
    // initialize the controls
    this.tempo = 1;
    
    // create particle's grid
    this.boxCountX = floor( c.w / circularGridBoxSize );
    this.boxCountY = floor( c.h / circularGridBoxSize );
    
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
        
      }
    }
    
  }
 
 @Override
 public void customSystemUpdate(){
   
   b.update();
   
   if ( this.particles.size() <= 0 ) {
     s = new CircularSystem();
   }
   
   // check if this has prisons
   if ( this.hasPrisons ) {
     
     Particle prison = null;
     for ( Particle p : s.particles ){
       if (p.hasBehavior("BellSound")) {
         prison = p;
         // break;
       }
     }
     
     if ( prison != null ) {
 
         BellSound snd = (BellSound) prison.getBehavior("BellSound");
         if (snd != null && prison.hasBehavior("Imprisonment")) {
           Imprisonment imp = (Imprisonment) prison.getBehavior("Imprisonment");
          
           if (prison.pos != null) {
             
             if ( imp.destiny != null ) {
             
               if ( PVector.dist(prison.pos, imp.destiny.predestination.get( imp.destiny.current ).pos ) < 1 && !imp.destiny.bounced ) {
                 
                 // assembly the amplitude of the ring
                 // float amp = bellAmp;
                 float aspect = 1;
                 int prisonnerCount = 0;
                 int imprisonnedCount = 0;
                 for (Particle p: s.particles) {
                   
                   if ( p.getClass().getSimpleName().equals("Prisonner") ) {
                     prisonnerCount++;
                     if (p.hasBehavior("Imprisonment")) {
                       imprisonnedCount++;
                     }
                   }
                 }
                 aspect = float(imprisonnedCount) / float(prisonnerCount);
                 
                 c.bg = color(255);
                 OscMessage msg = new OscMessage("/sine");
                 msg.add( bellFrequency ); // frequency
                 msg.add( 0.01 ); // attack
                 msg.add( bellRelease ); // release
                 msg.add( bellAmp * aspect ); // amplituda
                 msg.add( 0 ); // pan X
                 msg.add( 0 ); // pan Y
                    
                
                 // send the message
                 oscP5.send( msg, superCollider );
               }
             }
             /*
             if ( imp.destiny != null && imp.destiny.hasArrived( prison.pos, 5) ) {
               c.bg = color(255);
               // snd.ring(); 
                println("Cink");
               
               // assemble the message
               OscMessage msg = new OscMessage("/sine");
               msg.add( bellFrequency ); // frequency
               msg.add( 0.01 ); // attack
               msg.add( bellRelease ); // release
               msg.add( bellAmp ); // amplituda
               msg.add( 0 ); // pan X
               msg.add( 0 ); // pan Y
                  
               println(msg);
              
               // send the message
               oscP5.send( msg, superCollider );
             } else {
               //c.bg = color(0);
             }
             */
           
           }
           
         }
     
     } else {
       this.hasPrisons = false;
     }
   }
   
   
 }
  
}
