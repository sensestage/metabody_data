// start pydongui:
("cd" + "".resolveRelative ++ "; pydongui.py").runInTerminal;


/// xosc:
~xosc = NetAddr.new( "192.168.2.103", 57000 );

// connection to minibee data:
~xosc.sendMsg( "/XOSC/subscribe/tag", "/minibee/info" );
~xosc.sendMsg( "/XOSC/subscribe/tag", "/minibee/data" );


// connection to EyeCon
~eyecon = MBEyeCon.new;
~eyecon.tags.do{ |it| ~xosc.sendMsg( "/XOSC/subscribe/tag", it ); };
~eyecon.makeGui;


/// ---- testing -----

OSCdef( \showInfoClient, { |msg| msg.postln; }, "/XOSC/info/client" );
OSCdef( \showInfoTag, { |msg| msg.postln; }, "/XOSC/info/tag" );
OSCdef( \showInfoConnectionTag, { |msg| msg.postln; }, "/XOSC/info/connection/tag" );

~xosc.sendMsg( "/XOSC/query/tags" );
~xosc.sendMsg( "/XOSC/query/clients" );
~xosc.sendMsg( "/XOSC/query/connections", NetAddr.langPort );

(
OSCdef( \minibeePost, { |msg|
	msg.postln;
}, "/minibee/data" );
);

OSCdef( \minibeePost ).free;
// -------------------

s.boot;
s.latency_( 0.001 );

// when booted:
// s.doWhenBooted({

(
~press = MBAnalog.new(1);
~press.inputSpec = [ 0.4, 1].asSpec;
~press.activitySpec = [ 0.001, 0.3, \exponential ].asSpec;
);

~accs = 7.collect{ |it| MBAccelero.new; };

(
~accs.do{ |it,i| it.motionSpec_( [ 0.0005, 0.3, \exponential ].asSpec ); };
~accs.do{ |it,i| it.acceleroSpec_( [ 0.4, 0.6 ].asSpec ); };
);


( // set data from OSC messages to the objects:
OSCdef( \minibee2accelero, { |msg|
	if ( msg[1] < 8 ){
		~accs[ msg[1] - 1 ].setData( msg.copyRange( 2, 4 ) );
	};
	if ( msg[1] == 8 ){
		~press.setData( msg.copyRange( 4, 4 ); );
		// ~press.setData( msg.copyRange( 2, 5 ); );
	};
}, "/minibee/data" );
);
// OSCdef( \minibee2accelero ).free;


/// forward calculations to xosc for others to use:
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

//}); // end s.doWhenBooted;


/// --- view data ------------

~accs[0].makeGui; // arm
~accs[1].makeGui; // hips
~accs[2].makeGui; // torso
~accs[3].makeGui; // head
~accs[4].makeGui; // foot

~accs[0].monitor( \stddev, true );
~accs[1].monitor( \stddev, true );
~accs[2].monitor( \stddev, false );
~accs[3].monitor( \stddev, true ); // foot
~accs[4].monitor( \stddev, true );

~accs[5].monitor( \stddev, true ); // arm


~press.makeGui;


/// torso + hips - more of a continuous sound to modulate
/// hands + feet - more impulsive, or change the sound

/// hands + feet: activity->amplitude,

// combinations:
// -- hand+feet still, torso still
// -- hand+feet still, torso active
// -- hand+feet active, torso still
// -- hand+feet active, torso active
