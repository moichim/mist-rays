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
	if ( ( msg[0] != '/status.reply' )
		&& ( msg[0] != '/n_go' )
		&& ( msg[0] != '/n_end' )
		&& ( msg[0]  != '/localhostInLevels' )
		&& ( msg[0] != '/localhostOutLevels' )
	) {
		// "time: % sender: %\nmessage: %\n".postf(time,addr,msg);

		// Příchozí zvuk zvonu
		if (msg[0]=='/bell') {
			d = Synth.new(\sine, [\pitch, msg[1], \amp, msg[2], \dur, msg[3], \panX, msg[4],\panY, msg[5]]);
		};

		// Příchozí zvuk cinkotu
		if (msg[0]=='/sine') {
			d = Synth.new(\sine, [\freq, msg[1], \atk, msg[2], \rel, msg[3], \amp, msg[4],\pan, msg[5]]);
		};

		// Příchozí zvuk samplovaný
		if (msg[0]=='/sample') {
			d = Synth.new(\sample, [\buf, msg[1], \amp, msg[2], \rate, msg[3], \pan, msg[4]]);
		};
		// Příchozí zvuk samplovaný
		if (msg[0]=='/playbuf') {
			d = Synth.new(\playbuf, [\buf, msg[1], \amp, msg[2], \rate, msg[3], \pan, msg[4],\out,~reverbBusMedium], \envTimeAtk, msg[5],\envAtk, msg[6]);
		};

	}
};
thisProcess.addOSCRecvFunc(f);
)


// ODSTRANIT FCI Z UDP
thisProcess.removeOSCRecvFunc(f);
