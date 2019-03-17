/**
 * Syntetizátory
 */

(
// DEFINICE SYNŤÁKŮ

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
		arg amp=1,pan=0,out=0,buf;
		var sig;
		sig = PlayBuf.ar(1,buf,doneAction:2);
		sig = Pan2.ar(sig,pan);
		sig = sig * amp;
		Out.ar( out, sig );
	}
).add;

// Reverb
SynthDef.new(\reverb,{
	arg in, out=0;
	var sig;
	sig = In.ar(in,2);
	sig = FreeVerb.ar(sig, 0.5,0.8,0.2);
	Out.ar(out,sig);
}).add;

)
