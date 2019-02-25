class BellSound extends Behavior {
  boolean trigger;
  int life, duration; // počítadlo života
  float amp, currentAmplitude; // kontrola volumenu
  float frequency; // kontrola frekvence
  PVector pan; // kontrola zvuku

  BellSound(int id) {
    super(id);
    this.life = 0;
    this.duration = 0;
    this.frequency = bellFrequency;
  }

  public void ring() {
    if (this.fullyLoaded) {

      // assemble the message
      OscMessage msg = new OscMessage("/sine");
      msg.add( this.frequency ); // frequency
      msg.add( bellAtk ); // attack
      msg.add( bellRelease ); // release
      msg.add( bellAmp ); // amplituda
      msg.add( 0 ); // pan X
      msg.add( 0 ); // pan Y

      // send the message
      oscP5.send( msg, superCollider );
    }
  }
}

class CollisionSound extends Behavior {
  boolean isPlaying, blocked;
  int life, duration;
  float amp, currentAmp;
  float frequency;
  PVector pan;  


  CollisionSound( int id ) {
    super(id);

    this.life = 0;
    this.isPlaying = false;
    this.blocked = false;

    this.amp = 0;
    this.currentAmp = 0;
    this.pan = new PVector(0, 0);
    this.frequency = 0;
    this.duration = 0;

    b.playingSounds.add(this);
  }

  @Override
    public void update( ) {

    if ( this.isPlaying ) {

      // println(frameCount + " Harji");

      // increment life
      this.life++;
      //float colAspect = map( this.life,0,this.duration,0,255 );

      //this.parentParticle.col = color(255,colAspect,255);

      // update the current amplitude
      this.updateAmplitude();

      // migrate the current volume
      currentVolume += this.currentAmp;


      // finally check the life of an object
      if ( this.life >= this.duration ) {
        this.isPlaying = false;
        this.blocked = false;
        this.life = 0;
        this.currentAmp = 0;
        this.amp = 0;
        this.duration = 0;
        this.parentParticle.col = color(255);
      }
    } 

    // in the middle of the duration, start accepting new
    if ( this.life >= int( this.duration  / collisionBlockAmount) && this.blocked ) {
      this.blocked = false;
      this.isPlaying = false;
      this.life = 0;
      println("Uvolňuji zvuk");
    }
  }


  /* Volume update */
  private void updateAmplitude() {
    this.currentAmp = map( float(this.life), 0, float(this.duration), this.amp, 0 );
  }

  /*  Ring */
  public void ring(Particle p) {

    if (this.fullyLoaded ) {

      // act only if the particle is not blocked by a recent collision
      if (!this.blocked && b.playing.size() < 10) {

        // perform initial setup
        this.isPlaying = true;
        this.blocked = true;

        // generate parameters for the sound
        this.amp = b.available;
        this.frequency = random(collisionMinFreq, collisionMaxFreq);
        float release = random( collisionMinRel, collisionMaxRel );
        this.duration = int( release * frameRate );
        this.pan.x = map(this.parentParticle.pos.x, padding.x, c.w - padding.x, -1, 1);
        this.pan.y = map(this.parentParticle.pos.y, padding.y, c.h - padding.y, -1, 1);
        // PVector mid = this.parentParticle.pos.copy().cross( p.pos );
        float a = PVector.angleBetween(this.parentParticle.pos, p.pos);
        PVector mid = new PVector(1, 1).rotate(a).mult(this.parentParticle.radius).add(this.parentParticle.pos);
        // mid = p.pos.copy().sub(this.parentParticle.pos).normalize().mult(this.parentParticle.radius).add(p.pos);



        // send the amplitode to global volume buffer
        // currentVolume += this.amp;


        // oscP5.send( msg, superCollider );
        SCM m = new SCM("/sine", this.frequency, collisionAtk, release, this.amp, this.pan, this.parentParticle.pos, mid);
        b.concurrentSounds.add( m );
        println("JSem tu!//////////////////////////////////////");
        println( "Celková velikost je " + b.concurrentSounds.size() );
      }
    }
  }
}

class SCM {
  String name;
  float freq, atk, rel, amp, ampOriginal, dur, durOriginal;
  PVector pan, posTmp, middle;


  SCM(String name, float f, float a, float r, float amplitude, PVector p, PVector posTmp_, PVector mid) {
    this.name = name;
    this.freq = f;
    this.atk = a;
    this.rel = r;
    this.amp = amplitude;
    this.ampOriginal = amplitude;
    this.pan = new PVector(p.x, p.y);
    this.posTmp = posTmp_;
    this.middle = mid;
    this.dur = int(this.rel * frameRate);
    this.durOriginal = this.dur;
  }

  public void send() {
    OscMessage msg = new OscMessage("/sine");
    msg.add( this.freq ); // frequency
    msg.add( this.atk ); // attack
    msg.add( this.rel ); // release
    msg.add( this.amp ); // amplituda
    msg.add( this.pan.x ); // pan X
    msg.add( this.pan.y ); // pan Y

    oscP5.send( msg, superCollider );
    println(msg);
  }
}
