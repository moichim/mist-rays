// Kontrola serveru
s.boot;
s.reboot;
s.quit;

s.plotTree; // zobrazí nody a skupiny
s.meter; // Zobrazí metr
s.queryAllNodes; // Vypíše všechny nody

s.freeAll;



// Globální proměnné
(

~swarmLeft = Synth.newPaused(\bpfsaw,[
	\freq, 22.5,
	\cfmin,60,
	\cfmax,1213,
	\rqmin,0.01,
	\rqmax,1,
	\amp,0.5,
]);
~swarmRight = Synth.newPaused(\bpfsaw,[
	\freq, 40,
	\cfmin,288,
	\cfmax,686,
	\rqmin,0.01,
	\rqmax,0.17,
	\amp,0.5,
]);

// Kontrolní funkce
~swarmOff = {
	~swarmLeft.run(false);
	~swarmRight.run(false);
};

~swarmOn = {
	~swarmLeft.run();
	~swarmRight.run()
};

)

// Test
x = Synth.new(\sine,[\freq,600,\rel,1]);
x.set(\t_gate,4);
~swarmOn.value;
~swarmOff.value;