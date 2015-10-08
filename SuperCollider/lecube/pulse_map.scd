a.initKMap;
a.removeMapping
a.mapToSound;
a.sound

// a.removeMapping;
// a.dump


(
Ndef( \pulse, {
	var sig;
	sig = Pan2.ar(
		RHPF.ar(
			RLPF.ar(
				LFPulse.ar( \freq.kr(100).lag(0.2)*[1,5/4,3/4], 0, \width.kr(0.5), \amp.kr(0.1) ),
				\ffreq.kr(1000).lag(0.2)*[1,5/4,2/3] * SinOsc.ar( \fmfreq.kr(10), 0, \fmmul.kr(0.1), 1 ),
				\rq.kr(0.1)
			),
			\hfreq.kr(100)*[1,5/4,2/3], \hrq.kr(0.1) ).sum,
		\pos.kr(0), 0.8 ) * \fade.kr(1,1);
	sig = sig * EnvGen.kr( Env.perc, Dust.kr( \rate.kr(1) ), timeScale: \dur.kr(1) );
	CombC.ar( sig, 1.0, \delay.kr(0.3), \decay.kr(2) )
});
);

(
Ndef( \pulse ).addSpec( \delay, [ 0.05,0.2, \exp ].asSpec );
Ndef( \pulse ).addSpec( \decay, [ 0.1,1, \exp ].asSpec );

Ndef( \pulse ).addSpec( \rate, [ 10,100, \exp ].asSpec );
Ndef( \pulse ).addSpec( \dur, [ 0.2,0.05, \exp ].asSpec );

Ndef( \pulse ).addSpec( \width, [ 0.1,0.9 ].asSpec );

Ndef( \pulse ).addSpec( \ffreq, [ 9000, 500, \exp ].asSpec );
Ndef( \pulse ).addSpec( \fmmul, [ 0.5, 0.02, \exp ].asSpec );
Ndef( \pulse ).addSpec( \fmfreq, [ 0.2, 100, \exp ].asSpec );
Ndef( \pulse ).addSpec( \hfreq, [ 50, 200, \exp ].asSpec );
Ndef( \pulse ).addSpec( \rq, [ 0.2, 0.03, \exp ].asSpec );
Ndef( \pulse ).addSpec( \hrq, [ 0.01, 0.2, \exp ].asSpec );
Ndef( \pulse ).addSpec( \pos, [ -1, 1 ].asSpec );
Ndef( \pulse ).addSpec( \freq, [ 600, 100, \exp ].asSpec );
Ndef( \pulse ).addSpec( \amp, [ 0.02, 0.3, \exp ].asSpec );
Ndef( \pulse ).addSpec( \dfreq, [ 0.1, 40, \exp ].asSpec );
);


Ndef( \pulse ).fadeTime_( 2 );
Ndef( \pulse ).play( vol: 0.1 );
b.sound = Ndef( \pulse );

/// kmap
a.kmap.removePar( \x, \freq );
a.kmap.removePar( \y, \freq );
a.kmap.removePar( \z, \freq );


b.addPar( \x, \rate );
b.addPar( \y, \ffreq );
a.kmap.removePar( \y, \ffreq );
a.kmap.removePar( \z, \fmfreq );
b.addPar( \z, \fmfreq );

b.addPar( \mx, \hfreq );
b.addPar( \my, \width );
b.addPar( \mz, \dur );
b.addPar( \mz, \fmmul );

b.addPar( \fix, \freq );
b.addPar( \fiy, \freq );
b.addPar( \fiz, \freq );

b.addPar( \fox, \ffreq );
b.addPar( \foy, \ffreq );
b.addPar( \foz, \ffreq );

b.addPar( \dx, \decay );
b.addPar( \dy, \decay );
b.addPar( \dy, \delay );
b.addPar( \dz, \delay );

b.addPar( \dx, \amp );
b.addPar( \dy, \amp );
b.addPar( \dz, \amp );

b.addPar( \dz, \hfreq );

b.addPar( \dx, \hrq );
b.addPar( \dy, \rq );
b.addPar( \dz, \dfreq );


a.kmap.parameterMap
~accs[1].addAction( \stddev, \test, { |v| v.postln; } );
~accs[1].removeAction( \stddev, \test);


~accs[1].network.nodes[3].action.orderedNames
b.accelero.makeGui;

