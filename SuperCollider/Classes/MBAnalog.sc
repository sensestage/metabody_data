MBAnalog {
	var <>inputSpec;
	var <>activitySpec;

	var <network;

	var <meannode;
	var <stddevnode;

	var <>activityLevels;

	*new{ |nchan|
		^super.new.init( nchan );
	}

	initSpecs{
		inputSpec = [ 0.0, 1.0 ].asSpec;
		activitySpec = [ 0.0001, 0.15, \exponential ].asSpec;
	}

	init{ |nchan|
		activityLevels = [0.4, 0.6];
		this.initSpecs;
		network = SWDataNetwork.new;
		[
			[1, \input],[2,\mean], [3,\stddev],
			[11, \inputMapped], [ 12, \meanMapped], [13,\stdMapped],
			[21, \lowActivity], [22, \fadeOutActivity],
			[23, \fadeInActivity], [24, \highActivity]
		].do{ |it|
			network.addExpected( it[0], it[1], nchan );
		};
		this.addHooks;
	}

	addHooks{
		network.addHook( 1, {
			network.nodes[1].action = MFunc.new;
			network.nodes[1].action.add( \map, { |data|
				network.setData( 11, inputSpec.unmap( data ) );
			});
			network.nodes[1].createBus(Server.default);
			meannode = MeanNode.new( 2, network, network.nodes[1].bus, Server.default );
			meannode.set( \length, 500 );
			fork{ 0.2.wait; meannode.start; };
			stddevnode = StdDevNode.new( 3, network, network.nodes[1].bus, Server.default );
			stddevnode.set( \length, 250 );
			fork{ 0.2.wait; stddevnode.start; };
		});
		network.addHook( 2, {
			network.nodes[2].action = MFunc.new;
			network.nodes[2].action.add( \map, { |data|
				network.setData( 12, inputSpec.unmap( data ) );
			});
		});
		network.addHook( 3, {
			network.nodes[3].action = MFunc.new;
			network.nodes[3].action.add( \map, { |data|
				network.setData( 13, activitySpec.unmap( data ) );
			});
		});
		network.addHook( 13, {
			network.nodes[13].action = MFunc.new;
			network.nodes[13].action.add( \activityLevel, { |data|
				var low = this.activityLevels[0];
				var high = this.activityLevels[1];
				var diff = this.activityLevels[1] - this.activityLevels[0];
				network.setData( 21, data.collect{ |it|
					(it < low).binaryValue
				});
				network.setData( 22, data.collect{ |it|
					[diff,0].asSpec.unmap( (it-low) )
				});
				network.setData( 23, data.collect{ |it|
					[0,diff].asSpec.unmap( (it-low) )
				});
				network.setData( 24, data.collect{ |it|
					(it > high).binaryValue
				});
			});
		});
		[11, 12, 21, 22, 23, 24].do{ |id|
			network.addHook( id, {
				network.nodes[id].action = MFunc.new;
			});
		};
	}

	setData{ |data|
		network.setData( 1, data );
	}

	// convenience methods

	directUni{
		^network.nodes[11].data;
	}

	meanUni{
		^network.nodes[12].data;
	}

	stdUni{
		^network.nodes[13].data;
	}


	// --- kind of standard methods:
	addAction{ |node,label,action|
		if ( node.isKindOf( Symbol ) ){
			network.at( node ).action.addFirst( label, action );
		}{
			network.nodes[ node ].action.addFirst( label, action );
		};
	}

	removeAction{ |node, label|
		if ( node.isKindOf( Symbol ) ){
			network.at( node ).action.remove( label );
		}{
			network.nodes[ node ].action.remove( label );
		};
	}

	enableAction{ |node, label|
		if ( node.isKindOf( Symbol ) ){
			network.at( node ).action.enable( label );
		}{
			network.nodes[ node ].action.enable( label );
		};
	}

	disableAction{ |node, label|
		if ( node.isKindOf( Symbol ) ){
			network.at( node ).action.disable( label );
		}{
			network.nodes[ node ].action.disable( label );
		};
	}

	monitor{ |node,onoff|
		if ( node.isKindOf( Symbol ) ){
			network.at( node ).monitor(onoff);
		}{
			network.nodes[ node ].monitor(onoff);
		};
	}

	makeGui{
		^network.makeNodeGui;
	}

	availableKeys{
		^network.spec.map.keys
	}
}