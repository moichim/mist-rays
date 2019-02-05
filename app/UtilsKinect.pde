class DepthControl {
  Kinect kinect;
  PGraphics img; // Buffer pro kreslení
  float angle; // Sklon kinectu
  int[] map; // sem se dají body podle rozlišení. Body jsou zde vždy
  int minDepth; // minimální treshold
  int maxDepth; // maximální treshold
  float depthStep; // pravděpodobně krok při manuálním nastavování
  int resolution; // hustota bodů
  float scale; // velikost
  float scaleStep;
  ArrayList<PVector> matrix; // pole vektorů podle bodů a měřítka - tento element je 
  PVector offset;
  
  float skipTop, skipBottom,skipLeft,skipRight; // kolik řádků bude přeskočeno ve fázi updateMatrix
  PVector cropTopLeft, cropBottomRight; // míra oříznutí zle
  float w,h; // vypočítané rozměry šířky a výšky
  float radius;
  
  PVector deviation;
  
  DepthControl(){
    
    this.radius = 10;
    this.kinect = new Kinect( app );
    this.kinect.initDepth();
    this.angle = kinect.getTilt();
    
    this.updatetTopLeftOffset();
    
    this.minDepth = 755;//320;
    this.maxDepth = 920;//950;
    
    this.resolution = 10;
    this.scale = 1;//2.44;
    this.scaleStep = 0.05;
    this.depthStep = 50;
    
    this.cropTopLeft = new PVector(0,0);
    this.cropBottomRight = new PVector( this.kinect.width,this.kinect.height );
    
    this.skipTop = 11;
    this.skipBottom = 10;
    
    this.img = createGraphics(kinect.width,kinect.height);
    
    /** Aktualizovat hloubku */
    this.updateDepth();
    
    /* Zaktualizuje rozměr podle ořezu */
    this.deviation = new PVector(0,0);
    this.updateDimensions();
    
    /* Aktualizovat matrix bodů */
    this.updateMatrix();
    
  }
  
  public void updateDimensions(){
    
    this.w = this.kinect.width - ( this.cropTopLeft.x ) - ( this.kinect.width - this.cropBottomRight.x );
    this.h = this.kinect.height - ( this.cropTopLeft.y ) - ( this.kinect.height - this.cropBottomRight.y );
    this.skipLeft = this.cropTopLeft.x;
    this.skipTop = this.cropTopLeft.y;
    this.skipRight = this.kinect.width - this.cropBottomRight.x;
    this.skipBottom = this.kinect.height - this.cropBottomRight.y;
    
    this.updatetTopLeftOffset();
    
    float deviationX = map(this.deviation.x,-1,1,-this.kinect.width,this.kinect.width);
    float deviationY = map(this.deviation.y,-1,1,-this.kinect.height,this.kinect.height);
    this.deviation = new PVector(deviationX,deviationY);
  
  }
  
  
  /* 
    Zaktualizovat
    
  */
  public void update() {
    // this.render();
    this.updateDepth();
    this.updateMatrix();
  }
  
  /* Vykreslit */
  public void render(){
    
    pushMatrix();
    
    // translate(this.offset.x,this.offset.y);
    
    // this.drawImage();
    // image(this.img,0,0);
    
    /*
    noFill();
    stroke(0,255,0);
    rect(this.w/2*this.scale,this.h/2*this.scale,this.w/2*this.scale,this.h/2*this.scale);
    noStroke();
    */
    popMatrix();
    
    //this.renderMatrix();
    
    pushMatrix();
    fill(255);
    text("Framerate " + String.valueOf( frameRate ), 10,height-90);
    text("Minimum " + String.valueOf( this.matrix.size() ), 10,height-70);
    text("Minimum " + String.valueOf( this.minDepth ), 10,height-50);
    text("Maximum " + String.valueOf( this.maxDepth ), 10,height-30);
    text("Velikost " + String.valueOf( this.scale ), 10,height-10);
    noFill();
    popMatrix();
    
    // render the control frame
    
    float tLx = this.cropTopLeft.x + this.deviation.x;
    float tLy = this.cropTopLeft.y +  this.deviation.y;
    float bRx = this.cropBottomRight.x + this.deviation.x - tLx;
    float bRy = this.cropBottomRight.y + this.deviation.y -tLy;
    
    
    stroke(255);
    rect(tLx, tLy, bRx, bRy);
    noStroke();
    
    
    // render top left crop
    pushMatrix();
    
    translate(tLx, tLy);
    
    
    
    fill(255);
    ellipse(0,0,30,30);
    text( String.valueOf(this.cropTopLeft),60,0 );
    noFill();
    popMatrix();
    
    // render top left crop
    pushMatrix();
    
    translate(bRx, bRy);
    
    fill(255);
    ellipse(0,0,30,30);
    text( String.valueOf(this.cropBottomRight),40,0 );
    noFill();
    popMatrix();
    
    
  }
  
  public void drawImage(){
    
    
    this.img.beginDraw();
    this.img.image( this.kinect.getDepthImage(),0,0 );
    
    this.img.background(0);
    
    for ( int x = 0; x < this.kinect.width; x+=this.resolution ) {
      for ( int y = 0; y < this.kinect.height; y+=this.resolution ) {
        int offset = x + y*this.kinect.width;
        int d = this.map[ offset ];
 
        if (d >= this.minDepth && d <= this.maxDepth) {
          this.img.pushMatrix();
          this.img.translate(x,y);
          this.img.stroke(0,255,255);
          this.img.point(0,0);
          this.img.popMatrix();
        }
            
      }
    }
    
    this.img.endDraw();
    
  } // konec drawImage()
  
  
  /* Zaktualizovat hloubku */
  public void updateDepth(){
    this.map = this.kinect.getRawDepth();
  } // konec hloubky
  
  
  /* Vytvoří matrix vektorů */
  public void updateMatrix() {
    
    /* 
    
      Co by toto mělo dělat:
      
      1. vynuluje matrix
      2. vypočítá cílovou velikost matrixu tím, že jej vynásobí měřítkem
      3. umístí matrix na střed a vytvoří vektor pro scaledStart a scaledEnd
      4. 
    
    */
    
    
    this.matrix = new ArrayList<PVector>();
    
    PVector scaledSize = new PVector( this.kinect.width*this.scale, this.kinect.height*this.scale );
    PVector scaledStart = new PVector( width/2 - scaledSize.x/2,height/2 - scaledSize.y/2 );
    PVector scaledEnd = new PVector( width/2 + scaledSize.x/2,height/2 + scaledSize.y/2 );
    
  
    for ( int x = 0; x < this.kinect.width; x+=this.resolution ) {
      
      // if ( x >= this.skipLeft && x <= this.kinect.width - this.skipRight ) {
      
      for ( int y = 0; y < this.kinect.height; y+=this.resolution ) {
        
        // if ( y >= this.kinect.height - this.skipTop && y <= this.skipBottom ) {
          
          int offset = x + y*this.kinect.width;
          int d = this.map[ offset ];
   
          if (d >= this.minDepth && d <= this.maxDepth) {
            
            float scaledX = map(x,0,this.kinect.width,scaledStart.x,scaledEnd.x) + this.deviation.x;
            float scaledY = map(y,0,this.kinect.height,scaledStart.y,scaledEnd.y) + this.deviation.y;
            PVector p = new PVector( scaledX, scaledY );
            this.matrix.add(p);
          }
        
       // } // konec podmínky skipLeft & skipBottom
        
      } // konec smyčky Y
      
      // } // konec podmínky skipleft skipRight
      
    } // konec smyčky X
    
    
  
  }
  
  public void renderMatrix(){
    
    pushMatrix();
    //translate(width, height);
    //rotate(PI);
    
    // println(this.matrix.size());
    if (this.matrix.size() > 0){
    
      for (PVector p : this.matrix ){
        pushMatrix();
        
        translate(p.x,p.y);
        ellipseMode(CENTER);
        fill(0,255,0);
        noStroke();
        ellipse(0,0,10,10);
        noFill();
        
        popMatrix();
      }
    
    }
    
    popMatrix();
  
    
  }
  
  /* Vypočítá levý horní offset originálního obrázku */
  public void updatetTopLeftOffset() {
    float top = height/2 - this.h/2;
    float left = width/2 - this.w/2;
    this.offset = new PVector(top,left);
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
