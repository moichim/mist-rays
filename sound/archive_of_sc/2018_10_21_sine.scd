s.boot;
s.reboot;
s.quit;

s.plotTree;
s.meter;
s.queryAllNodes;

s.freeAll;




OSCFunc.trace(true);
OSCFunc.trace(false);



~standard = x;
~standard.play;
~suppl;
~standard.free;
~suppl.free;

(
~standard = Synth.newPaused(\bpfsaw,[
		\freq, 22.5,
		\cfmin,60,
		\cfmax,1213,
		\rqmin,0.01,
		\rqmax,1,
		\amp,0.5,
	]);
)

~standard.run;

(
// FCE ZPRACUJÍCI PŘÍCHOZÍ ZPRÁVY
f = {
	|msg, time, addr|
	if (msg[0] != '/status.reply') {
		"time: % sender: %\nmessage: %\n".postf(time,addr,msg);

		// Příchozí zvuk zvonu
		if (msg[0]=='/bell') {
			d = Synth.new(\sine, [\pitch, msg[1], \amp, msg[2], \dur, msg[3], \panX, msg[4],\panY, msg[5]]);
		};

		// Příchozí zvuk cinkotu
		if (msg[0]=='/sine') {
			d = Synth.new(\sine, [\freq, msg[1], \atk, msg[2], \rel, msg[3], \amp, msg[4],\pan, msg[5]]);
		};

		// Příchozí značka start bzukotu
		if (msg[0]=='/bzukot') {
			~standard = Synth.new(\bpfsaw,[
				\freq, 22.5,
				\cfmin,10,
				\cfmax,1213,
				\rqmin,0.01,
				\rqmax,1,
				\amp,0.5,
			]);
			~suppl = Synth.new(\bpfsaw,[
				\freq, 40,
				\cfmin,288,
				\cfmax,686,
				\rqmin,0.01,
				\rqmax,0.17,
				\amp,0.5,
			]);
		};


		// Primární generátor
		if (msg[0]=='/freq') {
			~standard.set(\freq,msg[1]);
		};

		if (msg[0]=='/cf') {
			~standard.set(\cfmin,msg[1]);
			~standard.set(\cfmax,msg[2]);
		};
		if (msg[0]=='/cfhz') {
			~standard.set(\cfhzmin,msg[1]);
			~standard.set(\cfhzmax,msg[2]);
		};
		if (msg[0]=='/rq') {
			~standard.set(\rqmin,msg[1]);
			~standard.set(\rqmax,msg[2]);
		};
		if (msg[0]=='/ldb') {
			~standard.set(\ldb,msg[1]);
		};

		// Sekundární generátor
		if (msg[0]=='/freqS') {
			~suppl.set(\freq,msg[1]);
		};

		if (msg[0]=='/cfS') {
			~suppl.set(\cfmin,msg[1]);
			~suppl.set(\cfmax,msg[2]);
		};
		if (msg[0]=='/cfhzS') {
			~suppl.set(\cfhzmin,msg[1]);
			~suppl.set(\cfhzmax,msg[2]);
		};
		if (msg[0]=='/rqS') {
			~suppl.set(\rqmin,msg[1]);
			~suppl.set(\rqmax,msg[2]);
		};
		if (msg[0]=='/ldbS') {
			~standard.set(\ldb,msg[1]);
		};

		// Globální kontrolky
		if (msg[0]=='/aspect') {
			~suppl.set(\amp,msg[1]);
			~standard.set(\amp,1-msg[1]);
		};

	}
};
thisProcess.addOSCRecvFunc(f);
)
// ODSTRANIT FCI Z UDP
thisProcess.removeOSCRecvFunc(f);

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
	arg out=0,rq=0.2,cf=1500,cfmin=500,cfmax=2000,cfhzmin=0.1,cfhzmax=0.3,rqmin=0.1,rqmax=0.2,amp=1,freq=500,detune=0.2,atk=2,sus=0,rel=3,c1=1,c2=(-1),pan=0,lsf=200,ldb=2;
	var sig;
	// env = EnvGen.kr(Env.new([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq * {LFNoise1.kr(0.5,detune).midiratio}!2);
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

)
s.reboot;
s.freeAll;
s.plotTree;
rand(10) * 5;
(
y = 3.do{
	Synth.new(\sine,[
		\freq,rand(10) * 20,
		\death,100,
		\detune,1,
		\amp, 0.5,
	]);

}
)

y.set();
z = Synth.new(\sine,[\tempo,8]);

(
Pdef(
	\bell,
	Pbind(
		\instrument, \sine,
		\freq, Pwhite(150,400,inf),
		\dur, Pwhite(0.05,0.5,inf),
		\pan, Pexprand([-1,1],4),
		\rel, Pwhite(0.5,1,inf),
	)
).stop;
)

// Test synťáků
x = Synth.new(\sine,[\freq,200]);
(
10.do({
	Synth.new(\sine,[\freq,200]);
});
)

(
// Catterpillar
SynthDef(\sawtooth,{
	arg out=0, pan=0, amp=0.5, // technické věci
	freq=500, // Centrální frekvence BPF
	freqFallout=100, // Spad centrální frekvence
	freqCurve=(-3), // Prohnutí hlavní křivky
	width=0.2, // bandwith/cutoff
	mainFrequency=500, // nosná frekvence
	detuneFreq = 20, // Randomizující frekvence
	detuneAmount = 0, // Množství randomizující frekvence
	detuneWidth = 0.25, // O kolik bude detune běžet
	//width = 0.2, // Ššířka filtru
	vibratoAmount=0, // mára vibrata nosné frekvence
	vibratoFreq=4, // tempo šumu vibrata
	vibratoWidth=50, // amplituda vibrata
	atk=0.01, sus=0.2, rel=3, // čas frekvence
	death=5;
	var sig, env, bpfEnv;
	sig = Saw.ar(
		mainFrequency * { LFNoise1.ar(
			detuneFreq,
			detuneAmount).exprange(1,1+detuneWidth) }
	);
	env = EnvGen.kr(Env.new([0,1,1,0],[atk,sus,rel]),doneAction:2);
	bpfEnv = EnvGen.kr(Env.new(
		[freq+freqFallout,freq],
		[atk+sus+rel],
		[freqCurve])
	);
	sig = BPF.ar(
		sig,
		bpfEnv, // Zde se bere hlavní frekvence z toho, co bude slyšet
		width * SinOsc.ar(vibratoFreq,vibratoAmount).exprange(1,1+vibratoWidth)
	);
	sig = sig * env * amp;
	sig = Pan2.ar(sig,pan);
	Out.ar(out,sig);
}).add;
)

x = Synth.new(\sawtooth);
x = Synth.new(\sawtooth,[\mainFrequency,100]);

(
x = 5.do{
	Synth.new(\sawtooth,[
		\sus,0,
		\rel,3,
		\amp,1,
		\freq, 60,
		\mainFrequency, 160,
		\width, 0.01,
		\detuneAmount, 0,
		\vibratoWidth, rand(5,80),
		\freqCurve, rand(0,5),
		\freqFallout, 5000,
		\amp, 0.1
])};
)

(
Pdef.new(
	\cirkularka,
	Pbind(
		\instrument, \sawtooth,
		\dur, 5,
		\sus, 0,
		\rel, 3,
		\amp, 1,
		\freq, Pseq([60],inf),
		\mainFrequency,  160,
		\width, 0.01,
		\detuneAmount, 0,//Pseq([0,0.5,1],2),
		//\vibratoFreq, 1,
		\vibratoWidth, Pseq([0,5,10,30,50,80],inf),
		\freqCurve, (-2),
		\freqFallout, 5000,
	)
).stop;
)