class KinectSystem extends System {
  
  KinectSystem(){
    super();
    
    this.controls.add( new KinectControls( this ) );
    
  }
  
  @Override
 public void customSystemUpdate(){
   
   //k.render();
 }


}
