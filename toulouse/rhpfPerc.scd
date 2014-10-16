(
(
Ndef( \rhpfPerc, {
	RHPF.ar(
		LFPulse.ar( \lffreq.kr(10), 0, \width.kr(0.5) )
		* BrownNoise.ar(1)
		,
		\freq.kr(200).lag(0.1) * [1,5/4,3/2],
		\rq.kr(0.1)
	).sum / 3 * \amp.kr(0.1).lag(0.1,0.5) *
	EnvGen.kr( Env.perc, Schmidt.kr( \trigger.kr(0), 0.1, 0.2 ) * Impulse.kr(\rate.kr(10)), timeScale: \dur.kr(0.1) );
} );

Ndef( \rhpfPerc ).addSpec( \lffreq, [ 10, 100, \exponential ] );
Ndef( \rhpfPerc ).addSpec( \width, [ 0.1, 0.5 ] );
Ndef( \rhpfPerc ).addSpec( \freq, [ 7000, 10000, \exponential ] );
Ndef( \rhpfPerc ).addSpec( \amp, [ 0.1, 1, \exponential ] );
Ndef( \rhpfPerc ).addSpec( \rq, [ 0.01, 0.3, \exponential ] );
Ndef( \rhpfPerc ).addSpec( \trig, [ 0, 1, \linear, 1 ] );
Ndef( \rhpfPerc ).addSpec( \trigger, [ 0, 1, \linear ] );
Ndef( \rhpfPerc ).addSpec( \rate, [ 0.01, 10, \exponential ] );
Ndef( \rhpfPerc ).addSpec( \dur, [ 0.1, 2, \exponential ] );
);

Ndef( \rhpfPerc ).play(1);

(
~accs[0].addAction( \stdMapped, \rlpfPerc, { |data|
	// data.postln;
	Ndef( \rhpfPerc ).set( \trigger, data.sum );
});
);

~influxes[0].attachMapped(Ndef(\rhpfPerc), Ndef(\rhpfPerc).key, Ndef(\rhpfPerc).controlKeys.select{ |it| it != \trigger } );
);
