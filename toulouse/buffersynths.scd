(
Ndef( \grainbuf, {
    var gtrigger = Dust.ar(\dens.kr(100) );
	FreeVerb.ar(
		GrainBuf.ar( 1, gtrigger,
            \gdur.kr(0.05) * LFNoise1.ar( \lffreq.kr(100), 0.1, 1 ),
            \bufnum.kr(2), \rate.kr(1), TRand.ar( 0, 1, gtrigger )
            //pan: TRand.ar( 0, 2, gtrigger )
        )
		/** EnvGen.kr(
            Env.sine,
            \trig.tr(1),
            timeScale: \dur.kr(1), doneAction: 0 )
		*/
		, \mix.kr(0.3), \room.kr(0.7), \damp.kr(0.3)
	) * \amp.kr(1)
    }
);
);

(
Ndef( \grainbuf ).addSpec( \dens, [ 10, 500, \exponential ] );
Ndef( \grainbuf ).addSpec( \gdur, [ 0.01, 0.1, \exponential ] );
Ndef( \grainbuf ).addSpec( \lffreq, [ 10, 200, \exponential ] );
Ndef( \grainbuf ).addSpec( \rate, [ 0.1, 3, \exponential ] );
Ndef( \grainbuf ).addSpec( \mix, [ 0, 1 ] );
Ndef( \grainbuf ).addSpec( \room, [ 0.2, 0.9 ] );
Ndef( \grainbuf ).addSpec( \damp, [ 0.9, 0.2 ] );

Ndef( \grainbuf ).addSpec( \amp, [ 0.01, 1, \exponential ] );
);

Ndef( \grainbuf ).play(1);

~accs[3].disableAction( \meanMapped, \grainbuf );
~accs[3].disableAction( \stdMapped, \grainbuf );

// ~accs[3].network.at( \meanMapped ).action.remove( \grainbuf )

(
~accs[5].addAction( \meanMapped, \grainbuf, { |data|
	Ndef( \grainbuf ).setUni( \gdur, data[0] );
	Ndef( \grainbuf ).setUni( \dens, data[1] );
	Ndef( \grainbuf ).setUni( \lffreq, data[2] );
});
);
(
~accs[5].addAction( \stdMapped, \grainbuf, { |data|
	Ndef( \grainbuf ).setUni( \rate, data[1] );
	Ndef( \grainbuf ).setUni( \room, data[0] );
	Ndef( \grainbuf ).setUni( \mix, data[1] );
	Ndef( \grainbuf ).setUni( \damp, data[2] );
});
);



(
Dialog.openPanel( { |file|
	if ( b.notNil ){ b.free };
	b = Buffer.read( s, file );
	Ndef( \grainbuf ).set( \bufnum, b.bufnum );
} );
)

NdefMixer.new(s);

(
Ndef( \bufferPlayerFeedbackVerb, {
    var play, triggers, tgate, env, comb, mmix, sig;
    var bufferlength = BufDur.kr( \bufnum.kr(0) );
    // var env2 = EnvGen.ar( Env.cutoff( \release.kr(1) ), \gate.kr(1), doneAction: 0 );
    tgate = Trig1.kr( \trig.tr(1), bufferlength * \repeats.kr(2) / (\rate.kr(1)).abs );
	// triggers = ResetImpulse.kr( \rate.kr.abs / bufferlength, \trig.tr ) * tgate;
	triggers = Impulse.kr( \rate.kr / bufferlength );
    env = EnvGen.kr( Env.linen(0.05,0.5,0.45,curve: -3), \trig.tr, timeScale: bufferlength * \repeats.kr / \rate.kr.abs, doneAction: 0  );
    play = PlayBuf.ar( 1, \bufnum.kr, \rate.kr * \dir.kr(1)  * LFNoise1.kr( \rff.kr(10), \rfa.kr(0.0), 1 ), triggers, loop: 1 );
    comb = CombC.ar( play, 0.2, \delay.kr(0.05 ) * LFNoise1.kr( \lff.kr(10), \lfa.kr(0.01), 1 ), \decay.kr(1) ) * env;
    //comb = play;
    mmix = (\pa.kr(0)*play) + (\ca.kr(1) * comb);
    sig = LeakDC.ar( FreeVerb.ar( mmix, \mix.kr(0.33), \room.kr(0.5), \damp.kr(0.5) ) * env * \amp.kr(0.1) );
    sig = Compander.ar( sig, play, \thresh.kr(0.5) );
	// DetectSilence.ar( sig, doneAction: 2 );
    sig;
});
);

Ndef( \bufferPlayerFeedbackVerb ).play(1);

(
Ndef( \bufferPlayerFeedbackVerb ).addSpec( \repeats, [ 1, 10, \exponential ] );
Ndef( \bufferPlayerFeedbackVerb ).addSpec( \rate, [ 0.1, 10, \exponential ] );

//Ndef( \bufferPlayerFeedbackVerb ).addSpec( \dir, [ -1,1, \linear ] );
Ndef( \bufferPlayerFeedbackVerb ).addSpec( \rff, [ 1, 100, \exponential ] );
Ndef( \bufferPlayerFeedbackVerb ).addSpec( \rfa, [ 0.1, 1, \exponential ] );

Ndef( \bufferPlayerFeedbackVerb ).addSpec( \lff, [ 1, 100, \exponential ] );
Ndef( \bufferPlayerFeedbackVerb ).addSpec( \lfa, [ 0.1, 1, \exponential ] );

Ndef( \bufferPlayerFeedbackVerb ).addSpec( \delay, [ 0.01, 0.2, \exponential ] );
Ndef( \bufferPlayerFeedbackVerb ).addSpec( \decay, [ 0.2, 2, \exponential ] );

Ndef( \bufferPlayerFeedbackVerb ).addSpec( \pa, [ 0, 1 ] );
Ndef( \bufferPlayerFeedbackVerb ).addSpec( \ca, [ 1, 0 ] );

Ndef( \bufferPlayerFeedbackVerb ).addSpec( \mix, [ 0, 1 ] );
Ndef( \bufferPlayerFeedbackVerb ).addSpec( \room, [ 0.2, 0.9 ] );
Ndef( \bufferPlayerFeedbackVerb ).addSpec( \damp, [ 0.9, 0.2 ] );
);

(
~accs[3].addAction( \meanMapped, \bufferPlayerFeedbackVerb, { |data|
	Ndef( \bufferPlayerFeedbackVerb ).setUni( \rff, data[0] );
	Ndef( \bufferPlayerFeedbackVerb ).setUni( \rfa, data[1] );
	Ndef( \bufferPlayerFeedbackVerb ).setUni( \lff, data[2] );
	Ndef( \bufferPlayerFeedbackVerb ).setUni( \lfa, data[0] );
	Ndef( \bufferPlayerFeedbackVerb ).setUni( \decay, data[1] );
	Ndef( \bufferPlayerFeedbackVerb ).setUni( \delay, data[2] );
});
);
(
~accs[3].addAction( \stdMapped, \bufferPlayerFeedbackVerb, { |data|
	Ndef( \bufferPlayerFeedbackVerb ).setUni( \rate, data[1] );
	Ndef( \bufferPlayerFeedbackVerb ).setUni( \room, data[0] );
	Ndef( \bufferPlayerFeedbackVerb ).setUni( \mix, data[1] );
	Ndef( \bufferPlayerFeedbackVerb ).setUni( \damp, data[2] );
});
);

~eyecon.availableKeys
~eyecon.disableAction( \activityNormal1, \bufferPlayerFeedbackVerb );
~eyecon.disableAction( \activityNormal2, \bufferPlayerFeedbackVerb );
~eyecon.disableAction( \activityNormalAll, \bufferPlayerFeedbackVerb );

(
~bufWasTriggered = false;
~eyecon.addAction( \activityNormalAll, \bufferPlayerFeedbackVerb, { |data|
	if ( data[0] > 0.7 ){
		if ( ~bufWasTriggered.not ){
			// data.postln;
			~bufWasTriggered = true;
			"trigger buffer".postln;
			Ndef( \bufferPlayerFeedbackVerb ).set( \trig, 1 );
		}
	}{
		~bufWasTriggered = false;
	}
});
);

(
~eyecon.addAction( \activityNormalAll, \grainbuf, { |data|
	Ndef( \grainbuf ).setUni( \amp, data[0] );
});
)