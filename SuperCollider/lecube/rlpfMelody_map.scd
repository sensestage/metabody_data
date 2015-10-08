(
Ndef( \rlpfMelody, {
	var triggerGate = Schmidt.ar( \trigger.kr(0), 0.01, 0.05 ) * Dust.ar(\rate.kr(10));
	var freq = Trig.ar( triggerGate, \freq.kr(200).lag(0.1) );
	RHPF.ar( BrownNoise.ar(1),
		 freq * [1,5/4,3/2],
		\rq.kr(0.1)
	).sum / 3 * \amp.kr(0.1).lag(0.1,0.5) *
	EnvGen.ar( Env.perc, triggerGate, timeScale: \dur.kr(0.1) );
} );

Ndef( \rlpfMelody ).addSpec( \lffreq, [ 10, 100, \exponential ] );
Ndef( \rlpfMelody ).addSpec( \width, [ 0.1, 0.5 ] );
Ndef( \rlpfMelody ).addSpec( \freq, [ 7000, 12000, \exponential ] );
Ndef( \rlpfMelody ).addSpec( \amp, [ 0.1, 1, \exponential ] );
Ndef( \rlpfMelody ).addSpec( \rq, [ 0.1, 0.05, \exponential ] );
Ndef( \rlpfMelody ).addSpec( \trig, [ 0, 1.0, \linear ] );
Ndef( \rlpfMelody ).addSpec( \trigger, [ 0, 1, \linear ] );
Ndef( \rlpfMelody ).addSpec( \rate, [ 1, 20, \exponential ] );
Ndef( \rlpfMelody ).addSpec( \dur, [ 0.04, 1, \exponential ] );
);


c.sound = Ndef( \rlpfMelody );
Ndef( \rlpfMelody ).play( vol: 0.2 );

c.addPar( \x, \lffreq );
c.addPar( \y, \freq );

c.addPar( \dx, \trigger );
c.addPar( \dy, \trigger );
c.addPar( \dz, \trigger );

c.addPar( \dx, \rate );
c.addPar( \dz, \rq );

c.addPar( \dx, \rate );
c.addPar( \dy, \dur );
c.addPar( \dz, \amp );

c.accelero.makeGui;
