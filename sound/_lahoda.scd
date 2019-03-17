s.boot;
s.reboot;
s.quit;

s.options.numBuffers = 2000;
s.options.numAudioBusChannels;
s.options.numOutputBusChannels;
s.options.numInputBusChannels;

s.freeAll;


// Inicializace pole pro buffery
~buffers = Array.new;

// nastavit režim přehrávání rev / raw
~mode = "rev";

// Kořenová složka pro finální buffery
~rootFolder = PathName.new( "C:/Data/sketchbook/project_mist_rays/sound/lahoda_samples/final" );

~rootFolder.entries;

// iterovat složku 01_kolizni
(
~counter=0;
~rootFolder.entries.do({
	arg path;
	~folderContent = PathName.new( path.fullPath );
	"/////".postln;
	// ~folderContent.fullPath;
	// iterovat oddíl samplů
	~folderContent.entries.do({
		arg pth;
		~sampleFolder = PathName.new( pth.fullPath++~mode );
		// iterovat obsah dané složky
		~sampleFolder.entries.do({
			arg spl;
			~buffers = ~buffers.add(Buffer.read(s,spl.fullPath));
			(~counter + spl.fullPath).postln;
			~counter = ~counter + 1;

		});
	});
})
)

~buffers[145].play();



(
SynthDef.new(
	\playbuf, {
		arg amp=1,pan=0,out=0,buf;
		var sig;
		sig = PlayBuf.ar(1,buf,doneAction:2);
		sig = Pan2.ar(sig,pan);
		sig = sig * amp;
		Out.ar( out, sig );
	}
).add;
)

x = Synth.new(\playbuf,[\buf,90,\pan,1]);
x.free;

(
d = Pdef.new(\test,Pbind.new(
	\instrument, \playbuf,
	\buf, 9 + Pxrand([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15],inf),
	\dur, Pwhite(0.1,0.5,inf),
	\pan, Pwhite(-1,1,inf),
	\out, ~reverbBus
))
)
d.play;
d.stop;

y = Synth.new(\blip);
y.free;

(

SynthDef.new(\blip,{
	arg out=0;
	var freq,trig,sig;
	freq = LFNoise0.kr(3).exprange(300,1200);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(2);
	sig = sig * EnvGen.kr(Env.perc(0.01,0.2), trig);
	sig = Pan2.ar(sig,LFNoise1.kr(10));
	Out.ar(out,sig);
}).add;

SynthDef.new(\reverb,{
	arg in, out=0;
	var sig;
	sig = In.ar(in,2);
	sig = FreeVerb.ar(sig, 0.5,0.8,0.2);
	Out.ar(out,sig);
}).add;

)

y = Synth.new(\reverb,[\in,~reverbBus.index]);
x = Synth.new(\blip,[\out,~reverbBus.index]);
x = Synth.new(\blip,[\out,0]);
x.free;

~reverbBus = Bus.audio(s,2);
~reverbBus.index;

