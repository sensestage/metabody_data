MBAcceleroSoundMap {

	var <name;
	var <kmap;
	var <sound; // ndef
	var <accelero;

	*new{ |name|
		^super.new.init(name);
	}

	init{ |nm|
		name = nm;
		kmap = KMap.new;
		this.initKMap;
	}

	initKMap{
		kmap.addSpec( \x, [ 0.44, 0.56 ].asSpec );
		kmap.addSpec( \dx, [ 0.001, 0.1, \exp ].asSpec );
		kmap.addSpec( \y, [ 0.44, 0.56 ].asSpec );
		kmap.addSpec( \dy, [ 0.001, 0.1, \exp ].asSpec );
		kmap.addSpec( \z, [ 0.44, 0.56 ].asSpec );
		kmap.addSpec( \dz, [ 0.001, 0.1, \exp ].asSpec );
		kmap.addSpec( \mx, [ 0.44, 0.56 ].asSpec );
		kmap.addSpec( \my, [ 0.44, 0.56 ].asSpec );
		kmap.addSpec( \mz, [ 0.44, 0.56 ].asSpec );
		kmap.addSpec( \fix, [ 0, 1.0 ].asSpec );
		kmap.addSpec( \fiy, [ 0, 1.0 ].asSpec );
		kmap.addSpec( \fiz, [ 0, 1.0 ].asSpec );
		kmap.addSpec( \fox, [ 0, 1.0 ].asSpec );
		kmap.addSpec( \foy, [ 0, 1.0 ].asSpec );
		kmap.addSpec( \foz, [ 0, 1.0 ].asSpec );
	}

	resetMap{
		this.removeMapping;
		kmap = KMap.new;
		this.initKMap;
		if ( accelero.notNil and: sound.notNil ){
			this.mapToSound;
		};
	}

	addSpec{ |...pairs|
		kmap.addSpec( *pairs );
	}

	addPar{ |inPar, outPar, weight|
		kmap.addPar( inPar, outPar, weight );
	}

	removePar{ |inPar, outPar|
		kmap.removePar( inPar, outPar );
	}

	addRound{ |inPar, round, outPar|
		kmap.addRound( inPar, round, outPar );
	}

	removeRound{ |inPar, outPar|
		kmap.removeRound( inPar, outPar );
	}

	removeMapping{
		if ( accelero.notNil ){
			accelero.removeAction( \accelero, name );
			accelero.removeAction( \mean, name );
			accelero.removeAction( \stddev, name );
			accelero.removeAction( \fadeInActivity, name );
			accelero.removeAction( \fadeOutActivity, name );
		}
	}

	accelero_{ |acc|
		this.removeMapping;
		accelero = acc;
		if ( sound.notNil ){ this.mapToSound };
	}

	sound_{ |snd|
		sound = snd;
		if ( sound.notNil ){ this.mapToSound };
	}

	mapToSound{
		accelero.addAction( \accelero, name, { |v|
			sound.setUni( *kmap.getUni( * ([ [\x,\y,\z], v ].flop.flatten ) ) )
		} );

		accelero.addAction( \mean, name, { |v|
			sound.setUni( *kmap.getUni( * ([ [\mx,\my,\mz], v ].flop.flatten ) ) )
		} );

		accelero.addAction( \stddev, name, { |v|
			sound.setUni( *kmap.getUni( * ([ [\dx,\dy,\dz], v ].flop.flatten ) ) )
		});

		accelero.addAction( \fadeInActivity, name, { |v|
			sound.setUni( *kmap.getUni( * ([ [\fix,\fiy,\fiz], v ].flop.flatten ) ) )
		});

		accelero.addAction( \fadeOutActivity, name, { |v|
			sound.setUni( *kmap.getUni( * ([ [\fox,\foy,\foz], v ].flop.flatten ) ) )
		});
	}

}