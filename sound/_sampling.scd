(
// strunné nástroje
~string = Buffer.readChannel(s, "/Users/jan.jachim/Documents/Processing/souzvon/sound/samples/string_cut.wav",channels:[0]);
// hvězdy
~star1 = Buffer.readChannel(s, "/Users/jan.jachim/Documents/Processing/souzvon/sound/samples/star_1.aiff", channels:[0]);
~star2 = Buffer.readChannel(s, "/Users/jan.jachim/Documents/Processing/souzvon/sound/samples/star_2.aiff", channels:[0]);
~star3 = Buffer.readChannel(s, "/Users/jan.jachim/Documents/Processing/souzvon/sound/samples/star_3.aiff", channels:[0]);
// magické hlasy
~magic_1 = Buffer.readChannel(s, "/Users/jan.jachim/Documents/Processing/souzvon/sound/samples/vocal_ending_magical.aiff", channels:[0]);
~magic_2 = Buffer.readChannel(s, "/Users/jan.jachim/Documents/Processing/souzvon/sound/samples/vocal_ending_romantical.aiff", channels:[0]);
// bubny
~bass_drum = Buffer.readChannel(s, "/Users/jan.jachim/Documents/Processing/souzvon/sound/samples/bass_drum.aiff", channels:[0]);
~war_drum = Buffer.readChannel(s, "/Users/jan.jachim/Documents/Processing/souzvon/sound/samples/war_drum.aiff", channels:[0]);
~symphony_drum = Buffer.readChannel(s, "/Users/jan.jachim/Documents/Processing/souzvon/sound/samples/symphony_drum.aiff", channels:[0]);
~symphony_drum_bass = Buffer.readChannel(s, "/Users/jan.jachim/Documents/Processing/souzvon/sound/samples/symphony_drum_bass.aiff", channels:[0]);
)

~star1.bufnum;
~star2.bufnum;
~symphony_drum_bass.bufnum;


(
SynthDef.new(\sample, {
	arg amp=1, out=0, pan=0, rate=1, buf;
	var sig;
	sig = PlayBuf.ar(1,buf, BufRateScale.kr(buf) * rate, doneAction:2);
	sig = Pan2.ar(sig,pan);
	sig = sig * amp;
	// sig = FreeVerb.ar(sig,room:1);
	Out.ar(out,sig);
}).add;

)

x = Synth.new(\sample,[\buf, ~star3.bufnum, \rate, 0.4, \pan,-1]);
y = Synth.new(\sample,[\buf, ~star3.bufnum, \rate, 0.7, \pan, 1]);
z = Synth.new(\sample,[\buf, ~string.bufnum, \rate, 01]);

m = Synth.new(\sample,[\buf,~magic_1.bufnum, \amp,2]);
n = Synth.new(\sample,[\buf,~magic_1.bufnum, \amp, 3, \rate,0.4]);

t = Synth.new(\sample,[\buf,~war_drum.bufnum, \rate,1.5]);
u = Synth.new(\sample,[\buf,~symphony_drum_bass.bufnum, \rate,1,\amp,2]);

(
p = Pdef.new(\stars,
	Pbind(
		\instrument, \sample,
		\dur, Prand(#[1,0.5,0.3,2,0.1,0.01],inf),
		\buf, Pxrand([ ~star1.bufnum, ~star2.bufnum, ~star3.bufnum],inf),
		\rate, Prand(#[1,0.5,2,0.7,0.3,0.6],inf),
		\pan, Pxrand(#[-0,1,0,1],inf),
	)
)
)
p.play;
p.stop;

(
b = Pdef.new(\beasts,
	Pbind(
		\instrument, \sample,
		\dur, 1,
		\buf, ~bass_drum.bufnum, //Prand([ ~war_drum.bufnum, ~bass_drum.bufnum],inf),
		\rate, Pxrand(#[1,1.2,1.5,0.9],inf),
		\pan, 1,//Pxrand(#[-0,1,0,1],inf),
		\amp, Env([1,1,0],[10,10],\sine)//1
	)
)
)

b.play;
b.stop;