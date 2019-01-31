/** Walk the walk */

class Move extends Behavior {
  Move( int id ){
    super(id);
  }
  
  @Override
  public void update( ){
    if ( this.fullyLoaded ){
      PVector step = this.parentParticle.dir.copy().mult(this.parentParticle.vel);
      this.parentParticle.pos = this.parentParticle.pos.add(step);
    }
  }
}


/** Recieve collisions from others */
class RecieveCollisions extends Behavior {
  
  int sinceLastCollision;
  boolean collidedRecently;
  
  RecieveCollisions( int id ){
    super(id);
    this.collidedRecently = false;
    this.sinceLastCollision = 0;
    
  }
  
  @Override
  public void update(){
    if ( this.fullyLoaded ){
      
      // count time since last collision
      if ( this.collidedRecently ) {
        this.sinceLastCollision++;
        if (this.sinceLastCollision > 5) { this.collidedRecently = false; this.sinceLastCollision = 0;  }
        
      }
      
      boolean collides = false; // trigger for events past collisions
      boolean rings = false; // indicate whether to ring or not
      /* Detect and execute collisions */
      for ( Particle r : s.particles ) {  
        
        if (r.hasBehavior("InvokeCollisions")) {
        
          float distance = PVector.dist(this.parentParticle.pos,r.pos);
          if ( distance <= this.parentParticle.radius/2 + r.radius/2 && distance > 0) {
            
            /* apply the colision to self */
            this.parentParticle.dir = this.bouncedDirection( this.parentParticle.pos, r.pos );
            
            /* for sure, applay the collision to the other when appropriate */
            if ( r.hasBehavior("RecieveCollisions") ) {
              r.dir = this.bouncedDirection( r.pos, this.parentParticle.pos );
              r.addBehavior( new DisplayBlur( r.id ) );
            }
            /* set the other free if possible */
            if ( r.hasBehavior("Imprisonment") ) {
              Prisonner pris = (Prisonner) r;
              pris.release();
            }
            
            /* Enable post-collision actions */
            if ( ! this.collidedRecently ) {
              collides = true;
            }
            
            if (this.parentParticle.hasBehavior("CollisionSound") && r.hasBehavior("CollisionSound") ) {
              CollisionSound pS = (CollisionSound) this.parentParticle.getBehavior("CollisionSound");
              CollisionSound rS = (CollisionSound) r.getBehavior("CollisionSound");
              if ( pS.blocked || rS.blocked ) {
                rings = false;
              } else {
                rings = true;
              }
            }
            
            
          }
          
        }
        
      }
      
      /* Fire actions done upon collision */
      if ( collides ) {
        
        // temporarily blur the ray
        if ( this.parentParticle.hasBehavior("DisplayBlur") ) {
          
          Behavior b = this.parentParticle.getBehavior("DisplayBlur");
          DisplayBlur db = (DisplayBlur) b;
          if ( db.amount < this.parentParticle.radius/2 ) {
            
            //db.amount += 10;
          }
          
        } else {
          this.parentParticle.addBehavior( new DisplayBlur( this.parentParticle.id ) );
        }
        
        // ring the collision
        if (rings) {
          
          CollisionSound snd = (CollisionSound) this.parentParticle.getBehavior("CollisionSound");
            
          if ( !snd.blocked ) {
            snd.ring( );        
          }
        }
        
        
      }
    
    }
    
    
  
  }
  
  // thic method calculates the new direction upon collision based on the opposite direction
  PVector bouncedDirection( PVector selfPos, PVector oppositePos ){
    
    return PVector.add( this.parentParticle.dir, PVector.sub(selfPos, oppositePos).normalize() ).normalize();
  
  }
  
  
}

/* This state invokes collisions to others */
class InvokeCollisions extends Behavior {
  
  // spustí kolizi, pokud oponent má třídu RecieveCollisions
  InvokeCollisions( int id ) {
    super(id);
  }
  
}

/* Check and resolve collisions with app borders */
class CollideWithBorders extends Behavior {
  
  // spustí kolizi, pokud oponent má třídu RecieveCollisions
  CollideWithBorders( int id ) {
    super(id);
  }
  
  @Override
  public void update(  ) {
    if (this.parentParticle.pos.x > width) { this.parentParticle.dir.x = -this.parentParticle.dir.x; }
    if (this.parentParticle.pos.x < 0) { this.parentParticle.dir.x = -this.parentParticle.dir.x; }
    if (this.parentParticle.pos.y > height) { this.parentParticle.dir.y = -this.parentParticle.dir.y; }
    if (this.parentParticle.pos.y < 0) { this.parentParticle.dir.y = -this.parentParticle.dir.y; }
    
  }
}

/* Check and resolve collisions with app borders */
class FadeWhenOutOfCanvas extends Behavior {
  boolean fading;
  
  FadeWhenOutOfCanvas( int id ) {
    super(id);
    this.fading = false;
  }
  
  @Override
  public void update( ) {
    if ( !this.fading && this.fullyLoaded ) {
      if (
        ( this.parentParticle.pos.x < c.x )
        || ( this.parentParticle.pos.x > c.x+c.w )
        || ( this.parentParticle.pos.y < c.y )
        || ( this.parentParticle.pos.y > c.y+c.h )
      ) {
        this.fading = true;
        this.parentParticle.addBehavior( new FadeOut( this.parentParticle.id, (int) 15 ) );
      }
    }
  }
}

class Imprisonment extends Behavior {
  Destiny destiny;
  PVector box;
  int position;
  
  Imprisonment(int id, PVector box_, int position_){
    super(id);
    
    // first resolve conflicting behaviors
    this.conflictingBehaviors.add("InvokeCollisions");
    
    // set the initial box for the purpose of initialSetup()
    this.box = box_;
    this.position = position_;
    
  }
  
  @Override
  public void initialSetup(){
    // then create the movement pattern
    
    PVector boxEnd = new PVector(this.box.x + circularGridBoxSize,this.box.y + circularGridBoxSize);
    this.destiny = new Destiny( this.box, boxEnd, this.position );
    this.destiny.nextTarget();
    
    // last, adjust the particle position by the movement pattern
    this.parentParticle.pos = this.destiny.getPointCoordinates( position ).copy();
    this.parentParticle.dir = this.destiny.dir( this.parentParticle.pos );
    this.parentParticle.vel = 2;
  }
  
  @Override
  public void update(){
    
    if ( this.fullyLoaded ) {
      
      // particle is in its position
      if ( this.destiny.hasArrived( this.parentParticle.pos, 1 ) ) {
        
        // if the point is pass, set this particle fre
        if (this.destiny.isPassing()) {
          this.setFree( );
        }
        
        // if the point is not pass, set new target
        else {
          this.destiny.nextTarget();
          this.parentParticle.dir = this.destiny.dir( this.parentParticle.pos );
          // this.parentParticle.addBehavior( new DisplayBlur( p ) );
        }
        
      }
      
      // render debug if necessary
      if (debug) {
        this.destiny.render();
      }
    
    }

  }
  
  // release the particle from imprisonment
  public void setFree(){
    
    // change behaviors of the self
    this.parentParticle.removeBehavior("Imprisonment");
    this.parentParticle.removeBehavior("SoundsBell");
    this.parentParticle.addBehavior( new InvokeCollisions( this.parentParticle.id ) );
    // p.addBehavior( new FadeWhenOutOfCanvas( p ) );
    
    
    // prepare the particle for comparaison with others
    Prisonner current = null;
    if ( this.parentParticle.getClass().getSimpleName().equals("Prisonner") ) {
      current = (Prisonner) this.parentParticle;
    }
    
    // iterate all others and release the neighbours
    for ( int i = 0; i < s.particles.size();i++ ) {
      
      Particle o = s.particles.get(i);
      
      // continue only when the particle is a prisonner and not self
      if ( o != current && o.getClass().getSimpleName().equals("Prisonner") ) {
        
        // cast the particle to the propper class
        Prisonner pris = (Prisonner) o;
        
        // exclude already liberated prisonners
        if ( pris.hasBehavior("Imprisonment") ) {
        
          // now check the distance based on step
          float step = circularGridBoxSize;
            
          // then check each individual positions and mark their points as pass
          if ( pris.box.x == current.box.x - step && pris.box.y == current.box.y ) { pris.markAsPass(3); } // left
          if ( pris.box.x == current.box.x + step && pris.box.y == current.box.y ) { pris.markAsPass(1); } // right
          if ( pris.box.y == current.box.y - step && pris.box.x == current.box.x ) { pris.markAsPass(2); } // top
          if ( pris.box.y == current.box.y + step && pris.box.x == current.box.x ) { pris.markAsPass(0); } // bottom
          
          
        } // end beheavior condition
        
      }//end class type and self condition
      
    } // end of the cycle
    
  }
}

/* Check and resolve collisions with app borders */
class KinectCollider extends Behavior {
  
  KinectCollider( int id ) {
    super(id);
  }
}
