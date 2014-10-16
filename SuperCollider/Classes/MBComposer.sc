MBComposer {

	var <oscFuncs;
	var <network;

	*new{
		^super.new.init;
	}

	init{
		network = SWDataNetwork.new;
		[
			[1,\activityNormal],
			[2,\activitySensitive],
			[3,\centerX],
			[4,\dasTrig],
			[5,\dasClose],
			[6,\height],
			[7,\width],
			[8,\heightLevel],
			[9,\overhead],
			[10,\sideFootRight],
			[11,\sideFootLeft],
			[12,\sideHandRight],
			[13,\sideHandLeft]
		].do{ |it|
			network.addExpected( it[0], it[1], 1 );
		};
		this.addHooks;
		this.createOSCfuncs;
	}

	addHooks{
		(1..13).do{ |id|
			network.addHook( id, {
				network.nodes[id].action = MFunc.new;
			});
		};
	}

	createOSCfuncs{
		oscFuncs = [
			OSCFunc.new( { |data|
				network.setData( 1, data[1] );
			}, "/activityNormal1" ),
			OSCFunc.new( { |data|
				network.setData( 2, data[1] );
			},"/activitySensitive1" ),
			OSCFunc.new( { |data|
				network.setData( 3, data[1] );
			},"/centerX" ),
			OSCFunc.new( { |data|
				network.setData( 4, data[1] );
			},"/dastrig" ),
			OSCFunc.new( { |data|
				network.setData( 5, data[1] );
			},"/dasClose"),
			OSCFunc.new( { |data|
				network.setData( 6, data[1] );
			},"/height"),
			OSCFunc.new( { |data|
				network.setData( 7, data[1] );
			},"/width"),
			OSCFunc.new( { |data|
				network.setData( 8, data[1] );
			},"/heightLevel"),
			OSCFunc.new( { |data|
				network.setData( 9, data[1] );
			},"/overhead"),
			OSCFunc.new( { |data|
				network.setData( 10, data[1] );
			},"/SideFootR1"),
			OSCFunc.new( { |data|
				network.setData( 11, data[1] );
			},"/SideFootL1"),
			OSCFunc.new( { |data|
				network.setData( 12, data[1] );
			},"/SideHandR1"),
			OSCFunc.new( { |data|
				network.setData( 13, data[1] );
			},"/SideHandL1")
		];
	}

	freeAll{
		oscFuncs.do{ |it| it.free };
	}

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

	monitor{ |node,onoff=true|
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