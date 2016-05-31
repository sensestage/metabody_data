(
Ndef( \phasor, {
	var phasor1, phasor2, sig, freq;
	freq = \freq.kr(300);
	freq = freq* SinOsc.ar( 0.01, 0, 0.1, 1 );
	phasor1 = Phasor.ar( 0, (freq + \dfreq.kr(1))/SampleRate.ir * [1,5/4+(0.1.rand),2/3+(0.1.rand)], -1, 1 );
	phasor2 = Phasor.ar( 0, freq/SampleRate.ir * [1,5/4+(0.1.rand),2/3+(0.1.rand)], -1, 1 );
	sig = Pan2.ar(
		RHPF.ar(
			RLPF.ar(
				phasor1 - phasor2 * \amp.kr(0.1).lag(0.1),
				\ffreq.kr(1000) * SinOsc.ar( \fmfrq.kr(10), 0, \fmmul.kr(0.1), 1 ),
				\rq.kr(0.1)
			),
			\hfreq.kr(100), \hrq.kr(0.1)
		).sum,
		\pos.kr(0), 0.8 ) * \fade.kr(1,1);
});
);

(
Ndef( \phasor ).addSpec( \delay, [ 0.05,0.2, \exp ].asSpec );
Ndef( \phasor ).addSpec( \decay, [ 0.1,1, \exp ].asSpec );

Ndef( \phasor ).addSpec( \rate, [ 10,1, \exp ].asSpec );
Ndef( \phasor ).addSpec( \dur, [ 1,0.1, \exp ].asSpec );

Ndef( \phasor ).addSpec( \ffreq, [ 2000, 9000, \exp ].asSpec );
Ndef( \phasor ).addSpec( \amp, [ 0.02, 1, \exp ].asSpec );
Ndef( \phasor ).addSpec( \fmmul, [ 0.01, 0.1, \exp ].asSpec );

Ndef( \phasor ).addSpec( \fmfreq, [ 1, 200, \exp ].asSpec );

Ndef( \phasor ).addSpec( \dfreq, [ 0.05, 1, \exp ].asSpec );

Ndef( \phasor ).addSpec( \ffreq, [ 500, 9000, \exp ].asSpec );
Ndef( \phasor ).addSpec( \hfreq, [ 10, 200, \exp ].asSpec );
Ndef( \phasor ).addSpec( \rq, [ 0.1, 0.01, \exp ].asSpec );
Ndef( \phasor ).addSpec( \hrq, [ 0.1, 0.01, \exp ].asSpec );
Ndef( \phasor ).addSpec( \pos, [ -1, 1 ].asSpec );
Ndef( \phasor ).addSpec( \freq, [ 100, 1000, \exp ].asSpec );
Ndef( \phasor ).addSpec( \amp, [ 0.01, 0.3, \exp ].asSpec );
);


Ndef( \phasor ).play( 4, vol: 0.025);
Ndef( \phasor ).fadeTime_( 2 );

a.resetMap;
a.sound = Ndef( \phasor );

Ndef( \pulse ).stop(2);

a.addPar( \x, \pos );
a.addPar( \y, \rate );
a.addPar( \z, \fmfreq );

a.addPar( \x, \ffreq );
a.addPar( \y, \freq );
a.addPar( \z, \hfreq );

a.addPar( \dy, \fmmul );
a.addPar( \dy, \rq );

a.addPar( \dx, \hrq );
a.addPar( \dx, \dur );
a.addPar( \dx, \delay );

a.addPar( \dz, \rate );
a.addPar( \dz, \decay );

a.addPar( \dy, \dfreq );
a.addPar( \dz, \dfreq );
a.addPar( \dx, \dfreq );

a.addPar( \dx, \amp );
a.addPar( \dy, \amp );
a.addPar( \dz, \amp );

a.kmap.addRound( \y, 0.1, \freq );
a.kmap.addRound( \x, 0.1, \ffreq );
a.kmap.addRound( \z, 0.1, \hfreq );

Ndef( \phasor ).stop(2);