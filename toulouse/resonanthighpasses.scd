(
(
Ndef( \rlpfPerc1, {
	RHPF.ar(
		LFPulse.ar( \lffreq.kr(10), 0, \width.kr(0.5) )
		* BrownNoise.ar(1)
		,
		\freq.kr(200).lag(0.1) * [1,5/4,3/2],
		\rq.kr(0.1)
	).sum / 3 * \amp.kr(0.1).lag(0.1,0.5) *
	EnvGen.kr( Env.perc, Schmidt.kr( \trigger.kr(0), 0.1, 0.2 ) * Impulse.kr(\rate.kr(10)), timeScale: \dur.kr(0.1) );
} );

Ndef( \rlpfPerc1 ).addSpec( \lffreq, [ 10, 100, \exponential ] );
Ndef( \rlpfPerc1 ).addSpec( \width, [ 0.1, 0.5 ] );
Ndef( \rlpfPerc1 ).addSpec( \freq, [ 7000, 10000, \exponential ] );
Ndef( \rlpfPerc1 ).addSpec( \amp, [ 0.1, 1, \exponential ] );
Ndef( \rlpfPerc1 ).addSpec( \rq, [ 0.01, 0.3, \exponential ] );
Ndef( \rlpfPerc1 ).addSpec( \trig, [ 0, 1, \linear, 1 ] );
Ndef( \rlpfPerc1 ).addSpec( \trigger, [ 0, 1, \linear ] );
Ndef( \rlpfPerc1 ).addSpec( \rate, [ 0.01, 10, \exponential ] );
Ndef( \rlpfPerc1 ).addSpec( \dur, [ 0.1, 2, \exponential ] );
);

Ndef( \rlpfPerc1 ).play(1);

(
~accs[0].addAction( \stdMapped, \rlpfPerc, { |data|
	// data.postln;
	Ndef( \rlpfPerc1 ).set( \trigger, data.sum );
});
);

~influxes[0].attachMapped(Ndef(\rlpfPerc1), Ndef(\rlpfPerc1).key, Ndef(\rlpfPerc1).controlKeys.select{ |it| it != \trigger } );
);


(
(
Ndef( \rlpfPerc5, {
	RHPF.ar(
		LFPulse.ar( \lffreq.kr(10), 0, \width.kr(0.5) )
		* BrownNoise.ar(1)
		,
		\freq.kr(200).lag(0.1) * [1,5/4,3/2],
		\rq.kr(0.1)
	).sum / 3 * \amp.kr(0.1).lag(0.1,0.5) *
	EnvGen.kr( Env.perc, Schmidt.kr( \trigger.kr(0), 0.1, 0.2 ) * Impulse.kr( \rate.kr(10)), timeScale: \dur.kr(0.1) );
} );

Ndef( \rlpfPerc5 ).addSpec( \lffreq, [ 10, 100, \exponential ] );
Ndef( \rlpfPerc5 ).addSpec( \width, [ 0.1, 0.5 ] );
Ndef( \rlpfPerc5 ).addSpec( \freq, [ 1000, 3000, \exponential ] );
Ndef( \rlpfPerc5 ).addSpec( \amp, [ 0.1, 1, \exponential ] );
Ndef( \rlpfPerc5 ).addSpec( \rq, [ 0.01, 0.3, \exponential ] );
Ndef( \rlpfPerc5 ).addSpec( \trig, [ 0, 1, \linear, 1 ] );
Ndef( \rlpfPerc5 ).addSpec( \trigger, [ 0, 1, \linear ] );
Ndef( \rlpfPerc5 ).addSpec( \rate, [ 0.01, 10, \exponential ] );
Ndef( \rlpfPerc5 ).addSpec( \dur, [ 0.1, 2, \exponential ] );
);

Ndef( \rlpfPerc5 ).play(1);

(
~accs[1].addAction( \stdMapped, \rlpfPerc, { |data|
	// data.postln;
	Ndef( \rlpfPerc5 ).set( \trigger, data.sum );
});
);

~influxes[1].attachMapped(Ndef(\rlpfPerc5), Ndef(\rlpfPerc5).key, Ndef(\rlpfPerc5).controlKeys.select{ |it| it != \trigger } );
);


(
(
Ndef( \rlpfPerc6, {
	RHPF.ar(
		LFPulse.ar( \lffreq.kr(10), 0, \width.kr(0.5) )
		* BrownNoise.ar(1)
		,
		\freq.kr(200).lag(0.1) * [1,5/4,3/2],
		\rq.kr(0.1)
	).sum / 3 * \amp.kr(0.1).lag(0.1,0.5) *
	EnvGen.kr( Env.perc, Schmidt.kr( \trigger.kr(0), 0.1, 0.2 ) * Impulse.kr(\rate.kr(10)), timeScale: \dur.kr(0.1) );
} );

Ndef( \rlpfPerc6 ).addSpec( \lffreq, [ 10, 100, \exponential ] );
Ndef( \rlpfPerc6 ).addSpec( \width, [ 0.1, 0.5 ] );
Ndef( \rlpfPerc6 ).addSpec( \freq, [ 3000, 6000, \exponential ] );
Ndef( \rlpfPerc6 ).addSpec( \amp, [ 0.1, 1, \exponential ] );
Ndef( \rlpfPerc6 ).addSpec( \rq, [ 0.01, 0.3, \exponential ] );
Ndef( \rlpfPerc6 ).addSpec( \trig, [ 0, 1, \linear, 1 ] );
Ndef( \rlpfPerc6 ).addSpec( \trigger, [ 0, 1, \linear ] );
Ndef( \rlpfPerc6 ).addSpec( \rate, [ 0.01, 10, \exponential ] );
Ndef( \rlpfPerc6 ).addSpec( \dur, [ 0.1, 2, \exponential ] );
);

Ndef( \rlpfPerc6 ).play(1);

(
~accs[2].addAction( \stdMapped, \rlpfPerc, { |data|
	// data.postln;
	Ndef( \rlpfPerc6 ).set( \trigger, data.sum );
});
);

~influxes[2].attachMapped(Ndef(\rlpfPerc6), Ndef(\rlpfPerc6).key, Ndef(\rlpfPerc6).controlKeys.select{ |it| it != \trigger } );
);

(
(
Ndef( \rlpfPerc7, {
	RHPF.ar(
		LFPulse.ar( \lffreq.kr(10), 0, \width.kr(0.5) )
		* BrownNoise.ar(1)
		,
		\freq.kr(200).lag(0.1) * [1,5/4,3/2],
		\rq.kr(0.1)
	).sum / 3 * \amp.kr(0.1).lag(0.1,0.5) *
	EnvGen.kr( Env.perc, Schmidt.kr( \trigger.kr(0), 0.1, 0.2 ) * Impulse.kr( \rate.kr(1)), timeScale: \dur.kr(0.1) );
} );

Ndef( \rlpfPerc7 ).addSpec( \lffreq, [ 10, 100, \exponential ] );
Ndef( \rlpfPerc7 ).addSpec( \width, [ 0.1, 0.5 ] );
Ndef( \rlpfPerc7 ).addSpec( \freq, [ 6000, 10000, \exponential ] );
Ndef( \rlpfPerc7 ).addSpec( \amp, [ 0.1, 1, \exponential ] );
Ndef( \rlpfPerc7 ).addSpec( \rq, [ 0.01, 0.3, \exponential ] );
Ndef( \rlpfPerc7 ).addSpec( \trig, [ 0, 1, \linear, 1 ] );
Ndef( \rlpfPerc7 ).addSpec( \trigger, [ 0, 1, \linear ] );
Ndef( \rlpfPerc7 ).addSpec( \rate, [ 0.01, 10, \exponential ] );
Ndef( \rlpfPerc7 ).addSpec( \dur, [ 0.1, 2, \exponential ] );
);

Ndef( \rlpfPerc7 ).play(1);

(
~accs[3].addAction( \stdMapped, \rlpfPerc, { |data|
	// data.postln;
	Ndef( \rlpfPerc7 ).set( \trigger, data.sum );
});
);

~influxes[3].attachMapped(Ndef(\rlpfPerc7), Ndef(\rlpfPerc7).key, Ndef(\rlpfPerc7).controlKeys.select{ |it| it != \trigger } );
);

(
(
Ndef( \rlpfPerc8, {
	RHPF.ar(
		LFPulse.ar( \lffreq.kr(10), 0, \width.kr(0.5) )
		* BrownNoise.ar(1)
		,
		\freq.kr(200).lag(0.1) * [1,5/4,3/2],
		\rq.kr(0.1)
	).sum / 3 * \amp.kr(0.1).lag(0.1,0.5) *
	EnvGen.kr( Env.perc, Schmidt.kr( \trigger.kr(0), 0.1, 0.2 ) * Impulse.kr(\rate.kr(1)), timeScale: \dur.kr(0.1) );
} );

Ndef( \rlpfPerc8 ).addSpec( \lffreq, [ 10, 100, \exponential ] );
Ndef( \rlpfPerc8 ).addSpec( \width, [ 0.1, 0.5 ] );
Ndef( \rlpfPerc8 ).addSpec( \freq, [ 500, 1000, \exponential ] );
Ndef( \rlpfPerc8 ).addSpec( \amp, [ 0.1, 1, \exponential ] );
Ndef( \rlpfPerc8 ).addSpec( \rq, [ 0.01, 0.3, \exponential ] );
Ndef( \rlpfPerc8 ).addSpec( \trig, [ 0, 1, \linear, 1 ] );
Ndef( \rlpfPerc8 ).addSpec( \trigger, [ 0, 1, \linear ] );
Ndef( \rlpfPerc8 ).addSpec( \rate, [ 0.01, 10, \exponential ] );
Ndef( \rlpfPerc8 ).addSpec( \dur, [ 0.1, 2, \exponential ] );
);

Ndef( \rlpfPerc8 ).play(1);

(
~accs[4].addAction( \stdMapped, \rlpfPerc, { |data|
	// data.postln;
	Ndef( \rlpfPerc8 ).set( \trigger, data.sum );
});
);

~influxes[4].attachMapped(Ndef(\rlpfPerc8), Ndef(\rlpfPerc8).key, Ndef(\rlpfPerc8).controlKeys.select{ |it| it != \trigger } );
);


~influxes[4].detach( \rlpfPerc5 );
~influxes[5].detach( \rlpfPerc6 );
~influxes[6].detach( \rlpfPerc7 );
~influxes[7].detach( \rlpfPerc8 );

~accs[4].disableAction( \stdMapped, \rlpfPerc );
~accs[5].disableAction( \stdMapped, \rlpfPerc );
~accs[6].disableAction( \stdMapped, \rlpfPerc );
~accs[7].disableAction( \stdMapped, \rlpfPerc );


(
~influxes[0].rand;
~influxes[1].rand;
~influxes[2].rand;
~influxes[3].rand;
~influxes[4].rand;
);

s.latency_( 0.001 );