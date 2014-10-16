~buf = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
// ~buf

Ndef(\magFreeze ).set( \bufnum, ~buf.bufnum );

(
// could do more of a fade out of one to the other, by sending out direct signal directly.
Ndef(\magFreeze, {
	var in, chain, bufnum=0;
	var gtrigger = Dust.ar(\dens.kr(500) );
	//     in = SinOsc.ar(LFNoise1.kr(5.2,250,400));
	in = GrainBuf.ar( 1, gtrigger,
		\gdur.kr(0.05) * LFNoise1.ar( \lffreq.kr(100), 0.5, 1 ),
		bufnum, \rate.kr(0.5), \pos.kr(0.5)
            //pan: TRand.ar( 0, 2, gtrigger )
	);
	chain = FFT(LocalBuf(2048), in);
	// moves in and out of freeze
	chain = PV_MagFreeze(chain, \fgate.kr(0) );
	FreeVerb.ar(
		LPF.ar( HPF.ar(
			XLine.kr(0.00001,1,0.1)*
			IFFT(chain),
			\hpf.kr(500) ), \lpf.kr(6000) ), \mix.kr(0.3), \room.kr(0.7), \damp.kr(0.3)
	) * \amp.kr(1).lag(1)
});
);


(
Ndef( \magFreeze ).addSpec( \dens, [ 10, 500, \exponential ] );
Ndef( \magFreeze ).addSpec( \gdur, [ 0.05, 0.3, \exponential ] );
Ndef( \magFreeze ).addSpec( \lffreq, [ 10, 200, \exponential ] );
Ndef( \magFreeze ).addSpec( \rate, [ 0.1, 2, \exponential ] );
Ndef( \magFreeze ).addSpec( \mix, [ 0, 1 ] );
Ndef( \magFreeze ).addSpec( \pos, [ 0, 1 ] );
Ndef( \magFreeze ).addSpec( \room, [ 0.2, 0.9 ] );
Ndef( \magFreeze ).addSpec( \damp, [ 0.9, 0.2 ] );

Ndef( \magFreeze ).addSpec( \lpf, [ 2000, 8000, \exponential ] );
Ndef( \magFreeze ).addSpec( \hpf, [ 100, 2000, \exponential ] );

Ndef( \magFreeze ).addSpec( \amp, [ 0.01, 1, \exponential ] );
);

Ndef(\magFreeze).play(1)

Ndef(\magFreeze).set( \fgate, 1 );
Ndef(\magFreeze).set( \fgate, 0 );

(
Dialog.openPanel( { |file|
	if ( ~mbuf.notNil ){ ~mbuf.free };
	~mbuf = Buffer.read( s, file );
	Ndef( \magFreeze ).set( \bufnum, ~mbuf.bufnum );
} );
);


(
~accs[0].addAction( \meanMapped, \magFreeze, { |data|
	Ndef( \magFreeze ).setUni( \gdur, data[0] );
	Ndef( \magFreeze ).setUni( \dens, data[1] );
	Ndef( \magFreeze ).setUni( \lffreq, data[2] );
	Ndef( \magFreeze ).setUni( \lpf, data[1] );
	Ndef( \magFreeze ).setUni( \hpf, data[2] );
});
);
(
~accs[0].addAction( \stdMapped, \magFreeze, { |data|
	Ndef( \magFreeze ).setUni( \rate, data[1] );
	Ndef( \magFreeze ).setUni( \room, data[0] );
	Ndef( \magFreeze ).setUni( \mix, data[1] );
	Ndef( \magFreeze ).setUni( \damp, data[2] );
});
);

(
~eyecon.addAction( \centerXAll, \magFreeze, { |data|
	Ndef( \magFreeze ).set( \pos, data[0] );
});
);

(
~bufWasFrozen = false;
~eyecon.addAction( \activityNormalAll, \magFreeze, { |data|
	data.postln;
	if ( data[0] > 0.35 ){
		if ( ~bufWasFrozen.not ){
			data.postln;
			~bufWasFrozen = true;
			"freeze buffer".postln;
			Ndef( \magFreeze ).set( \fgate, 1 );
			Ndef( \magFreeze ).set( \amp, 1.5 );
		}
	}{
		if ( ~bufWasFrozen and: (data[0]<0.25) ){
			~bufWasFrozen = false;
			"unfreeze buffer".postln;
			Ndef( \magFreeze ).set( \fgate, 0 );
			Ndef( \magFreeze ).set( \amp, 0.25 );
		}
	}
});
);


NdefMixer.new(s);

Ndef.all