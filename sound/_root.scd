// Kontrola serveru
s.boot;
s.reboot;
s.quit;
s.pause;

s.plotTree; // zobrazí nody a skupiny
s.meter; // Zobrazí metr
s.queryAllNodes; // Vypíše všechny nody

s.freeAll;

s.options.numBuffers;
s.options.numBuffers = 2000;
s.options.numAudioBusChannels;
s.options.numOutputBusChannels;
s.options.numInputBusChannels;

ceil(~buffers[0].duration).asInteger;

// Načtení bufferů
(

//
// Syntetizítory
//

// Čistá sinusovka
SynthDef.new(\sine, {
	|freq=440,atk=0.005,rel=0.5, amp=1,pan=0, out=0|
	var sig,env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new(
		[0,1,0],
		[atk,rel],
		[1,-1]
	), doneAction:2);
	sig = Pan2.ar(sig,pan,amp);
	sig = sig * env;
	Out.ar(out,sig);
}).add;

// Přehrání bufferu
SynthDef.new(
	\playbuf, {
		arg amp=1,pan=0,out=0,buf,rate=1, envTimeAtk=0, envTimeRel=1.0, envAtk=1,envStart=1.0, envMiddle=1.0, envEnd=1.0;
		var sig, env, dur;
		sig = PlayBuf.ar(1,buf, BufRateScale.kr(buf) * rate, doneAction:2);
		dur = BufDur.kr(buf);
		env = EnvGen.kr(Env.new([envAtk, envStart, envMiddle, envEnd], [envTimeAtk, envTimeRel, dur - envTimeAtk - envTimeRel]) );

		sig = Pan2.ar(sig,pan) * env;
		sig = sig * amp;
		Out.ar( out, sig );
	}
).add;

// Reverb
SynthDef.new(\reverb,{
	arg in, out=0, mix=0.5,room=0.5,damp=0.5,mul=0.5;
	var sig;
	sig = In.ar(in,2);
	sig = FreeVerb.ar(sig, mix:mix,room:room,damp:damp,mul:mul);
	Out.ar(out,sig);
}).add;


//
// Načtení Bufferů
//


~buffers = Array.new; // Inicializace pole pro buffery
~mode = "raw"; // nastavit režim přehrávání rev / raw

// Kořenová složka pro finální buffery
~rootFolder = PathName.new( "/Users/jan.jachim/Documents/Processing/souzvon/sound/lahoda_samples/" );

// iterovat složku 01_kolizni
~counter=0;
~rootFolder.entries.do({
	arg path;
	~folderContent = PathName.new( path.fullPath );
	path.fullPath.postln;
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

// Nastavení po definici synťáků
~sounds = Group.new();
~effects = Group.after(~sounds);




//
// Ozvěna
//

(

// Busy pro reverby
~reverbBusNone = Bus.audio(s,2);
~reverbBusLight = Bus.audio(s,2);
~reverbBusMedium = Bus.audio(s,2);
~reverbBusHeavy = Bus.audio(s,2);

// Synťáky pro reverby
i = Synth.new(\reverb,[
	\in,~reverbBusLight.index,
	\room, 0.8,
	\mix, 0.7,
	\damp, 0.9,
	\mul, 2
],~effects);
j = Synth.new(\reverb,[
	\in,~reverbBusMedium.index,
	\room, 0.9,
	\mix, 0.6,
	\damp, 0.3,
	\mul, 1.5
],~effects);
k = Synth.new(\reverb,[
	\in,~reverbBusHeavy.index,
	\room, 1,
	\mix, 0.5,
	\damp, 0.3,
	\mul, 2
],~effects);

)

s.freeAll;

// Nastavovací metody reverbu
j.set(\room,0.9,\damp,0.5,\mix,0.6,\mul,1.7);
j.free;
~effects.freeAll;
(
// Testy
x = Synth.new(\sine,[\freq,600,\rel,1, \out,~reverbBusMedium],~sounds);
x = Synth.new(\sine,[\freq,600,\rel,1]);
)
Env.new.plot;

Env.new([0, 1, 1, 0], [1, 1, 2], 'sine').plot;

x = Synth.new(\playbuf,[\out,~reverbBusMedium,\amp, 0.5, \buf,113,\rate,1, \envAtk, 0, \envEnd, 0.5, \envTimeAtk, 3,\envTimeRel, 3],~sounds);
y = Synth.new(\playbuf,[\out,~reverbBusMedium,\amp, 0.5, \buf,114,\rate,1, \envAtk, 0, \envEnd, 0.5, \envTimeAtk, 3,\envTimeRel, 3],~sounds);


(
d = Pdef.new(\test,Pbind.new(
	\instrument, \playbuf,
	\buf, 106 + Pxrand([0,1,2],inf),
	\dur, Pwhite(0.1,0.5,inf),
	\pan, Pwhite(-1,1,inf),
	\rate, Pwhite(0.5,1.5,inf),
	\out, ~reverbBusMedium,
	\group, ~sounds
))
)
d.play;
d.stop;