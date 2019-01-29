class DisplayDefault extends Behavior {
  DisplayDefault( Particle p ) {
    super(p);
    this.conflictingBehaviors.add("DisplayExplode");
  }
  
  @Override
  public void update( Particle p ){
    pushMatrix();
    translate( p.pos.x,p.pos.y );
    ellipseMode(CENTER);
    noStroke();
    fill(p.col);
    ellipse(0,0,p.radius,p.radius);
    popMatrix();
  }
}

class DisplayDebug extends Behavior {
  DisplayDebug( Particle p ) {
    super(p);
    this.conflictingBehaviors.add("DisplayExplode");
  }
  
  @Override
  public void update( Particle p ){
    if (debug) {
      pushMatrix();
      translate( p.pos.x,p.pos.y );
      ellipseMode(CENTER);
      noStroke();
      fill(p.col);
      ellipse(0,0,p.radius,p.radius);
      popMatrix();
    }
  }
}

class DisplayExplode extends Behavior {
  ArrayList<Rocket> rockets;
  DisplayExplode( Particle p ) {
    super(p);
    this.conflictingBehaviors.add("DisplayDefault");
    this.rockets = new ArrayList<Rocket>();
    float numParticles = int( random( 10,30 ) );
    float angleStep = 2*3.14/numParticles;
    float offset = random(4);
    for (int i=0;i<numParticles;i++) {
      Rocket r = new Rocket(p.pos, offset + float(i)*angleStep);
      s.particles.add(r);
    }
  }
  
  @Override
  public void update( Particle p ){
    pushMatrix();
    translate( p.pos.x,p.pos.y );
    ellipseMode(CENTER);
    noStroke();
    fill(p.col);
    ellipse(0,0,p.radius,p.radius);
    popMatrix();
  }
}


/* Blurred rendered turns off itself once finished */
class DisplayBlur extends Behavior {
  float amount, amountStep, rotation, rotationStep;
  DisplayBlur( Particle p ) {
    super(p);
    this.conflictingBehaviors.add("DisplayDefault");
    this.amount = p.radius/6;
    this.amountStep = 0.1;
    this.rotation = random(3);
    float direction = random(100) > 50 ? 1: -1;
    this.rotationStep = random(0.2,0.5) * direction;
    
  }
  
  @Override
  public void update( Particle p ){
    
    // deactivate when finished
    if (this.amount <=1 ) {
      this.active = false;
      p.removeBehavior("DisplayBlur");
      p.addBehavior(new DisplayDefault(p));
    }
    
    // appropriate step from amount
    this.amountStep = map( this.amount,0,30,0.1,0.5 );
    
    // update when not finished
    this.rotation += this.rotationStep;
    this.amount -= this.amountStep;
    
    pushMatrix();
    translate(p.pos.x,p.pos.y);
    ellipseMode(CENTER);
    noStroke();
    blendMode(ADD);
    
    for (int i=0;i<3;i++) {
      
     this.renderChannel(p,i);
    
    }
    blendMode(NORMAL);
    popMatrix();

  }
  
  private void renderChannel( Particle p, int i ){
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
