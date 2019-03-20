s.boot;
s.quit;
s.plotTree;
s.meter;

s.freeAll;


(
// NASTAVIT SPOJENÍ

thisProcess.openPorts;
thisProcess.openUDPPort(12000);

n = NetAddr.new("127.0.0.1", 12000);
)





(
// BPFsaw
SynthDef(\bpfsaw,{
	arg out=0,rq=0.2,cf=1500,cfmin=500,cfmax=2000,cfhzmin=0.1,cfhzmax=0.3,rqmin=0.1,rqmax=0.2,amp=1,freq=500,detune=0.2,atk=2,sus=0,rel=3,c1=1,c2=(-1),pan=0,lsf=200,ldb=0;
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
	//sig = BLowShelf.ar(sig,lsf,0.5,ldb);
	sig = BPF.ar(sig,200);
	sig = Pan2.ar(sig,pan);
	sig = sig * amp;
	Out.ar(out,sig);
}).add;

)

x = Synth.new(\bpfsaw);
x.set(\freq,20);
x.set(\freq,7);
x.set(\cfmin,300);
x.set(\cfmax,5000);
x.set(\rqmin,0.1);
x.set(\rqmax,0.2);

x.free;

~standard = Synth.new(\bpfsaw);
~standard.set();
~standard.free;

~suppl = Synth.new(\bpfsaw);


// FCE ZPRACUJÍCI PŘÍCHOZÍ ZPRÁVY
(
f = {
	|msg, time, addr|
	if (msg[0] != '/status.reply') {
		"time: % sender: %\nmessage: %\n".postf(time,addr,msg);

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