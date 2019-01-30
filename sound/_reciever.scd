/**
 * Zpracování signálu
 */

// SPOJENÍ UDP
(

thisProcess.openPorts;
thisProcess.openUDPPort(12000);

n = NetAddr.new("127.0.0.1", 12000);

)


// Verbosing veškerého UDP inputu
OSCFunc.trace(true);
OSCFunc.trace(false);


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

		// Vypánání a zapínání bzukotu
		if (msg[0]=='/swarmStatus') {
			if (msg[1]==1) {
				~swarmOn.value;
			};
			if (msg[1]!=1) {
				~swarmOff.value;
			};
		};
		if (msg[0]=='/swarmJump') {
			~swarmLeft.set(\t_jump,1, \jumpDuration,msg[1]);
			~swarmRight.set(\t_jump,1,\jumpDuration,msg[1]);
		};

		if (msg[0]=='/jumpAmount') {
			~swarmLeft.set(\jumpAmount,msg[1]);
			~swarmRight.set(\jumpAmount,msg[1]);
		};

		// Primární generátor
		if (msg[0]=='/freqL') {
			~swarmLeft.set(\freq,msg[1]);
		};

		if (msg[0]=='/cfL') {
			~swarmLeft.set(\cfmin,msg[1]);
			~swarmLeft.set(\cfmax,msg[2]);
		};
		if (msg[0]=='/cfhzL') {
			~swarmLeft.set(\cfhzmin,msg[1]);
			~swarmLeft.set(\cfhzmax,msg[2]);
		};
		if (msg[0]=='/rqL') {
			~swarmLeft.set(\rqmin,msg[1]);
			~swarmLeft.set(\rqmax,msg[2]);
		};
		if (msg[0]=='/ldbL') {
			~swarmLeft.set(\ldb,msg[1]);
		};

		// Sekundární generátor
		if (msg[0]=='/freqR') {
			~swarmRight.set(\freq,msg[1]);
		};
		if (msg[0]=='/cfR') {
			~swarmRight.set(\cfmin,msg[1]);
			~swarmRight.set(\cfmax,msg[2]);
		};
		if (msg[0]=='/cfhzR') {
			~swarmRight.set(\cfhzmin,msg[1]);
			~swarmRight.set(\cfhzmax,msg[2]);
		};
		if (msg[0]=='/rqR') {
			~swarmRight.set(\rqmin,msg[1]);
			~swarmRight.set(\rqmax,msg[2]);
		};
		if (msg[0]=='/ldbR') {
			~swarmRight.set(\ldb,msg[1]);
		};

		// Globální kontrolky
		if (msg[0]=='/aspect') {
			~swarmRight.set(\amp,msg[1]);
			~swarmLeft.set(\amp,0.8-msg[1]);
		};

	}
};
thisProcess.addOSCRecvFunc(f);
)


// ODSTRANIT FCI Z UDP
thisProcess.removeOSCRecvFunc(f);
