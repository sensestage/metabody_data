NdefMixer.new(s);

(
Ndef( \rlpf, {
	RLPF.ar(
		LFPulse.ar( \lffreq.kr(10), 0, \width.kr(0.5) ),
		\freq.kr(200).lag(0.1),
		\rq.kr(0.1)
	) * \amp.kr(0.1).lag(0.1,0.5);
} );

Ndef( \rlpf ).addSpec( \lffreq, [ 10, 100, \exponential ] );
Ndef( \rlpf ).addSpec( \width, [ 0.1, 0.5 ] );
Ndef( \rlpf ).addSpec( \freq, [ 1200, 4000, \exponential ] );
Ndef( \rlpf ).addSpec( \amp, [ 0.01, 0.8, \exponential ] );
Ndef( \rlpf ).addSpec( \rq, [ 0.01, 0.3, \exponential ] );
);

Ndef( \rlpf ).play(1);

~influxes[0].attachMapped( Ndef( \rlpf ) );

/*
(
~accs[0].addAction( \accMapped, \rlpf, { |data|
	Ndef( \rlpf ).setUni( \freq, data[0] );
	Ndef( \rlpf ).setUni( \width, data[1] );
	Ndef( \rlpf ).setUni( \lffreq, data[2] );
});

~accs[0].addAction( \stdMapped, \rlpf, { |data|
	Ndef( \rlpf ).setUni( \amp, data[0] );
	Ndef( \rlpf ).setUni( \rq, data[1] );
});
);


~accs[0].disableAction( \accMapped, \rlpf );
~accs[0].disableAction( \stdMapped, \rlpf );
*/

(
(
Ndef( \rlpfPerc, {
	RHPF.ar(
		LFPulse.ar( \lffreq.kr(10), 0, \width.kr(0.5) )
		* BrownNoise.ar(1)
		,
		\freq.kr(200).lag(0.1) * [1,5/4,3/2],
		\rq.kr(0.1)
	).sum / 3 * \amp.kr(0.1).lag(0.1,0.5) *
	EnvGen.kr( Env.perc, Schmidt.kr( \trigger.kr(0), 0.8, 1 ), timeScale: \dur.kr(0.1) );
} );

Ndef( \rlpfPerc ).addSpec( \lffreq, [ 10, 100, \exponential ] );
Ndef( \rlpfPerc ).addSpec( \width, [ 0.1, 0.5 ] );
Ndef( \rlpfPerc ).addSpec( \freq, [ 1500, 10000, \exponential ] );
Ndef( \rlpfPerc ).addSpec( \amp, [ 0.1, 1, \exponential ] );
Ndef( \rlpfPerc ).addSpec( \rq, [ 0.01, 0.3, \exponential ] );
Ndef( \rlpfPerc ).addSpec( \trig, [ 0, 1, \linear, 1 ] );
Ndef( \rlpfPerc ).addSpec( \trigger, [ 0, 1, \linear ] );
Ndef( \rlpfPerc ).addSpec( \rate, [ 0.01, 10, \exponential ] );
Ndef( \rlpfPerc ).addSpec( \dur, [ 0.1, 2, \exponential ] );
);

Ndef( \rlpfPerc ).play(1);

(
~accs[0].addAction( \stdMapped, \rlpfPerc, { |data|
	// data.postln;
	Ndef( \rlpfPerc ).set( \trigger, data.sum );
});
);

~influxes[0].attachMapped( Ndef( \rlpfPerc ) );

~influxes[0].attachMapped(Ndef(\rlpfPerc), Ndef(\rlpfPerc).key, Ndef(\rlpfPerc).controlKeys.select{ |it| it != \trigger } );
);


~influxes[0].rand
