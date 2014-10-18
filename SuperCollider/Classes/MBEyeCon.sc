MBEyeCon {

	var <oscFuncs;
	var <network;

	*new{
		^super.new.init;
	}

	init{
		network = SWDataNetwork.new;
		[
			[1,\activityNormal1],
			[11,\activityNormal2],
			[21,\activityNormalAll],
			[31,\activityNormal3],
			[41,\activityNormal4],
			[2,\activitySensitive1],
			[12,\activitySensitive2],
			[22,\activitySensitiveAll],
			[32,\activitySensitive3],
			[42,\activitySensitive4],
			[3,\centerX1],
			[13,\centerX2],
			[23,\centerXAll],
			[6,\height1],
			[16,\height2],
			[26,\heightAll],
			[7,\width1],
			[17,\width2],
			[27,\widthAll]
		].do{ |it|
			network.addExpected( it[0], it[1], 1 );
		};
		this.addHooks;
		this.createOSCfuncs;
	}

	addHooks{
		[1,11,21,31,41, 2,12,22,32,42, 3,13,23, 6,16,26, 7,17,27].do{ |id|
			network.addHook( id, {
				network.nodes[id].action = MFunc.new;
			});
		};
	}

	tags{
		^[
			"/activityNormal1",
			"/activityNormal2",
			"/activityNormalAll",
			"/activityNormal3",
			"/activityNormal4",
			"/activitySensitive1",
			"/activitySensitive2",
			"/activitySensitiveAll",
			"/activitySensitive3",
			"/activitySensitive4",
			"/centerX1",
			"/centerX2",
			"/centerXAll",
			"/height1",
			"/height2",
			"/heightAll",
			"/width1",
			"/width2",
			"/widthAll"
		];
	}

	createOSCfuncs{
		oscFuncs = [
			OSCFunc.new( { |data|
				network.setData( 1, [data[1]] );
			}, "/activityNormal1" ),
			OSCFunc.new( { |data|
				network.setData( 11, [data[1]] );
			}, "/activityNormal2" ),
			OSCFunc.new( { |data|
				network.setData( 21, [data[1]] );
			}, "/activityNormalAll" ),
			OSCFunc.new( { |data|
				network.setData( 31, [data[1]] );
			}, "/activityNormal3" ),
			OSCFunc.new( { |data|
				network.setData( 41, [data[1]] );
			}, "/activityNormal4" ),

			OSCFunc.new( { |data|
				network.setData( 2, [data[1]] );
			},"/activitySensitive1" ),
			OSCFunc.new( { |data|
				network.setData( 12, [data[1]] );
			},"/activitySensitive2" ),
			OSCFunc.new( { |data|
				network.setData( 22, [data[1]] );
			},"/activitySensitiveAll" ),
			OSCFunc.new( { |data|
				network.setData( 32, [data[1]] );
			},"/activitySensitive3" ),
			OSCFunc.new( { |data|
				network.setData( 42, [data[1]] );
			},"/activitySensitive4" ),

			OSCFunc.new( { |data|
				network.setData( 3, [data[1]] );
			},"/centerX1" ),
			OSCFunc.new( { |data|
				network.setData( 13, [data[1]] );
			},"/centerX2" ),
			OSCFunc.new( { |data|
				network.setData( 23, [data[1]] );
			},"/centerXAll" ),

			OSCFunc.new( { |data|
				network.setData( 6, [data[1]] );
			},"/height1"),
			OSCFunc.new( { |data|
				network.setData( 16, [data[1]] );
			},"/height2"),
			OSCFunc.new( { |data|
				network.setData( 26, [data[1]] );
			},"/heightAll"),

			OSCFunc.new( { |data|
				network.setData( 7, [data[1]] );
			},"/width1"),
			OSCFunc.new( { |data|
				network.setData( 17, [data[1]] );
			},"/width2"),
			OSCFunc.new( { |data|
				network.setData( 27, [data[1]] );
			},"/widthAll"),
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