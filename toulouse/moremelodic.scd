(
Ndef( \rlpfMelody, {
	RHPF.ar( BrownNoise.ar(1),
		\freq.kr(200).lag(0.1) * [1,5/4,3/2],
		\rq.kr(0.1)
	).sum / 3 * \amp.kr(0.1).lag(0.1,0.5) *
	EnvGen.kr( Env.perc, Schmidt.kr( \trigger.kr(0), 0.1, 0.2 ) * Impulse.kr(\rate.kr(10)), timeScale: \dur.kr(0.1) );
} );

Ndef( \rlpfMelody ).addSpec( \lffreq, [ 10, 100, \exponential ] );
Ndef( \rlpfMelody ).addSpec( \width, [ 0.1, 0.5 ] );
Ndef( \rlpfMelody ).addSpec( \freq, [ 8000, 12000, \exponential ] );
Ndef( \rlpfMelody ).addSpec( \amp, [ 0.1, 1, \exponential ] );
Ndef( \rlpfMelody ).addSpec( \rq, [ 0.01, 0.3, \exponential ] );
Ndef( \rlpfMelody ).addSpec( \trig, [ 0, 1, \linear, 1 ] );
Ndef( \rlpfMelody ).addSpec( \trigger, [ 0, 1, \linear ] );
Ndef( \rlpfMelody ).addSpec( \rate, [ 0.01, 10, \exponential ] );
Ndef( \rlpfMelody ).addSpec( \dur, [ 1, 3, \exponential ] );
);

