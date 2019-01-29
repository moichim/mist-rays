class AnimateSize extends Behavior {
  float min, max, step;
  AnimateSize( Particle p ){
    super(p);
    this.min = 7;
    this.max = 40;
    this.step = 0.5;
  }
  
  @Override
  public void update( Particle p ) {
    if (p.radius < this.min || p.radius > this.max) {
      this.step = -this.step;
    }
    p.radius += this.step;
  }
}

class FadeOut extends Behavior{
  float step;
  
  FadeOut(Particle p){
    super(p);
    // this.duration = 9999;
    this.step = 1;
  }
  
  FadeOut( Particle p, float s ){
    super(p);
    this.step = s;
  }
  
  FadeOut( Particle p, int d ){
    super(p);
    this.step = p.radius / d;
  }
  
  @Override
  public void update( Particle p ){
    p.radius -= this.step;
    if (p.radius < 0) {
      p.live = false;
      this.active = false;
    }
  }
}

class AdjustRadius extends Behavior {
  float step, targetRadius;
  
  AdjustRadius(Particle p) {
    super(p);
    this.step = 1;
    this.targetRadius = 10;
  }
  
  AdjustRadius(Particle p, float m, float s){
    super(p);
    this.targetRadius = m;
    this.step = s;
  }
  
  AdjustRadius(Particle p, float m, int dur){
    super(p);
    this.targetRadius = m;
    this.step = p.radius / float(dur);
  }
  
  @Override
  public void update( Particle p ) {
    if (p.radius < this.targetRadius) {
      p.radius += this.step;
    } else if (p.radius > this.targetRadius) {
      p.radius -= this.step;
    } else if (p.radius == this.targetRadius) {
      this.active = false;
    }
  }
}

class AdjustVelocity extends Behavior {
  float step, targetVelocity;
  
  AdjustVelocity(Particle p) {
    super(p);
    this.step = 0.1;
    this.targetVelocity = 1;
  }
  
  AdjustVelocity(Particle p, float m, float s){
    super(p);
    this.targetVelocity = m;
    this.step = s;
  }
  
  AdjustVelocity(Particle p, float m, int dur){
    super(p);
    this.targetVelocity = m;
    this.step = p.radius / float(dur);
  }
  
  @Override
  public void update( Particle p ) {
    if (p.vel < this.targetVelocity) {
      p.vel += this.step;
    } else if (p.vel > this.targetVelocity) {
      p.vel -= this.step;
    } else if (p.vel == this.targetVelocity) {
      this.active = false;
    }
  }
}
