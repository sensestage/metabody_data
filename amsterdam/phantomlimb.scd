~pydon = NetAddr.new( "127.0.0.1", 57600 );

x = SWDataNetwork.new;

x.addExpected( 6 );
OSCdef( \minibeeData, { |msg| x.setData( msg[1], msg.copyToEnd(2) ); }, "/minibee/data" );

x.makeNodeGui;

Tdef( \updateVibes, { |ev| loop{ ~pydon.sendMsg( "/minibee/output", 6, ev.vibe1, 0, ev.vibe2, 0, ev.vibe3, 0 ); 0.1.wait; } } );

Tdef( \updateVibes ).set( \vibe1, 0, \vibe2, 0, \vibe3, 0 );
Tdef( \updateVibes ).play;

Tdef( \updateVibes ).stop;

Tdef( \updateVibes ).set( \vibe1, 127, \vibe2, 127, \vibe3, 127 );

s.boot;

q = q ? ();
(
x.addHook( 6, {
	x.nodes[6].createBus(s);
	q.stdDevNode = StdDevNode( 16, x, x.nodes[6].bus, s );
	fork{
		0.5.wait;
		q.stdDevNode.start;
	};
});
);

q.dxAcceleroSpec = [ 0.001, 0.05, \exponential ].asSpec;

q.dxAcceleroSpec = [ 0.01, 0.001, \exponential ].asSpec;

(
x.addHook( 16, {
	x.nodes[16].action = MFunc.new;
	x.nodes[16].action.add( \setVibes, { |data|
		Tdef( \updateVibes ).set(
			\vibe1, (q.dxAcceleroSpec.unmap( data[0] ) * 255).round(1).asInteger,
			\vibe2, (q.dxAcceleroSpec.unmap( data[1] ) * 255).round(1).asInteger,
			\vibe3, (q.dxAcceleroSpec.unmap( data[2] ) * 255).round(1).asInteger
		);
	});
});
);
