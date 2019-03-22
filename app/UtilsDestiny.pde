class Point {
  PVector pos; // pozice
  boolean pass; // indikuje, zda má bod sloužit k cirkulaci, anebo k vypuštění na volnou dráhu
  
  Point(PVector p, boolean r) {
    this.pos = p;
    this.pass = r;
  }
  
  public void release(){
    this.pass = true;
  }
  
}


/**
 * Třída ovládající osud jednoho Prstenu
 */
class Destiny {
  ArrayList<Point> predestination;
  int current;
  boolean bounced;
  
  /**
   * Parametr konstruktoru je integer v rozsahu 0-3.
   * 0 = top
   * 1 = left
   * 2 = right
   * 3 = bottom
   */
  Destiny(PVector min, PVector max, int pos) {
    
    this.predestination = new ArrayList<Point>();
    
    /** Vytvoření prvního bodu */
    PVector pos1 = new PVector( min.x + circularGridBoxSize / 2, min.y + circularGridRayRadius/2);
    Point item1 = new Point(pos1,false);
    
    /** Vytvoření druhého bodu */
    PVector pos2 = new PVector( min.x + circularGridRayRadius/2, min.y + circularGridBoxSize/2 );
    Point item2 = new Point(pos2,false);
    
    /** Vytvoření třetího bodu */
    PVector pos3 = new PVector( min.x + circularGridBoxSize / 2, max.y - circularGridRayRadius/2 );
    Point item3 = new Point(pos3,false);
    
    /** Vytvoření třetího bodu */
    PVector pos4 = new PVector( max.x - circularGridRayRadius/2, min.y + circularGridBoxSize/2 );
    Point item4 = new Point(pos4,false);
    
    this.predestination.add(item1);
    this.predestination.add(item2);
    this.predestination.add(item3);
    this.predestination.add(item4);
    
    this.current = pos;
    this.bounced = false;
    
  }
  
  /**
   * Vráti index příštího bodu
   */
  public int getNextIndex(){
    if ( this.current + 1 >= this.predestination.size() ) {
      return 0;
    } else {
      return this.current + 1;
    }
  }
  
  /** Vrátí příští souřadnice */
  public PVector getPointCoordinates(int i) {
    Point item = this.predestination.get(i);
    return new PVector(item.pos.x,item.pos.y);
  }
  
  /** Vrátí příští souřadnice */
  public PVector nextCoordinates() {
    int next = this.getNextIndex();
    Point item = this.predestination.get(next);
    return new PVector(item.pos.x,item.pos.y);
  }
  
  /** Vrátí současnou souřadnici */
  public PVector currentTargetCoordinates(){
    Point item = this.predestination.get( this.current );
    return new PVector(item.pos.x,item.pos.y);
  }
  
  /** Udělá ten krok */
  public void nextTarget(){
    boolean pass = this.predestination.get( this.current ).pass;
    if ( !pass ){
      this.current = this.getNextIndex();
    }
  }
  
  /** Zkontroluje, jestli je bod již v cíli, anebo ne */
  public boolean hasArrived( PVector itemPosition, float tolerance ) {
    
    float dist = itemPosition.dist( this.currentTargetCoordinates() );
    if ( dist <= tolerance && !this.bounced ) {
      this.bounced = true;
      return true;
    } else {
      this.bounced = false;
      return false;
      
    }
  }
  
  public boolean isPassing(){
    if ( this.predestination.get( this.current ).pass ) {
      return true;
    } else {
      return false;
    }
  }
  
  /** Vypočítá směrnici pro pohyb */
  public PVector dir(PVector p){
    PVector target = this.currentTargetCoordinates();
    PVector newDir = PVector.sub(target,p);
    return newDir.normalize();
  }
  
  /** kontrolní render */
  void render() {
    for (int i = 0; i<this.predestination.size();i++) {
      Point item = this.predestination.get(i);
      pushMatrix();
      translate(item.pos.x,item.pos.y);
      ellipseMode(CENTER);
      //fill(50);
      if ( item.pass == true ) {
        fill(255);
      } else {
        fill(50);
      }
      ellipse(0,0,10,10);
      popMatrix();
    }
  }
  
  /** Osvobodí určitý bod */
  public void release(int i) {
    if (i >= 0 && i < this.predestination.size()) {
      this.predestination.get(i).release();
    } 
  }
  
  /** Zjistí, zda je Ring v pozici */
  public boolean isOnPoint(PVector pos,float tolerance){
    boolean o = false;
    float distance = PVector.dist(pos, this.currentTargetCoordinates());
    if ( distance <= tolerance) {
      o = true;
    }
    return o;
  }
  
}
