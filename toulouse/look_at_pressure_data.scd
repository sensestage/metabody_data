x = SWDataNetwork.new;

(
OSCdef( \minibee2network, { |msg|
	x.setData( msg[1], msg.copyToEnd( 2 ) );
}, "/minibee/data" );
);
x.makeNodeGui
[1,2,3,4].do{ |id| x.addExpected( id ) };

s.boot;
s.latency_( 0.001 );

(
[1,2,3,4].do{ |id|
	x.addHook( id, {
		var sumnode, meannode, summeannode, devnode, sumdevnode;
		x.nodes[id].createBus( s );
		// sumnode = SumBusesNode.new( id+50, x, x.nodes[id].bus );
		// fork{ 0.5.wait; sumnode.start; };
		meannode = MeanNode.new( id + 20, x, x.nodes[id].bus ).set( \length, 200 );
		fork{ 1.0.wait; meannode.start; };
		// summeannode = SumBusesNode.new( id+30, x, x.nodes[id+20].bus );
		// fork{ 1.5.wait; summeannode.start; };
		devnode = StdDevNode.new( id + 10, x, x.nodes[id].bus ).set( \length, 200 );
		fork{ 2.0.wait; devnode.start; };
		// sumdevnode = SumBusesNode.new( id+40, x, x.nodes[id+10].bus );
		// fork{ 2.5.wait; sumdevnode.start; };
	});
};
);

/*
(
x.addHook( 47, {
	fork{ 3.0.wait;
		x.addExpected( 61);
		~watcher = SWWatcherNode.new( 61, x, { (51..57).collect{ |id| x.nodes[id].data }.flatten; }, 0.01, true );
		x.addExpected( 62);
		~watcherMean = SWWatcherNode.new( 62, x, { (31..37).collect{ |id| x.nodes[id].data }.flatten; }, 0.01, true );
		x.addExpected( 63 );
		~watcherStd = SWWatcherNode.new( 63, x, { (41..47).collect{ |id| x.nodes[id].data }.flatten; }, 0.01, true );
	};
});
);
*/

// send standard deviation to processing sketch
~processing = NetAddr.new( "127.0.0.1", 12000 );
~stdDevSpec = [0.001, 0.5, \exponential ].asSpec;
(
[1,2,3,4].do{ |id|
	x.addHook( id+10, {
		x.nodes[id+10].action = { |data|
			// var sign = (x.nodes[ id ].data - x.nodes[ id + 20 ].data).sign;
			~processing.sendMsg( *( ["/minibee/stddev", id] ++ (~stdDevSpec.unmap( data )) ) );
		}
	});
};
)


~oscplayer.reset;
~oscplayer.play;
~oscplayer.stop;

x.makeNodeGui;