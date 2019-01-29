/** Walk the walk */

class Move extends Behavior {
  Move( Particle p ){
    super(p);
  }
  
  @Override
  public void update( Particle p ){
    PVector step = p.dir.copy().mult(p.vel);
    p.pos = p.pos.add(step);
  }
}


/** Recieve collisions from others */
class RecieveCollisions extends Behavior {
  
  int sinceLastCollision;
  boolean collidedRecently;
  
  RecieveCollisions( Particle p ){
    super(p);
    this.collidedRecently = false;
    this.sinceLastCollision = 0;
    
  }
  
  @Override
  public void update(Particle p){
    
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
      
        float distance = PVector.dist(p.pos,r.pos);
        if ( distance <= p.radius/2 + r.radius/2 && distance > 0) {
          
          /* apply the colision to self */
          p.dir = this.bouncedDirection( p, p.pos, r.pos );
          
          /* for sure, applay the collision to the other when appropriate */
          if ( r.hasBehavior("RecieveCollisions") ) {
            r.dir = this.bouncedDirection(r, r.pos, p.pos );
            r.addBehavior( new DisplayBlur( r ) );
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
          
          if (p.hasBehavior("CollisionSound") && r.hasBehavior("CollisionSound") ) {
            CollisionSound pS = (CollisionSound) p.getBehavior("CollisionSound");
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
      if ( p.hasBehavior("DisplayBlur") ) {
        
        Behavior b = p.getBehavior("DisplayBlur");
        DisplayBlur db = (DisplayBlur) b;
        if ( db.amount < p.radius/2 ) {
          
          //db.amount += 10;
        }
        
      } else {
        p.addBehavior( new DisplayBlur( p ) );
      }
      
      // ring the collision
      if (rings) {
        
        println("Hraji");
        
        CollisionSound snd = (CollisionSound) p.getBehavior("CollisionSound");
          
        if ( !snd.blocked ) {
          println("cink");
          snd.ring( p );        
        }
      }
      
      
    }
  
  }
  
  // thic method calculates the new direction upon collision based on the opposite direction
  PVector bouncedDirection( Particle p, PVector selfPos, PVector oppositePos ){
    
    return PVector.add( p.dir, PVector.sub(selfPos, oppositePos).normalize() ).normalize();
  
  }
  
  
}

/* This state invokes collisions to others */
class InvokeCollisions extends Behavior {
  
  // spustí kolizi, pokud oponent má třídu RecieveCollisions
  InvokeCollisions( Particle p ) {
    super(p);
  }
  
}

/* Check and resolve collisions with app borders */
class CollideWithBorders extends Behavior {
  
  // spustí kolizi, pokud oponent má třídu RecieveCollisions
  CollideWithBorders( Particle p ) {
    super(p);
  }
  
  @Override
  public void update( Particle p ) {
    if (p.pos.x > width) { p.dir.x = -p.dir.x; }
    if (p.pos.x < 0) { p.dir.x = -p.dir.x; }
    if (p.pos.y > height) { p.dir.y = -p.dir.y; }
    if (p.pos.y < 0) { p.dir.y = -p.dir.y; }
    
  }
}

/* Check and resolve collisions with app borders */
class FadeWhenOutOfCanvas extends Behavior {
  boolean fading;
  
  FadeWhenOutOfCanvas( Particle p ) {
    super(p);
    this.fading = false;
  }
  
  @Override
  public void update( Particle p ) {
    if ( !this.fading ) {
      if (
        ( p.pos.x < c.x )
        || ( p.pos.x > c.x+c.w )
        || ( p.pos.y < c.y )
        || ( p.pos.y > c.y+c.h )
      ) {
        this.fading = true;
        p.addBehavior( new FadeOut( p, (int) 15 ) );
      }
    }
  }
}

class Imprisonment extends Behavior {
  Destiny destiny;
  PVector box;
  
  Imprisonment(Particle p, PVector box_, int position){
    super(p);
    
    // first resolve conflicting behaviors
    this.conflictingBehaviors.add("InvokeCollisions");
    
    // then create the movement pattern
    this.box = box_;
    PVector boxEnd = new PVector(this.box.x + circularGridBoxSize,this.box.y + circularGridBoxSize);
    this.destiny = new Destiny( this.box, boxEnd, position );
    this.destiny.nextTarget();
    
    // last, adjust the particle position by the movement pattern
    p.pos = this.destiny.getPointCoordinates( position ).copy();
    p.dir = this.destiny.dir( p.pos );
    p.vel = 2;
  }
  
  @Override
  public void update(Particle p){
    
    // particle is in its position
    if ( this.destiny.hasArrived( p.pos, 1 ) ) {
      
      // if the point is pass, set this particle fre
      if (this.destiny.isPassing()) {
        this.setFree( p );
      }
      
      // if the point is not pass, set new target
      else {
        this.destiny.nextTarget();
        p.dir = this.destiny.dir( p.pos );
        // p.addBehavior( new DisplayBlur( p ) );
      }
      
    }
    
    // render debug if necessary
    if (debug) {
      this.destiny.render();
    }
    
  }
  
  // release the particle from imprisonment
  public void setFree(Particle p){
    
    // change behaviors of the self
    p.removeBehavior("Imprisonment");
    p.addBehavior( new InvokeCollisions( p ) );
    p.addBehavior( new FadeWhenOutOfCanvas( p ) );
    
    
    // prepare the particle for comparaison with others
    Prisonner current = null;
    if ( p.getClass().getSimpleName().equals("Prisonner") ) {
      current = (Prisonner) p;
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
  
  KinectCollider( Particle p ) {
    super(p);
  }
}
