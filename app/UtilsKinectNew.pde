class KinectSignal {
  
  Kinect kinect; // objekt pro kinect
  float angle; // úhel senzoru
  float minDepth, maxDepth; // Práh hloubky senzoru
  PVector cropTL, cropBR; // vektory s body oříznutí

  PVector center; // střed signálu pro vykreslování
  PVector deviation; // odchylka od středu vykreslování
  float scale; // velikost původního obrazu
  float resolution; // rozlišení matrixu
  int[] map; // úložiště syrových pixelů z kinectu
  ArrayList<PVector> matrix; // pole bodů pro vykreslení
  
  KinectSignal(){
    
    this.kinect = new Kinect( app ); // inicializace kinektu
    this.kinect.initDepth();
    this.angle = kinect.getTilt();
    
    // nastavení hloubky seznoru
    this.minDepth = 755;
    this.maxDepth = 920;
    
    // nastavení zpracování dat
    this.resolution = 10;
    this.scale = 1;
    this.cropTL = new PVector(0,0);
    this.cropBR = new PVector( this.kinect.width, this.kinect.height );
    
    // inicializace matrixu
    this.matrix = new ArrayList<PVector>();
    
    
  
  }
  
  public void update(){
    
    // vyčistit matrix
    this.matrix = null;
    this.matrix = new ArrayList<PVector>();
    
    
  
    // aktualizovat data ze senzoru
    this.getSenzorData();
    
    // vykreslit
    // this.render();
  
  }
  
  public void getSenzorData() {
    
    // načíst pixely ze senzoru
    this.map = null;
    this.map = this.kinect.getRawDepth();
    
    for (int i=0; i< s.particles.size(); i++) {
      Particle p = s.particles.get(i);
      if (p.hasBehavior("KinectCollider")) {
        s.particles.remove(i);
      }
    }
    
    // smička po ose X
    for ( int x = 0; x < this.kinect.width; x+=this.resolution ) {
      
      // ořez po ose X
      if ( x > this.cropTL.x && x < this.cropBR.x ) {
      
        // smyčka po ose Y
        for ( int y = 0; y < this.kinect.height; y+=this.resolution ) {
        
          // ožez po ose Y
          if ( y > this.cropTL.y && y < this.cropBR.y ) {

            // načtení pixelu ze senzoru
            int offset = x + y*int(this.kinect.width);
            float value = this.map[offset];
            
            // podmínka hloubky
            if ( value > this.minDepth && value < this.maxDepth ) {
            
              // vytvoření souřadnic bodu
              float xPos = float(x);
              float yPos = float(y);
              
              // přidat bod do matrixu;
              PVector point = new PVector(xPos, yPos);
              // this.matrix.add( point );
              
              Collider collider = new Collider(point, 10);
              s.particles.add(collider);
              
            
            } // konec podmínky hloubky
            
          
          } // konec podmínky po ose Y
          
        } // konec smyčky po ose Y
        
      } // konec ořezové podmínky po ose X
    
    } // konec smyčky pro osu X
    
    // limitovat pixely podle rozlišení a ořezu
    
    
  }
  
  // vykreslovací metoda
  public void render(){
    
    // podmínka počtu
    if ( this.matrix.size()>0 ){
      
      for( PVector point : this.matrix ) {
      
        pushMatrix();
        translate(point.x, point.y);
        ellipseMode(CENTER);
        fill(255);
        ellipse(0,0,10,10);
        noFill();
        popMatrix();
      
      } // konec cyklu matrixu
      
    } // konec podmínky počtu
    
  }
  
}
