# "Souzvon"
Projection in a dark, misty room. Visuals and sounds react on visitor's behavior.

<a href="http://www.youtube.com/watch?feature=player_embedded&v=cxxLzd8Tdas" target="_blank"><img src="http://img.youtube.com/vi/cxxLzd8Tdas/1.jpg" 
alt="IMAGE ALT TEXT HERE" width="300" height="auto" border="10" /></a> Video from DEPO2015, February 2019

- **Visuals** [Processing 3.4](https://processing.org/) (oscP5 & [openkinect](https://github.com/shiffman/OpenKinect-for-Processing) libraries)
- **Sound** [SuperCollider](https://supercollider.github.io/)
- **Control** OSC (via [this app](https://osc.ammd.net/)) & Kinect (Windows drivers installed using [Zadig]())

## Setup & Installation
#### Software
1. Get the necessary software. 
2. First, run the Processing sketch from the `app` folder. From the Processing console, note the UDP adress the sketch is listening on.
3. Then, run Open Stage Control and before startint the app, fill in the Processing's UDP address. Once the OSC is running, load the layout from `osc/controls.json`. 
4. Finally, run SuperCollider, boot the server and load files from `sound` folder. Evaluate the code in the following order: boot > synths > global variables > UDP listener. No need to specify IP addresses - Processing and SuperCollider sketches are already configured.
### Hardware
- Preferrably __a DLP projector__. The projection is mostly B/W and LCD projectors fail screening black color - which is not black at all.
- __A hazer__ for mist.
- __A dark, quiet room with monochrome floor__ and at least 3-4 meters of height. The projection goes from the roof to the floor. Any tiles or colored structure on the floor will impact really bad on the projection.
- __A computer.__
- __A sound system.__ Stereo is enough, quadro is not necessary, yet possible.

![alt text](https://github.com/moichim/mist-rays/raw/master/documentation/2019_01_07_installation_at_moving_station.jpg)

Installation view 7.1.2019, Moving Station, Pilsen
