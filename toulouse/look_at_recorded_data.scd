x = SWDataNetwork.new;

(
OSCdef( \minibee2network, { |msg|
	x.setData( msg[1], msg.copyToEnd( 2 ) );
}, "/minibee/data" );
);

[1,2,3,4,5,6,7].do{ |id| x.addExpected( id ) };

s.boot;

(
[1,2,3,4,5,6,7].do{ |id|
	x.addHook( id, {
		var devnode;
		x.nodes[id].createBus( s );
		devnode = StdDevNode.new( id + 10, x, x.nodes[id].bus ).set( \length, 200 );
		fork{ 2.0.wait; devnode.start; }
	});
};
);

x.addExpected( 21 );
~watcher = SWWatcherNode.new( 21, x, { (1..7).collect{ |id| x.nodes[id].data }.flatten; }, 0.01, true );

x.addExpected( 31 );
~watcherStd = SWWatcherNode.new( 22, x, { (11..17).collect{ |id| x.nodes[id].data }.flatten; }, 0.01, true );

SumBusesNode
SWDataNetwork

~oscplayer.play;
~oscplayer.stop;

x.makeGui;