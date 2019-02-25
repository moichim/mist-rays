class Sound {

  Sound(){
  
  }
  
  // spustí daný zvuk
  void play(){
  
  }
  
}

class Sequence {
  
  ArrayList<Sound> sounds;
  int current;

  Sequence(){
  
    this.current = 0;
    this.sounds = new ArrayList<Sound>();
    
  }
  
  // Najde nový zvuk v řadě
  public Sound next_sound(){
  
    Sound snd = null;
    
    return snd;
  
  }
  
  // spustí sekvenci
  void start(){
    this.next_sound().play();
  }
  
}

/* */
class Condition{
  Sound soundToPlay;
  Sequence sequenceToStart;
  
  Condition(){
  
  }
  
  boolean isTrue(){
    return false;
  }
  
  // definuje pravidlo pro podmínku
  void trigger(){
    if (this.soundToPlay != null){
      this.soundToPlay.play();
    } else if ( this.sequenceToStart != null ) {
      this.sequenceToStart.start();
    }
  }
  
}

/* Pokročilá logika sklatby je volána soundscapem */
class Composition {
  ArrayList<Condition> conditions;
  
  Composition(){
    this.conditions = new ArrayList<Condition>();
  }
  
  // zkontroluje splnění podmínek
  void resolveConditions(){
    
    if (this.conditions.size()<0) {
      for (Condition cond : this.conditions){
        if (cond.isTrue()) {
          cond.trigger();
        }
      }
    }
    
  }
  
}

/* Základní zvuková krajina může obsahovat několik variant kompozic */
class SoundScape {
  Composition composition; // aktuálně pracující kompozice

  SoundScape(){
  
  }
  
  // Vrátí následující zvuk příslušné kompozice
  Sound get_next_sound() {
    Sound snd = null;
    return snd;
  }
  
  // vrátí dostupné volume pro nový zvuk
  float availableVolume(){
    return 1;
  }
  
  // Zkontroluje podmínky a kdyžtak je spustí
  void update(){
    // nechá kompozici, aby zkontrolovala všechny své podmínky
    this.composition.resolveConditions();
  }
}
