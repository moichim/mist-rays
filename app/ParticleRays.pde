
/* Default Ray*/
class Ray extends Particle {
  
  Ray(){
    
    super();
    
    // initialize the movement 
    this.pos = new PVector(random(width),random(height));
    this.dir = new PVector(random(-1,1),random(-1,1)).normalize();
    this.vel = random(0.5,2);
    
    // pomucka
    
    // default appearance
    this.radius = random(10,50);
    this.col = color(255);
    
    
    // add behaviors
    this.addBehavior( new RecieveCollisions( this ) );
    this.addBehavior( new InvokeCollisions( this ) );
    this.addBehavior( new FadeWhenOutOfCanvas( this ) );
    this.addBehavior( new Move( this ) );
    this.addBehavior( new DisplayDefault( this ) );
    this.addBehavior( new CollisionSound( this ) );
   
  }
  
}

/* Rocket launched upon explosion */
class Rocket extends Particle {
  Rocket(PVector startPos, float angle){
    
    super();
    this.pos = new PVector(startPos.x,startPos.y);
    this.dir = PVector.fromAngle(angle);
    this.vel = 1;
    
    this.radius = 15;
    this.col = color(255);
    
    this.addBehavior( new FadeOut( this,  (float) 0.5 ) );
    this.addBehavior( new AdjustVelocity( this, 3, (float) 0.2 ) );
    this.addBehavior( new FadeWhenOutOfCanvas( this ) );
    this.addBehavior( new RecieveCollisions( this ) );
    this.addBehavior( new Move( this ) );
    this.addBehavior( new DisplayDefault( this ) );
    
  }
  
}

/* Initially imprisoned particle */
class Prisonner extends Particle {
  PVector box;
  boolean grownUp;
  
  /*
   Initial positions: 
   */
  Prisonner(PVector box_, int position ){
    super();
    
    this.vel = 1;
    this.col = color(255);
    this.radius = 1; // circularGridRayRadius;
    this.box = box_;
    
    this.grownUp = false;
    
    // behaviors
    this.addBehavior( new AdjustRadius( this, circularGridRayRadius, int(1) ) );
    this.addBehavior( new Imprisonment( this, this.box, position ) );
    this.addBehavior( new RecieveCollisions( this ) );
    this.addBehavior( new CollisionSound( this ) );
    this.addBehavior( new DisplayDefault( this ) );
    
  }
  
  // a method to release this prisonner from imprisonment only calls the setFre() method
  public void release(){
    
    if ( this.hasBehavior("Imprisonment") ) {
      Behavior b = this.getBehavior("Imprisonment");
      Imprisonment i = (Imprisonment) b;
      i.setFree( this );
    }
    
  }
  
  @Override
  public void customUpdate(Particle p){
    if ( !this.grownUp ) {
      if ( p.radius >= circularGridRayRadius && p.hasBehavior("AdjustRadius")) {
        this.addBehavior( new Move( this ) );
        this.removeBehavior( "AdjustRadius" );
        p.radius = circularGridRayRadius;
        this.grownUp = true;
      }
    }
  }
  
  
  // if a neighbouring Prison gets free, this method serves for preparing 
  public void markAsPass( int dir ){
  
    if (this.hasBehavior("Imprisonment")) {
    
      Behavior b = this.getBehavior( "Imprisonment" );
      Imprisonment i = (Imprisonment) b;
      i.destiny.predestination.get( dir ).pass = true;
    
    }
    
  }
  
}
