class Group {

  ArrayList<Particle> particles;
  
  Group(String behavior){
    
    this.particles = new ArrayList<Particle>();
    
    for (Particle p : s.particles) {
      if (p.hasBehavior(behavior)) {
        this.particles.add(p);
      }
    }
  
  }
  
  Group(String behavior, int count){
    
    int limit = s.particles.size() < count ? s.particles.size() : count;
    
    for (int i = 0; i < limit; i++) {
      Particle p = this.particles.get(i);
      if (p.hasBehavior(behavior)) {
        this.particles.add(p);
      }
    }
  
  }
  
  private boolean hasParticles(){
    return this.particles.size() > 0 ? true : false;
  }
  
  public void setPosition(PVector newPos){
    
    if (this.hasParticles()) {
      for (Particle p : this.particles){
        p.pos = newPos;
      }
    }
  
  }
  
  public Particle getFirstWithBehavior(String behavior) {
    Particle p = null;
    boolean set = false;
    
    for ( Particle particle : s.particles ){
      if ( !set && particle.hasBehavior(behavior) ) {
        p = particle;
        break;
      }
    }
    
    return p;
  }
  
  public void rotateDirection( float angle ){
    
    if (this.hasParticles()) {
      for (Particle p : this.particles){
        p.dir.rotate(angle);
      }
    }
  
  }
  
  public void setColor(color newColor){
  
    if (this.hasParticles()) {
      for (Particle p : this.particles){
        p.col = newColor;
      }
    }
    
  }
  
  public void growRadius(){
  
    if (this.hasParticles()) {
      for (Particle p : this.particles){
        p.radius++;
      }
    }
    
  }
  public void diminishRadius(){
  
    if (this.hasParticles()) {
      for (Particle p : this.particles){
        p.radius--;
      }
    }
  }
  public void growRadius( float increment ){
    
    if (this.hasParticles()) {
      for (Particle p : this.particles){
        p.radius += increment;
      }
    }
    
  }

  public void setRadius(float newRadius){
  
    if (this.hasParticles()) {
      for (Particle p : this.particles){
        p.radius = newRadius;
      }
    }
    
  }
  
  
}
