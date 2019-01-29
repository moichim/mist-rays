class Behavior {
  
  boolean active;
  ArrayList<String> conflictingBehaviors;
  
  
  Behavior(Particle p){
    this.active = true;
    this.conflictingBehaviors = new ArrayList<String>();
  }
 
  
  public void update(Particle p){
    // metoda určená k přepisování
  }
  
  /* Action taken on event removal */
  public void onRemoval( Particle p, boolean take ){
  
  }
  
  
  /* Return the class name of the behavior */
  public String name() {
    return this.getClass().getSimpleName();
  }
  
  /* Optionally check and remove any conflicting beahiors assigned to the particle */
  public void removeConflictingBehaviors( Particle p ){
    if ( this.conflictingBehaviors.size() > 0 ) {
      for ( String conflicting : this.conflictingBehaviors ) {
        if ( p.behaviors.size() > 0 ){
          for (int i=0;i<p.behaviors.size();i++) {
            Behavior b = p.behaviors.get(i);
            if (b.name().equals(conflicting)) {
              p.behaviors.remove(i);
            }
          }
        }
      }
    }
  }
  
}
