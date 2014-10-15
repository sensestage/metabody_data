// boot the audio engine - if it is not already running:
s.boot;

// create the GUI for sounds:
NdefMixer.new( s );


(
// definition of the sound:
Ndef( \sineOsc, { SinOsc.ar( \freq.kr( 200 ).lag(0.1) * SinOsc.ar( \fmfreq.kr(100).lag(0.1), 0, \fmamp.kr(0.1).lag(0.1), 1 ), 0, \amp.kr(0.1).lag(0.1,0.5) ); } );


Ndef( \sineOsc ).addSpec( \fmfreq, [ 100, 500, \exponential ] ); // sets the range for the frequency
Ndef( \sineOsc ).addSpec( \fmamp, [ 0.05, 0.3, \exponential ] ); // sets the range for the frequency

Ndef( \sineOsc ).addSpec( \freq, [ 1200, 4000, \exponential ] ); // sets the range for the frequency
Ndef( \sineOsc ).addSpec( \amp, [ 0.01, 0.8, \exponential ] );    // sets the range for the amplitude
Ndef( \sineOsc ).play(1); // start playback
)

// create an OSC receiver to map the incoming data to the sound parameters:
(
OSCdef( \minibeeSound, { |msg|
	if ( msg[1] == 1 ){
		Ndef( \sineOsc ).setUni( \freq, q.acceleroSpec.unmap( msg[2] ) ); // map from 0 to 1, to the range of the frequency
		Ndef( \sineOsc ).setUni( \fmamp, q.acceleroSpec.unmap( msg[3] ) ); // map from 0 to 1, to the range of the frequency
		Ndef( \sineOsc ).setUni( \fmfreq, q.acceleroSpec.unmap( msg[4] ) ); // map from 0 to 1, to the range of the frequency
	}
}, "/minibee/data" );
);


(
Ndef( \sineOsc, {
	RLPF.ar(
		LFPulse.ar( \lffreq.kr(10), 0, \width.kr(0.5) ),
		\freq.kr(200).lag(0.1),
		\rq.kr(0.1)
	) * \amp.kr(0.1).lag(0.1,0.5);
} );

Ndef( \sineOsc ).addSpec( \lffreq, [ 10, 100, \exponential ] ); // sets the range for the frequency
Ndef( \sineOsc ).addSpec( \width, [ 0.1, 0.5 ] ); // sets the range for the frequency
Ndef( \sineOsc ).addSpec( \freq, [ 1200, 4000, \exponential ] ); // sets the range for the frequency
Ndef( \sineOsc ).addSpec( \amp, [ 0.01, 0.8, \exponential ] );    // sets the range for the amplitude
)

(
OSCdef( \minibeeSound, { |msg|
	if ( msg[1] == 1 ){
		Ndef( \sineOsc ).setUni( \freq, msg[2] ); // map from 0 to 1, to the range of the frequency
		Ndef( \sineOsc ).setUni( \width, msg[3] ); // map from 0 to 1, to the range of the frequency
		Ndef( \sineOsc ).setUni( \lffreq, msg[4] ); // map from 0 to 1, to the range of the frequency
	}
}, "/minibee/data" );
);


(
OSCdef( \minibeeSound, { |msg|
	if ( msg[1] == 1 ){
		Ndef( \sineOsc ).setUni( \freq, q.acceleroSpec.unmap( msg[2] ) ); // map from 0 to 1, to the range of the frequency
		Ndef( \sineOsc ).setUni( \width, q.acceleroSpec.unmap( msg[3] )); // map from 0 to 1, to the range of the frequency
		Ndef( \sineOsc ).setUni( \lffreq, q.acceleroSpec.unmap( msg[4] ) ); // map from 0 to 1, to the range of the frequency
	}
}, "/minibee/data" );
);

(
Ndef( \sineOsc2, {
	RLPF.ar(
		LFPulse.ar( \lffreq.kr(10), 0, \width.kr(0.5) ),
		\freq.kr(200).lag(0.1),
		\rq.kr(0.1)
	) * \amp.kr(0.1).lag(0.1,0.5);
} );


(
OSCdef( \minibeeSound2, { |msg|
	if ( msg[1] == 2 ){
		Ndef( \sineOsc2 ).setUni( \freq, q.acceleroSpec.unmap( msg[2] ) ); // map from 0 to 1, to the range of the frequency
		Ndef( \sineOsc2 ).setUni( \width, q.acceleroSpec.unmap( msg[3] )); // map from 0 to 1, to the range of the frequency
		Ndef( \sineOsc2 ).setUni( \lffreq, q.acceleroSpec.unmap( msg[4] ) ); // map from 0 to 1, to the range of the frequency
	}
}, "/minibee/data" );
);

Ndef( \sineOsc2 ).addSpec( \lffreq, [ 10, 200, \exponential ] ); // sets the range for the frequency
Ndef( \sineOsc2 ).addSpec( \width, [ 0.1, 0.5 ] ); // sets the range for the frequency
Ndef( \sineOsc2 ).addSpec( \freq, [ 600, 2000, \exponential ] ); // sets the range for the frequency
Ndef( \sineOsc2 ).addSpec( \amp, [ 0.01, 0.8, \exponential ] );    // sets the range for the amplitude
)


(
// definition of the sound:
Ndef( \sineOsc2, { SinOsc.ar( \freq.kr( 200 ).lag(0.1) * SinOsc.ar( \fmfreq.kr(100).lag(0.1), 0, \fmamp.kr(0.1).lag(0.1), 1 ), 0, \amp.kr(0.1).lag(0.1,0.5) ); } );

Ndef( \sineOsc2 ).addSpec( \fmfreq, [ 100, 500, \exponential ] ); // sets the range for the frequency
Ndef( \sineOsc2 ).addSpec( \fmamp, [ 0.05, 0.3, \exponential ] ); // sets the range for the frequency

Ndef( \sineOsc2 ).addSpec( \freq, [ 600, 2000, \exponential ] ); // sets the range for the frequency
Ndef( \sineOsc2 ).addSpec( \amp, [ 0.01, 0.6, \exponential ] );    // sets the range for the amplitude
Ndef( \sineOsc2 ).play(1); // start playback
)


// create an OSC receiver to map the incoming data to the sound parameters:
(
OSCdef( \minibeeSound2, { |msg|
	if ( msg[1] == 2 ){
		Ndef( \sineOsc2 ).setUni( \freq, q.acceleroSpec.unmap( msg[2] ) ); // map from 0 to 1, to the range of the frequency
		Ndef( \sineOsc2 ).setUni( \fmamp, q.acceleroSpec.unmap( msg[3] ) ); // map from 0 to 1, to the range of the frequency
		Ndef( \sineOsc2 ).setUni( \fmfreq, q.acceleroSpec.unmap( msg[4] ) ); // map from 0 to 1, to the range of the frequency
	}
}, "/minibee/data" );
);


x = SWDataNetwork.new;
x.addExpected( 1 );
x.addExpected( 2 );

(
OSCdef( \minibeeDN, { |msg|
	x.setData( msg[1], msg.copyToEnd( 2 ) );
}, "/minibee/data" );
);

x.makeGui;



// make a simple dictionary to keep data:
q = q ? ();

x.nodes[1].createBus(s); // create a bus on the server for the data
q.meanNode = MeanNode.new( 11, x, x.nodes[1].bus, s );
// the mean has a couple of settings:
q.meanNode.settings;
q.meanNode.set( \length, 200 );

// start the mean node:
q.meanNode.start;


q.stdNode = StdDevNode.new( 21, x, x.nodes[1].bus, s );
// the standard deviation also has a couple of settings:
q.stdNode.settings;

q.stdNode.set( \length, 200 );

// start the standard deviation node:
q.stdNode.start;


///
x.nodes[2].createBus(s); // create a bus on the server for the data
q.meanNode2 = MeanNode.new( 12, x, x.nodes[2].bus, s );
// the mean has a couple of settings:
q.meanNode2.settings;
q.meanNode2.set( \length, 200 );

// start the mean node:
q.meanNode2.start;


q.stdNode2 = StdDevNode.new( 22, x, x.nodes[2].bus, s );
// the standard deviation also has a couple of settings:
q.stdNode2.settings;

q.stdNode2.set( \length, 200 );

// start the standard deviation node:
q.stdNode2.start;



q.stdSpec2 = [ 0.005, 0.2, \exponential ].asSpec;
q.stdSpec = [ 0.005, 0.2, \exponential ].asSpec;

(
x.nodes[21].action = MFunc.new;
x.nodes[22].action = MFunc.new;
x.nodes[11].action = MFunc.new;
x.nodes[12].action = MFunc.new;
);

(
x.nodes[21].action.add( \sineOsc, { |data|
	var mappedData = q.stdSpec.unmap( data );
	Ndef( \sineOsc ).setUni( \amp, mappedData.sum / 3 );
	Ndef( \sineOsc ).setUni( \rq, mappedData[0] );
};
);
);

(
x.nodes[22].action.add( \sineOsc, { |data|
	var mappedData = q.stdSpec2.unmap( data );
	Ndef( \sineOsc2 ).setUni( \amp, mappedData.sum / 3 );
	Ndef( \sineOsc2 ).setUni( \rq, mappedData[0] );
});
)



// stop the sound playback:
Ndef( \sineOsc ).stop;
// remove the osc receiver:
OSCdef( \minibeeSound ).free;

s.latency_(0.001);