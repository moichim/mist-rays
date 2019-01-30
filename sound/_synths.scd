/**
 * Syntetizátory
 */

(
// DEFINICE SYNŤÁKŮ

// SINE
SynthDef.new(\sine, {
	|freq=440,atk=0.005,rel=0.5, amp=1,pan=0|
	var sig,env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new(
		[0,1,0],
		[atk,rel],
		[1,-1]
	), doneAction:2);
	sig = Pan2.ar(sig,pan,amp);
	sig = sig * env;
	Out.ar(0,sig);
}).add;

// BPFsaw
SynthDef(\bpfsaw,{
	arg out=0, rq=0.2, cf=1500, cfmin=500, cfmax=2000, cfhzmin=0.1, cfhzmax=0.3, rqmin=0.1, rqmax=0.2, amp=1, freq=500, detune=0.2, atk=2, sus=0, rel=3, c1=1, c2=(-1), pan=0,lsf=200, ldb=2, t_jump=0.2, jumpDuration=1, jumpAmount=0.5;
	var sig, jump;
	// env = EnvGen.kr(Env.new([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	jump = EnvGen.ar(Env.new([0,jumpAmount, 0],[jumpDuration/2,jumpDuration/2],[1,1]),t_jump);
	sig = Saw.ar(freq * (1 + jump) * LFNoise1.kr(0.5,detune).midiratio!2);//* {LFNoise1.kr(0.5,detune).midiratio}!2);
	sig= BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin,cfhzmax)
		).exprange(cfmin,cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin,rqmax)}!2
	)!2;
	sig = BLowShelf.ar(sig,lsf,0.5,ldb);
	sig = BPF.ar(sig,200);
	sig = Pan2.ar(sig,pan);
	sig = sig * amp;
	Out.ar(out,sig);
}).add;

// Jump
SynthDef(\jump,{
	arg freq = 440, dur = 2, amp = 0.2, dist = 1, t_jump=400;
	var sig, env, jump;
	env = EnvGen.kr(Env.new([0,1,0],[dur/2,dur/2],[-3,3]), doneAction:2);
	jump = EnvGen.ar(Env.new([0,4,0],[0.2,2],[1,1]),t_jump);
	sig = SinOsc.ar(freq * (1 + jump));
	sig = sig * env * amp;
	Out.ar(0,sig);
}).add;

)

x = Synth.new(\bpfsaw, [\dur,10]);
x.set(\t_jump,200);
x.set(\freq,80);
x.set(\jumpAmount,1);
x.set(\t_jump,100);
x.set(\jumpDuration,0.2,\t_jump,2);
x.free;

s.plotTree;

Env.new([0,1,0],[3/2,3/2],[-3,3]).plot;


(

~len = 0.25;
~distance = 0.1;
~asp = 2;
Pdef.new(
	\frusciante,
	Pbind.new(
		\instrument, \sine,
		\dur, Pseq([
			~len + ~distance,
			~len + ~distance,
			~len + ~distance,
			~len + ~distance,
			~len/~asp,
			~len/~asp,
			~len/~asp + ~distance,
			~len/~asp,
			~len/~asp,
			~len/~asp + ~distance

		],1),
		\freq, Pseq([
			100,
			200,
			300,
			400,
			800,
			600,
			400,
			800,
			600,
			400,
		],inf),
		\rel, Pseq([
			1,
			1,
			1,
			1,
			1,
			0.5,
			0.5,
			0.5,
			0.5,
			0.5,
		],inf),
	);
).play;
)