(
Ndef( \lfpulse, {
	RHPF.ar(
		RLPF.ar(
			LFPulse.ar( \lffreq.kr(10), 0, \width.kr(0.5) ),
			\freq.kr(300).lag(0.1),
			\rq.kr(0.1)
		),
		\hfreq.kr(50), \hrq.kr(0.1)
	) * \amp.kr(0.1).lag(0.1,0.5);
} );

Ndef( \lfpulse ).addSpec( \hfreq, [ 10, 500, \exponential ] ); // sets the range for the frequency
Ndef( \lfpulse ).addSpec( \lffreq, [ 10, 100, \exponential ] ); // sets the range for the frequency
Ndef( \lfpulse ).addSpec( \width, [ 0.1, 0.5 ] ); // sets the range for the frequency
Ndef( \lfpulse ).addSpec( \freq, [ 500, 8000, \exponential ] ); // sets the range for the frequency
Ndef( \lfpulse ).addSpec( \amp, [ 0.01, 0.8, \exponential ] );    // sets the range for the amplitude
);

Ndef( \lfpulse ).play(5, vol: 0.3);

b.resetMap;
b.sound = Ndef( \lfpulse );

b.addPar( \dx, \hfreq );
b.addPar( \dy, \freq );
b.addPar( \dz, \lffreq );

b.addPar( \x, \width );
b.addPar( \dx, \amp );
b.addPar( \dy, \amp );
b.addPar( \dz, \amp );
