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


// Načtení bufferů
(

//
// Prvnotní nastavení
//


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
	\damp, 0.9,
	\mul, 1.5
],~effects);
k = Synth.new(\reverb,[
	\in,~reverbBusHeavy.index,
	\room, 1,
	\mix, 0.5,
	\damp, 0.9,
	\mul, 2
],~effects);

)

// Nastavovací metody reverbu
j.set(\room,0.9,\damp,0.5,\mix,0.6,\mul,1.7);
j.free;
~effects.freeAll;

// Testy
x = Synth.new(\sine,[\freq,600,\rel,1, \out,~reverbBusMedium],~sounds);
x = Synth.new(\sine,[\freq,600,\rel,1]);
x = Synth.new(\playbuf,[\out,~reverbBusLight,\buf,150,\rate,1.5],~sounds);

(
d = Pdef.new(\test,Pbind.new(
	\instrument, \playbuf,
	\buf, 15 + Pxrand([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14],inf),
	\dur, Pwhite(0.1,0.5,inf),
	\pan, Pwhite(-1,1,inf),
	\out, ~reverbBusMedium,
	\group, ~sounds
))
)
d.play;
d.stop;