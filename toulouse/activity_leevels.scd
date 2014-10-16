/// levels of activity


~accs[2].activityLevels


Ndef( \sine, { SinOsc.ar( \freq.kr(500), 0, \amp.kr(1).lag(0.5) * 0.025 ) } );
Ndef( \sine ).play;
Ndef( \sine2, { SinOsc.ar( \freq.kr(700), 0, \amp.kr(1).lag(0.5) * 0.025 ) } );
Ndef( \sine2 ).play(1);

Ndef( \sine2 ).addSpec( \amp, [0.01,1,\exponential] );
Ndef( \sine ).addSpec( \amp, [0.01,1,\exponential] );

//
~accs[2].network.spec.map.keys

~accs[2].addAction( \fadeInActivity, \volume, { |data| Ndef( \sine2 ).set( \amp, data[0] ) } );

~accs[2].addAction( \fadeOutActivity, \volume, { |data| Ndef( \sine ).set( \amp, data[0] ) } );


/// -------- test code ----------
// mapped values of stddev:
// up to 0.4: low acitivity
// 0.4 to 0.6 transition space
// from 0.6 high activity

(
~low = 0.4;
~high = 0.6;
~accs[2].network.addExpected( 21, \lowActivity, 3 );
~accs[2].network.addExpected( 22, \midActivityFadeOut, 3 );
~accs[2].network.addExpected( 23, \midActivityFadeIn, 3 );
~accs[2].network.addExpected( 24, \highActivity, 3 );

~accs[2].addAction( \stdMapped, \level, { |data|
	~accs[2].network.setData( 21, data.collect{ |it|
			(it < ~low).binaryValue
	};);
	~accs[2].network.setData( 22, data.collect{ |it|
			//" ".post;
			[~high-~low,0].asSpec.unmap( (it-~low) )
			// ( it > 0.4 ).binaryValue;
	};);
	~accs[2].network.setData( 23, data.collect{ |it|
			//" ".post;
			[0,~high-~low].asSpec.unmap( (it-~low) )
			//( it > 0.4 ).binaryValue;
	};);
	~accs[2].network.setData( 24, data.collect{ |it|
			(it > ~high).binaryValue
	};);
});
);