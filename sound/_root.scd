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
~reverbBus = Bus.audio(s,2);

//
// Načtení Bufferů
//


~buffers = Array.new; // Inicializace pole pro buffery
~mode = "raw"; // nastavit režim přehrávání rev / raw

// Kořenová složka pro finální buffery
~rootFolder = PathName.new( "C:/Data/sketchbook/project_mist_rays/sound/lahoda_samples" );

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
y = Synth.new(\reverb,[\in,~reverbBus.index]);


// Test
x = Synth.new(\sine,[\freq,600,\rel,1, \out,~reverbBus]);
x = Synth.new(\sine,[\freq,600,\rel,1]);
x.set(\t_gate,4);
x = Synth.new(\playbuf,[\out,~reverbBus,\buf,144]);

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