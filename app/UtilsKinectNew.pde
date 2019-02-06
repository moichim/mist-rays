class KinectSignal {
  
  Kinect kinect; // objekt pro kinect
  float angle; // úhel senzoru
  float minDepth, maxDepth; // Práh hloubky senzoru
  PVector cropTL, cropBR; // vektory s body oříznutí

  PVector center; // střed signálu pro vykreslování
  PVector deviation; // odchylka od středu vykreslování
  float scale; // velikost původního obrazu
  float resolution; // rozlišení matrixu
  float radius; // velikost bodů
  int[] map; // úložiště syrových pixelů z kinectu
  ArrayList<PVector> matrix; // pole bodů pro vykreslení
  
  KinectSignal(){
    
    this.kinect = new Kinect( app ); // inicializace kinektu
    this.kinect.initDepth();
    this.angle = kinect.getTilt();
    
    // nastavení hloubky seznoru
    this.minDepth = 400;//1000.0;
    this.maxDepth = 900;//1300.0;
    
    this.radius = 10;
    
    // nastavení zpracování dat
    this.resolution = 10;
    this.scale = 2;
    this.cropTL = new PVector(0,0);
    this.cropBR = new PVector( this.kinect.width, this.kinect.height );
    this.deviation = new PVector(0,0);
    
    // inicializace matrixu
    this.matrix = new ArrayList<PVector>();
    
    
  
  }
  
  public void update(){
    
    // vyčistit matrix
    this.matrix = null;
    this.matrix = new ArrayList<PVector>();
  
    // aktualizovat data ze senzoru
    this.getSenzorData();
  
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
              float xPos = (float(x) - this.kinect.width/2) * this.scale + width/2 + this.deviation.x;
              float yPos = (float(y) - this.kinect.height/2) * this.scale + height/2 + this.deviation.y;
              
              // přidat bod do matrixu;
              PVector point = new PVector(xPos, yPos);
              //this.matrix.add( point );
              
              Collider collider = new Collider(point, this.radius);
              s.particles.add(collider);
            
            } // konec podmínky hloubky
                 
          } // konec podmínky po ose Y
          
        } // konec smyčky po ose Y
        
      } // konec ořezové podmínky po ose X
    
    } // konec smyčky pro osu X
    
    
  }
  
  // vykreslovací metoda
  public void render(){
    
    
    // vykreslení ořezu
    
    float tLx, tLy, bRx, bRy;
    
    PVector tL, bR;
    tL = new PVector(0,0);
    tL.add( this.cropTL );
    bR = new PVector(0,0);
    bR.add(this.cropBR);
    bR.x -= tL.x;
    bR.y -= tL.y;
    tLx = (tL.x - this.kinect.width/2) * this.scale + width/2 + this.deviation.x;
    tLy = (tL.y - this.kinect.height/2) * this.scale + height/2 + this.deviation.y;
    bRx = (bR.x - this.kinect.width/2) * this.scale + width/2 + this.deviation.x;
    bRy = (bR.y - this.kinect.height/2) * this.scale + height/2 + this.deviation.y;
    
    float r = 30;
    color tmpC = color(0,255,255);
    
    stroke(tmpC);
    noFill();
    rect(tLx,tLy,bRx - tLx,bRy - tLy);
    noStroke();
    
    fill(tmpC);
    ellipse( tLx, tLy, r ,r);
    fill(0);
    text("0",tLx,tLy+r/6);
    fill(tmpC);
    ellipse( bRx, bRy, r, r );
    fill(0);
    text("1",bRx,bRy+r/6);
    noFill();
    
    
    
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
  
  public void moveDeviceUp() {
    this.angle++;
    this.moveDevice();
  }
  
  public void moveDeviceDown() {
    this.angle--;
    this.moveDevice();
  }
  
  public void moveDevice(){
    this.angle = constrain(k.angle, 0, 30);
    this.angle = constrain(this.angle, 0, 30);
    this.kinect.setTilt(this.angle);
  }
  
}
