class DisplayDefault extends Behavior {
  DisplayDefault( int id ) {
    super(id);
    this.conflictingBehaviors.add("DisplayExplode");
  }
  
  @Override
  public void update( ){
    if ( this.fullyLoaded ) {
      pushMatrix();
      translate( this.parentParticle.pos.x,this.parentParticle.pos.y );
      ellipseMode(CENTER);
      noStroke();
      fill(this.parentParticle.col);
      ellipse(0,0,this.parentParticle.radius,this.parentParticle.radius);
      popMatrix();
    }
  }
}

class DisplayDebug extends Behavior {
  DisplayDebug( int id ) {
    super(id);
    this.conflictingBehaviors.add("DisplayExplode");
  }
  
  @Override
  public void update( ){
    if (debug && this.fullyLoaded) {
      pushMatrix();
      translate( this.parentParticle.pos.x,this.parentParticle.pos.y );
      ellipseMode(CENTER);
      noStroke();
      fill(this.parentParticle.col);
      ellipse(0,0,this.parentParticle.radius,this.parentParticle.radius);
      noFill();
      popMatrix();
    }
  }
}

class DisplayExplode extends Behavior {
  ArrayList<Rocket> rockets;
  int numParticles;
  int life;
  DisplayExplode( int id ) {
    super(id);
    this.conflictingBehaviors.add("DisplayDefault");
    this.rockets = new ArrayList<Rocket>();
    this.numParticles = int( random( 10,30 ) );
    this.life = 30;
  }
  @Override
  public void initialSetup() {
    
    if ( this.fullyLoaded ) {
      
      this.parentParticle.addBehavior(new FadeOut( this.parentParticle.id, this.life ));
      this.parentParticle.removeBehavior("InvokeCollisions");
      this.parentParticle.removeBehavior("RecieveCollisions");
      this.parentParticle.col = color(255,0,255);
      
      float angleStep = 2*3.14/numParticles;
      float offset = random(4);
      for (int i=0;i<this.numParticles;i++) {
        Rocket r = new Rocket(this.parentParticle.pos, offset + float(i)*angleStep, this.life);
        s.particles.add(r);
        // this.rockets.add(r);
      }
    }
    
  }
  
  @Override
  public void update(){
    
    this.life--;
      if (this.life <= 0) {
        this.parentParticle.live = false;
      }
    pushMatrix();
    translate( this.parentParticle.pos.x,this.parentParticle.pos.y );
    ellipseMode(CENTER);
    noStroke();
    fill(this.parentParticle.col);
    ellipse(0,0,this.parentParticle.radius,this.parentParticle.radius);
    popMatrix(); 
    if (this.fullyLoaded) {
      if ( this.rockets.size()>0 ) {
        for (Rocket r : this.rockets) {
          //r.update();
        }
      }
    }
  }
}


/* Blurred rendered turns off itself once finished */
class DisplayBlur extends Behavior {
  float amount, amountStep, rotation, rotationStep;
  DisplayBlur( int id) {
    super(id);
    this.conflictingBehaviors.add("DisplayDefault");
    this.amount = 0;
    this.amountStep = 0.1;
    this.rotation = random(3);
    float direction = random(100) > 50 ? 1: -1;
    this.rotationStep = random(0.2,0.5) * direction;
    
  }
  
  @Override
  public void initialSetup(){
    if (this.fullyLoaded) {
      this.amount = this.parentParticle.radius/6;
    }
  }
  
  @Override
  public void update( ){
    if (this.fullyLoaded) {
      
      // deactivate when finished
      if (this.amount <=1 ) {
        this.active = false;
        this.parentParticle.removeBehavior("DisplayBlur");
        this.parentParticle.addBehavior(new DisplayDefault(this.parentParticle.id));
      }
      
      // appropriate step from amount
      this.amountStep = map( this.amount,0,30,0.1,0.5 );
      
      // update when not finished
      this.rotation += this.rotationStep;
      this.amount -= this.amountStep;
      
      pushMatrix();
      translate(this.parentParticle.pos.x,this.parentParticle.pos.y);
      ellipseMode(CENTER);
      noStroke();
      blendMode(ADD);
      
      for (int i=0;i<3;i++) {
        
       this.renderChannel(i);
      
      }
      blendMode(NORMAL);
      popMatrix();
    
    }
    
    

  }
  
  private void renderChannel( int i ){
    Particle p = this.parentParticle;
    float r = 0;
    float g = 0;
    float b = 0;
    float angle = 0;
    float distance = this.amount;
    switch (i){
        case 0:
          r = red(p.col);
          break;
        case 1:
          g = green(p.col);
          angle = radians( 360 / 3 );
          break;
        case 2:
          b = blue(p.col);
          angle = radians( 360 / 3 * 2 );
          break;
    }
    
    fill(r,g,b);
    PVector transposition = PVector.fromAngle(angle);
    transposition.mult(distance);
      
    pushMatrix();
    rotate(this.rotation);
    translate(transposition.x,transposition.y);
    ellipse(0,0,p.radius,p.radius);
    popMatrix();
  }
  
  
}

class BellSound extends Behavior {

  BellSound(int id) {
    super(id);
  }
  
}

class CollisionSound extends Behavior {

  CollisionSound( int id ) {
    super(id);

  }

}
