class CircularSystem extends System {
  int boxCountX, boxCountY; // calculated number of boxes
  float boxSize; // initial sizoé of a box
  float tempo;
  
  
  CircularSystem(){
    super();
    
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
 }
  
}
