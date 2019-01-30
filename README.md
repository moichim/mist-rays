# Mist Rays interactive installation
Projection in a dark, misty room. Visuals and sounds react on visitor's behavior.

<a href="http://www.youtube.com/watch?feature=player_embedded&v=W1uXE5F_LvI
" target="_blank"><img src="http://img.youtube.com/vi/W1uXE5F_LvI/1.jpg" 
alt="IMAGE ALT TEXT HERE" width="300" height="auto" border="10" /></a>

- **Visuals** [Processing 3.4](https://processing.org/) (oscP5 & [openkinect](https://github.com/shiffman/OpenKinect-for-Processing) libraries)
- **Sound** [SuperCollider](https://supercollider.github.io/)
- **Control** OSC (via [this app](https://osc.ammd.net/)) & Kinect (Windows drivers installed using [Zadig]())

## Setup & Installation
#### Software
1. Get the necessary software. 
2. First, run the Processing sketch from the `app` folder. Note the IP address its OSC reciever is listening on. It shall be noted in the console.
3. Then, run OpenStageControl and before loading, fill in the Processing's IP address. Once the OSC is running, load the layout from `osc/controls.json`. 
4. Finally, run SuperCollider, boot the server and load files from `sound` folder. Evaluate the code in the following order: boot > synths > global variables > UDP connection. No need to specify IP addresses - Processing and SuperCollider sketches are already configured.
### Hardvare
- Preferrably _a DLP projector_. The projection is mostly B/W and LCD projectors fail screening black color - which is not black at all.
- _A hazer_ for mist)
- _A dark, quiet room with monochrome floor_ and at least 3-4 meters of height. The projection goes from the roof to the floor. Any tiles or colored structure on the floor will impact really bad on the projection.
- _A computer._
- _A sound system._ Stereo is enough, quadro is not necessary, yet possible.
