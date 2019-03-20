(
SynthDef.new(
	\wind, {
		arg freq=400,pan=0,amp=0.2,atk=0.05,rel=2,rq=1,reverb=0,width=1;
		var sig, env;
		env = EnvGen.kr(Env.new(
			[0,1,0],
			[atk,rel]
		),doneAction:2);
		sig = VarSaw.ar(freq,width:width);
		sig = Pan2.ar(sig,pan) * env;
		//sig = FreeVerb.ar(sig,reverb);
		//BPF.ar(sig,freq,rq);
		Out.ar(0,sig);
	}
).add;
)

v = {VarSaw.ar(freq:150,width:SinOsc.kr(0.5))}.play;
v.set(\freq,100);
v.free;

s.freeAll;
s.plotTree;
s.freeAll;

w = Synth.new(\wind);
// zkouším parametry synťáku
w = Synth.new(\wind,[\rel,20]);
w.set(\reverb,0.5);
w.set(\freq,200);
w.set(\width,0.8);
w.set(\pan,-1);
w.set(\pan,1);

(
Pdef.new(
	\windiy,
	Pbind(
		\instrument, \wind,
		\freq, Pseq([150,200,400,120],6),
		\pan, Pexprand(0.1,2,inf) - 1,
		\atk, Pwhite(0.01,0.4,inf),
		//\reverb, Pseq([1,0.1,0.1,0.1,0.1]),
		\amp, Pexprand(0.2,0.5,inf),
		\width, Pexprand(0.5,0.8,inf),
	)
).play;
)

~phase = {white(0,1)};
~phase.value;

(
SynthDef.new(
	\base,{
		arg freq=300, freqLow=60,atk=0.1,rel=2,pan=0;
		var sig, sigMain, sigLow, envMain, envLow;
		envMain = EnvGen.ar(Env.perc(atk,rel));
		envLow = EnvGen.ar(Env.perc(atk,rel*2));
		sigMain = SinOsc.ar(freq,0.5) *  envMain;
		sigLow = SinOsc.ar(freqLow,0.75) * envLow;
		sig = sigMain + sigLow;
		sig = Pan2.ar(sig,pan);
		Out.ar(0,sig);
	}
).add;
)


d = Synth.new(\base).play;
(
~vety = (
	prvni: Pbind(
		\instrument,\wind,
		\freq, Pseq([150,300,200,400],1),
		\pan, -1,
	),
	druha: Pbind(
		\instrument, \wind,
		\freq, Pwhite(100,400,inf),
		\pan, 0,
		\atk, Pwhite(0.2,0.5,10),
	),
	treti: Pbind(
		\instrument, \wind,
		\freq, Pseq([400,200,100,150],inf),
		\pan, 1,
		\atk, Pser([0.05,0.2,0.5],5)
	)
)
)

Pxrand(~vety,10).play;