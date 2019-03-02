/** Walk the walk */
class Move extends Behavior {
  Move( int id ){
    super(id);
  }
  
  @Override
  public void update( ){
    if ( this.fullyLoaded ){
      PVector step = this.parentParticle.dir.copy().mult( this.parentParticle.vel * speedAspect);
      this.parentParticle.pos = this.parentParticle.pos.add(step);
    }
  }
}


/** Recieve collisions from others */
class RecieveCollisions extends Behavior {
  
  int sinceLastCollision;
  boolean collidedRecently;
  int sinceLastKinect;
  
  RecieveCollisions( int id ){
    super(id);
    this.collidedRecently = false;
    this.sinceLastCollision = 0;
    this.sinceLastKinect = 0;
    
  }
  
  private void bounce( Particle p ) {
  
    /* V každém případě rozostři */
    this.parentParticle.addBehavior( new DisplayBlur( this.parentParticle.id ) );
    
    /* V každém případě odraž */
    this.parentParticle.dir = this.bouncedDirection( this.parentParticle.pos, p.pos );
    
    /* Pokud má některé ze zvukových chování a zároveň protivník ani on sám není blokován, zahraj */
    if ( this.parentParticle.hasBehavior("CollisionSound")  ) {
      
      Behavior b = this.parentParticle.getBehavior("CollisionSound");
      Behavior bOp = p.getBehavior("CollisionSound");
      CollisionSound cs = (CollisionSound) b;
      CollisionSound csOp = (CollisionSound) bOp;
      // if (!csOp.blocked ) {
        // cs.ring( p );
        
        Sound snd = s.soundscape.get_next_sound( this.parentParticle.pos );
        snd.play();
        if (debug) {
          pushMatrix();
          PVector opposite = oppositePosition(p.pos);
          translate(opposite.x,opposite.y);
          fill(255,0,255);
          rect(-10,-10,10,10);
          noFill();
          popMatrix();
        }
        
        // cs.blocked = true;

      //}
      
      
      /* Zvuk bude */
      //this.parentParticle.col = color(random(150,255),random(150,255),random(0,255));
      
    }

    
  }
  
  @Override
  public void update(){
    
    /* Na začátku vždy snižuj bloky */
    if ( this.sinceLastKinect > 0) { this.sinceLastKinect--; }
    if ( this.sinceLastCollision >= 0) { this.sinceLastCollision++; }
    
    
    /* Nový kód */
    if ( this.fullyLoaded ){
      
      for (Particle p : s.particles ) {
        
        /* Kontrola zda protějšek invokuje kolize */
        if ( p.invokes ) {
          
          /* Kontrola vzdálenosti */
          float distance = PVector.dist(this.parentParticle.pos, p.pos);
          if ( distance <= ( this.parentParticle.radius/2 + p.radius/2 ) + s.soundscape.composition.collisionPrecision && p != this.parentParticle && this.sinceLastCollision > 3) {
            
            // println(frameCount + " Distance: " + distance + " Součet průměrů " + this.parentParticle.radius/2 + p.radius/2 );
            this.sinceLastCollision = 0;
            
            
            /* Protějšek je kinect */
            if ( p.getClass().getSimpleName().equals("Collider") ) { // p.hasBehavior("KinectColider") 
              
              // inkrementuj počítadlo kinectu
              this.sinceLastKinect += 10;
              //////////////////////////////////////////////////////////////////////////// ODRAŽ
              this.bounce( p );
              
              // pokud je item zároveň prisonner, uvolni ho
              if (this.parentParticle.hasBehavior("Imprisonment")) {
                
                Prisonner pris = (Prisonner) this.parentParticle;
                pris.release();
                
              
              }
              
              /* Pokud protivník je kinect, zkontroluj blokaci */
              if ( this.sinceLastKinect >= 30 ) {
                
                ////////////////////////////////////////////////////////////////////////// EXPLODUJ
                this.parentParticle.addBehavior( new DisplayExplode( this.parentParticle.id ) );
              
              } // konec smrti následkem kinectu
              
            } // konec akcí pro kinect
            
            /* Protějšek není kinect*/
            else {
              
              //////////////////////////////////////////////////////////////////////////// ODRAZ
              this.bounce( p );
              
              
            } // konec akcí pro vše ostatní krom kinectu
            
            /* Protějšek je prisoner */
            if ( p.hasBehavior("Imprisonment") ) {
              
              //////////////////////////////////////////////////////////////////////////// UVOLNI PROTIVNIKA
              Prisonner pris = (Prisonner) p;
              pris.release();
                
            } // konec akcí pro prisonera
            
          } // konec kontroly vzdálenosti this a protivníka
        
        } // konec kontroly zda protivník invokuje kolize
        
        // nyní je nutné zkontrolovat, jestli protějšek není prisonner
        if ( !p.invokes && !p.free && this.parentParticle.free ) {
          
          float distance = PVector.dist(this.parentParticle.pos, p.pos);

          if ( distance <= ( this.parentParticle.radius/2 + p.radius/2 ) + s.soundscape.composition.collisionPrecision && p != this.parentParticle && this.sinceLastCollision > 3) {
            this.bounce( p );
            Prisonner pris = (Prisonner) p;
            pris.release();
            
          }
          
        }
      
      } // konec iterace prvků
      
    }
  
  } // konec updatu
  
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
  @Override
  public void initialSetup(){
    this.parentParticle.invokes = true;
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
class KinectCollider extends Behavior {
  
  KinectCollider( int id ) {
    super(id);
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
    //this.parentParticle.col = color(100);
    
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
    
    this.parentParticle.col = color(255);
    
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
