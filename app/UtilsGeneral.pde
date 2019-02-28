// vypočítá protilehlou pozici k aktuální pozici
PVector oppositePosition( PVector initial ){
  
  return new PVector(0,0).sub( initial ).add( new PVector(width,height) );
  
}

// hodí si mincí
boolean flipACoin(){
  float coin = random(1);
  boolean result = false;
  if (coin <= 0.5 ) {
    result = true;
  }
  return result;
}
