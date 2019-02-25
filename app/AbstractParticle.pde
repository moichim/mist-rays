/**
  Base particle class contains all necessary fundamental data.
  Each temporary data are stored in behaviors.
  */

class Particle {
  
  // behaviors 
  ArrayList<Behavior> behaviors;
  boolean live;
  int id;
  boolean invokes, free;
  
  // appearance and movement
  PVector pos, dir;
  float vel, radius;
  color col;
  
  Particle(){
    this.behaviors = new ArrayList<Behavior>();
    this.live = true;
    this.id = rayIdCounter;
    this.invokes = false;
    this.free = true;
    rayIdCounter++;
    if ( rayIdCounter >= 999999 ) {
      rayIdCounter = 0;
    }
    
    // initialize the movement 
    this.pos = new PVector(0,0);
    this.dir = new PVector(0,0);
    this.vel = 1;
    
    // initialize appearance values
    this.radius = 0;
    this.col = color(0);
    
  }
  
  public void update(){
    
    if (behaviors.size() > 0) {
      
      for ( int i = 0; i < this.behaviors.size(); i++ ) {
        
        Behavior b = this.behaviors.get(i);
        if (b.active) {
          // Perform the state's updates
          b.technicalUpdate( );
        } else {
          this.behaviors.remove(i);
        }
        
      }
    }
    
    this.customUpdate( );
    
    // PVector step = this.dir.copy().mult( this.vel * speedAspect);
    // this.pos = this.pos.add(step);

    
  } // end update method
  
  // method intended for overrides by implementations
  public void customUpdate(){
  
  }
  
  boolean hasBehavior(String name){
    boolean verdict = false;
    if (this.behaviors.size()>0) {
      for (Behavior b : this.behaviors) {
        if (name.equals(b.getClass().getSimpleName())) {
          verdict = true;
        }
      }
    }
    return verdict;
  }
  
  boolean hasAnyOfBehaviors( String[] b ){
    
    boolean controller = false;
    
    if (this.behaviors.size()>0 && b.length > 0 ) {
      
      for (Behavior behavior: this.behaviors ) {
        
        for ( int i = 0; i < b.length;i++ ) {
          
          if ( b[i].equals( behavior.getClass().getSimpleName() ) ) {
            
            controller = true;
            
          }
          
        }
        
      }
      
    }
    
    return controller;
    
  
  }
  
  // Add a behavior to the particle checking for duplicities
  public void addBehavior(Behavior b){
    if ( !this.hasBehavior( b.name() ) ) {
      this.behaviors.add(b);
      b.removeConflictingBehaviors( this );
    } 
  }
  
  // Remove behavior
  public void removeBehavior(String name ) {
    if (this.behaviors.size()>0) {
      for (int i = 0; i < this.behaviors.size();i++) {
        Behavior b = this.behaviors.get(i);
        if (name.equals(b.name())) {
          this.behaviors.remove(i);
        }
      }
    }
  }
  
  // Remove behavior
  public Behavior getBehavior(String name ) {
    Behavior selected = null;
    if (this.behaviors.size()>0) {
      for (int i = 0; i < this.behaviors.size();i++) {
        Behavior b = this.behaviors.get(i);
        if (name.equals(b.name())) {
          selected = this.behaviors.get(i);
        }
      }
    }
    return selected;
  }
  
}
