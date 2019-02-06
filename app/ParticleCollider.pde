class Collider extends Particle {

  Collider( PVector p, float r ){
    super();
    this.pos = p;
    this.radius = r;
    this.vel = 0;
    this.col = color(0,0,255);
    
    // add behaviors
    this.addBehavior( new KinectCollider( this.id ) );
    this.addBehavior( new InvokeCollisions( this.id ) );
    this.addBehavior( new DisplayDebug( this.id ) );
  }
  
}
