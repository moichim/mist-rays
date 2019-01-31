class AnimateSize extends Behavior {
  float min, max, step;
  AnimateSize( int id ){
    super(id);
    this.min = 7;
    this.max = 40;
    this.step = 0.5;
  }
  
  @Override
  public void update( ) {
    if (this.parentParticle.radius < this.min || this.parentParticle.radius > this.max) {
      this.step = -this.step;
    }
    this.parentParticle.radius += this.step;
  }
}

class FadeOut extends Behavior{
  float step;
  float duration;
  
  FadeOut(int id){
    super(id);
    // this.duration = 9999;
    this.step = 1;
  }
  
  FadeOut( int id, float s ){
    super(id);
    this.step = s;
  }
  
  FadeOut( int id, int d ){
    super(id);
    this.duration = d;
  }
  @Override
  public void initialSetup() {
      this.step = this.parentParticle.radius / this.duration;
  }
  
  @Override
  public void update(){
    this.parentParticle.radius -= this.step;
    if (this.parentParticle.radius < 0) {
      this.parentParticle.live = false;
      this.active = false;
    }
  }
}

class AdjustRadius extends Behavior {
  float step, targetRadius;
  float duration;
  
  AdjustRadius(int id) {
    super(id);
    this.step = 1;
    this.targetRadius = 10;
  }
  
  AdjustRadius(int id, float m, float s){
    super(id);
    this.targetRadius = m;
    this.step = s;
  }
  
  AdjustRadius(int id, float m, int dur){
    super(id);
    this.targetRadius = m;
    this.duration = float(dur);
  }
  @Override
  public void initialSetup() {
    this.step = this.parentParticle.radius / this.duration;
  }
  
  @Override
  public void update( ) {
    if (this.fullyLoaded) {
      if (this.parentParticle.radius < this.targetRadius) {
        this.parentParticle.radius += this.step;
      } else if (this.parentParticle.radius > this.targetRadius) {
        this.parentParticle.radius -= this.step;
      } else if (this.parentParticle.radius == this.targetRadius) {
        this.active = false;
      }
    }
  }
}

class AdjustVelocity extends Behavior {
  float step, targetVelocity;
  float duration;
  
  AdjustVelocity(int id) {
    super(id);
    this.step = 0.1;
    this.targetVelocity = 1;
  }
  
  AdjustVelocity(int id, float m, float s){
    super(id);
    this.targetVelocity = m;
    this.step = s;
  }
  
  AdjustVelocity(int id, float m, int dur){
    super(id);
    this.targetVelocity = m;
    this.duration = float(dur);
  }
  
  @Override
  public void initialSetup(){
    this.step = this.parentParticle.radius / this.duration;
  }
  
  @Override
  public void update() {
    if (this.parentParticle.vel < this.targetVelocity) {
      this.parentParticle.vel += this.step;
    } else if (this.parentParticle.vel > this.targetVelocity) {
      this.parentParticle.vel -= this.step;
    } else if (this.parentParticle.vel == this.targetVelocity) {
      this.active = false;
    }
  }
}
