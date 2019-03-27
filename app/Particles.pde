
/* Default Ray*/
class Ray extends Particle {
  
  Ray(){
    
    super();
    
    // initialize the movement 
    this.pos = new PVector(random(width),random(height));
    this.dir = new PVector(random(-1,1),random(-1,1)).normalize();
    this.vel = random(0.5,2);
    this.free = false;
    
    // pomucka
    
    // default appearance
    this.radius = random(10,50);
    this.col = color(255);
    
    
    // add behaviors
    this.addBehavior( new RecieveCollisions( this.id ) );
    this.addBehavior( new InvokeCollisions( this.id ) );
    this.addBehavior( new FadeWhenOutOfCanvas( this.id ) );
    this.addBehavior( new Move( this.id ) );
    this.addBehavior( new DisplayDefault( this.id ) );
    this.addBehavior( new CollisionSound( this.id ) );
   
  }
  
}

/* Rocket launched upon explosion */
class Rocket extends Particle {
  Rocket(PVector startPos, float angle, int duration){
    
    super();
    this.pos = new PVector(startPos.x,startPos.y);
    this.dir = PVector.fromAngle(angle);
    this.vel = 5;
    
    this.radius = 15;
    this.col = color(255);
    this.free = true;
    
    this.addBehavior( new FadeOut( this.id,  (int) duration ) );
    //this.addBehavior( new AdjustVelocity( this.id, 3, (float) 0.2 ) );
    this.addBehavior( new FadeWhenOutOfCanvas( this.id ) );
    // this.addBehavior( new RecieveCollisions( this.id ) );
    this.addBehavior( new Move( this.id ) );
    this.addBehavior( new DisplayDefault( this.id ) );
    
  }
  
}

class Collider extends Particle {

  Collider( PVector p, float r ){
    super();
    this.pos = p;
    this.radius = r;
    this.vel = 0;
    this.col = color(0,255,0);
    // 
    // this.free = false;
    
    // add behaviors
    this.addBehavior( new KinectCollider( this.id ) );
    this.addBehavior( new InvokeCollisions( this.id ) );
    this.addBehavior( new DisplayDebug( this.id ) );
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
    
    this.free = false;
    
    this.grownUp = false;
    
    // behaviors
    this.addBehavior( new RecieveCollisions( this.id ) );
    this.addBehavior( new AdjustRadius( this.id, circularGridRayRadius, int(1) ) );
    this.addBehavior( new Imprisonment( this.id, this.box, position ) );
    this.addBehavior( new FadeWhenOutOfCanvas( this.id ) );
    this.addBehavior( new BellSound( this.id ) );
    this.addBehavior( new DisplayDefault( this.id ) );
    this.addBehavior( new CollisionSound( this.id ) );
    
  }
  
  // a method to release this prisonner from imprisonment only calls the setFre() method
  public void release(){
    
    if ( this.hasBehavior("Imprisonment") ) {
      
      // uvolní závislost
      Behavior b = this.getBehavior("Imprisonment");
      Imprisonment i = (Imprisonment) b;
      i.setFree();
      this.free = true;
      
      // zvyš počet volných částic
      // s.numFreeParticles++;
    }
    
  }
  
  @Override
  public void customUpdate(){
    if ( !this.grownUp ) {
      if ( this.radius >= circularGridRayRadius && this.hasBehavior("AdjustRadius")) {
        this.addBehavior( new Move( this.id ) );
        this.removeBehavior( "AdjustRadius" );
        this.radius = circularGridRayRadius;
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
