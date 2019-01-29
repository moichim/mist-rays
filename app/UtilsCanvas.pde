/** Canvas Class */
class Canvas{
  float w, h; // rozměry
  float x, y; // pozice
  float bg;
  
  Canvas(){
    this.calculateDimensions();
    this.bg = color(0);
  }
  
  public void update(){
    // this.sb.events = null;
    // this.sb.events = new ArrayList<SoundEvent>();
  }
  
  // calculates dimensions of the canvas based on current padding
  public void calculateDimensions(){
    this.w = float( floor( ( width - paddingMin.x*2 ) / circularGridBoxSize ) ) * circularGridBoxSize;
    this.h = float( floor( ( height - paddingMin.y*2 ) / circularGridBoxSize ) ) * circularGridBoxSize;
    padding = this.calculatePadding();
    this.x = padding.x;
    this.y = padding.y;
  }
  
  // render for debug porposes only
  public void render(){
    pushMatrix();
    noFill();
    stroke(255,0,0);
    rect(padding.x, padding.y, this.w, this.h);
    popMatrix();
    
    
  }
  
  // calculates the top left padding based on boxGridSize
  public PVector calculatePadding(){
    int boxCountX = floor( this.w / circularGridBoxSize );
    int boxCountY = floor( this.h / circularGridBoxSize );
    this.w = float(boxCountX) * circularGridBoxSize;
    this.h = float(boxCountY) * circularGridBoxSize;
    PVector p = new PVector( (width - this.w) / 2, (height - this.h) / 2 );
    return p;
  }
  
  // calculates current center of the canvas
  public PVector center(){
    return new PVector( padding.x + this.w / 2, padding.y + this.h/2 );
  }

}
