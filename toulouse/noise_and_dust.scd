NdefMixer.new(s);

(
Ndef( \resonantNoise, { Resonz.ar( Array.fill(6,{PinkNoise.ar( SinOsc.ar( \fmfreq.kr(50), 0, \fmamp.kr(0.2), 1 ) )}), \freq.kr(500).lag(0.1) * [1,5/4,3/2] * LFNoise2.kr(\lffreq.kr(50), \lfmul.kr(0.04), 1 ), \rq.kr(0.01).lag(0.1) ).sum * 3 * \amp.kr(1)});

Ndef( \resonantNoise ).addSpec( \fmmul, [0.5,1] );
Ndef( \resonantNoise ).addSpec( \fmfreq, [20,500,\exponential] );
Ndef( \resonantNoise ).addSpec( \freq, [500,1200,\exponential] );
Ndef( \resonantNoise ).addSpec( \lffreq, [20,100,\exponential] );
Ndef( \resonantNoise ).addSpec( \lfmul, [0.01,0.1,\exponential] );
Ndef( \resonantNoise ).addSpec( \rq, [0.01,0.1,\exponential] );

Ndef( \resonantNoise ).addSpec( \amp, [0.001,1,\exponential] );
)

(
Ndef( \resonantDust, { Resonz.ar( Array.fill(6,{ Dust.ar( \dens.kr(10) ) }), \freq.kr(500).lag(0.1) * [1,5/4,3/2] * LFNoise2.kr(\lffreq.kr(50), \lfmul.kr(0.04), 1 ), \rq.kr(0.01).lag(0.1) ).sum * 50 * \amp.kr(1) });



Ndef( \resonantDust ).addSpec( \dens, [10,50,\exponential] );
Ndef( \resonantDust ).addSpec( \freq, [600,2000,\exponential] );
Ndef( \resonantDust ).addSpec( \lffreq, [20,100,\exponential] );
Ndef( \resonantDust ).addSpec( \lfmul, [0.01,0.1,\exponential] );
Ndef( \resonantDust ).addSpec( \rq, [0.001,0.1,\exponential] );


Ndef( \resonantDust ).addSpec( \amp, [0.01,1,\exponential] );
);


Ndef( \resonantNoise ).play(1);
Ndef( \resonantDust ).play(1);

// ~accs[2].disableAction( \fadeInActivity, \volume );
// ~accs[2].disableAction( \fadeOutActivity, \volume );

~accs[3].addAction( \fadeInActivity, \volume, { |data| Ndef( \resonantDust ).set( \amp, data[0] ) } );

~accs[3].addAction( \fadeOutActivity, \volume, { |data| Ndef( \resonantNoise ).set( \amp, data[0] ) } );

~accs[3].disableAction( \meanMapped, \resonantDust );
~accs[3].disableAction( \stdMapped, \resonantDust );
~accs[3].disableAction( \meanMapped, \resonantNoise );
~accs[3].disableAction( \stdMapped, \resonantNoise );

(
~accs[5].addAction( \meanMapped, \resonantDust, { |data|
	Ndef( \resonantDust ).setUni( \freq, data[0] );
	Ndef( \resonantDust ).setUni( \lffreq, data[1] );
	Ndef( \resonantDust ).setUni( \lfmul, data[2] );
});
);
(
~accs[5].addAction( \stdMapped, \resonantDust, { |data|
	Ndef( \resonantDust ).setUni( \dens, data[0] );
	Ndef( \resonantDust ).setUni( \rq, data[1] );
});
);


(
~accs[5].addAction( \meanMapped, \resonantNoise, { |data|
	Ndef( \resonantNoise ).setUni( \freq, data[0] );
	Ndef( \resonantNoise ).setUni( \lffreq, data[1] );
	Ndef( \resonantNoise ).setUni( \lfmul, data[2] );
});
);
(
~accs[5].addAction( \stdMapped, \resonantNoise, { |data|
	Ndef( \resonantNoise ).setUni( \fmfreq, data[0] );
	Ndef( \resonantNoise ).setUni( \rq, data[1] );
	Ndef( \resonantNoise ).setUni( \fmmul, data[2] );
});
);
