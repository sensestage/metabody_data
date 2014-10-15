~xosc = NetAddr.new( "192.168.2.103", 57000 );

~xosc.sendMsg( "/XOSC/subscribe/tag", "/minibee/data" );



~xosc.sendMsg( "/XOSC/subscribe/tag", "/minibee/info" );
(
OSCdef( \minibeePost, { |msg|
	msg.postln;
}, "/minibee/data" );
);

OSCdef( \minibeePost ).free;


s.boot;

~accs = 8.collect{ |it| MBAccelero.new; };
(
OSCdef( \minibee2accelero, { |msg|
	~accs[ msg[1] - 1 ].setData( msg.copyRange( 2, 5 ) );
}, "/minibee/data" );
);

// OSCdef( \minibee2accelero ).free;
(
~accs.do{ |it,i| it.motionSpec_( [ 0.001, 0.2, \exponential ].asSpec ); };
~accs.do{ |it,i| it.acceleroSpec_( [ 0.4, 0.6 ].asSpec ); };
);

(
~accs.do{ |it,i|
	it.addAction( \accelero, \forward,
		{ |data| ~xosc.sendMsg( *(["/minibee/accelero/raw", i+1 ] ++ data ) ); }
	);
	it.addAction( \mean, \forward,
		{ |data| ~xosc.sendMsg( *(["/minibee/accelero/mean", i+1 ] ++ data ) ); }
	);
	it.addAction( \stddev, \forward,
		{ |data| ~xosc.sendMsg( *(["/minibee/accelero/stddev", i+1 ] ++ data ) ); }
	);
	it.addAction( \accMapped, \forward,
		{ |data| ~xosc.sendMsg( *(["/minibee/accelero/scaled", i+1 ] ++ data ) ); }
	);
	it.addAction( \meanMapped, \forward,
		{ |data| ~xosc.sendMsg( *(["/minibee/accelero/mean/scaled", i+1 ] ++ data ) ); }
	);
	it.addAction( \stdMapped, \forward,
		{ |data| ~xosc.sendMsg( *(["/minibee/accelero/stddev/scaled", i+1 ] ++ data ) ); }
	);
};
);

~accs[0].network.makeNodeGui; // arm
~accs[1].network.makeNodeGui; // hips
~accs[2].network.makeNodeGui; // torso
~accs[3].network.makeNodeGui; // head
~accs[4].network.makeNodeGui; // foot

~accs[0].network.at( \stddev ).monitor( true );
~accs[1].network.at( \stddev ).monitor( true );
~accs[2].network.at( \stddev ).monitor( true );
~accs[3].network.at( \stddev ).monitor( true );
~accs[4].network.at( \stddev ).monitor( true );


/// torso + hips - more of a continuous sound to modulate
/// hands + feet - more impulsive, or change the sound

/// hands + feet: activity->amplitude,

// combinations:
// -- hand+feet still, torso still
// -- hand+feet still, torso active
// -- hand+feet active, torso still
// -- hand+feet active, torso active
