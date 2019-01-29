class SoundBuffer {
  ArrayList<CollisionSound> playingSounds;
  float currentVolume;
  
  SoundBuffer(){
    this.playingSounds = new ArrayList<CollisionSound>();
    this.currentVolume = 0;
  }
  
  void update(){
    
    float currentVolume = 0;
  
  }
  
  void render() {
    Group playing = new Group("CollisionSound");
    int i = 0;
    int resolution = 20;
    int magnitude = 100;
    float top = 30;
    for ( Particle p : playing.particles ) {
      CollisionSound cs = (CollisionSound) p.getBehavior("CollisionSound");
      if ( cs.isPlaying ) {
        i++;
        
        // Draw available volume
        pushMatrix();
        
        translate(10,top);
        
        fill(0,255,255);
        stroke(255);
        text("CV: " + nf(currentVolume,0,2), 10 + resolution,10);
        rect(0,0,resolution,(maxVolume - currentVolume) * magnitude );
        
        popMatrix();
        
        
        // Draw lines of playing vertices
        pushMatrix();
        
        fill(255);
        translate( 150 + i*resolution, top );
        textAlign(LEFT);
        text( String.valueOf(nf(cs.currentAmp,0,2)), resolution*i, -10 );
        
        float w = resolution * i;
        float h = cs.currentAmp * magnitude;
        
        fill(0,255,0);
        stroke(255);
        
        rect(w,0,resolution,h);
        
        noStroke();
        noFill();
        
        popMatrix();
      }
    }
  }
  
  
  /* Get currently playing volume */
  float getCurrentVolume(){
    float f = 0;
    
    if ( this.playingSounds.size() > 0 ) {
      for (CollisionSound snd : this.playingSounds ) {
        f += snd.currentAmp; 
      }
    }
    
    return f;
  }
  
}
