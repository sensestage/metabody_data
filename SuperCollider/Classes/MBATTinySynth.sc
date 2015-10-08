MBATTinySynth{

	var <>oscTarget;
	var <>id;

	var <lastPreset;

	var <amplitudes, <repeats, <offsets, <waves;
	var <frequencies, <envelopes, <durations;
	var <randomFreqs, <randomDurs, <randomModes;
	var <filter;
	var <filterEnable = true;
	var <>filterMax = 255;

	*new{ |id|
		^super.new.init(id);
	}

	sendControl{ |msg, name|
		oscTarget.sendMsg( *(["/minibee/custom", id ] ++ msg.clip(0,255).asInteger ) );
	}

	init{ |inputID|
		// tope = tp;
		id = inputID;
		// TODO: set defaults for sound
		frequencies = [50,20,2560];
		randomFreqs = Array.fill(3,0);
		randomModes = Array.fill(3,0);
		repeats = Array.fill(3,0);
		amplitudes = Array.fill(3,0);
		offsets = Array.fill(3,0);
		durations = Array.fill( 3, 512 );
		randomDurs = Array.fill(3,0);
		envelopes = Array.fill( 3, { [0,10,5,20] }).flatten;
		waves = [ 5, 5, 5 ]; // all sines
		filter = [1.0, 0,0, 0,0];
	}

	// settings for the sound
	//--- sound
	// trig:      2 ('S','T')
	trigger{ |viaSerial=false|
		if ( viaSerial ){
			this.sendControl( [ $S.ascii, $T.ascii ], \soundtriggerserial );
		}{
			this.sendControl( [ $T.ascii ], \soundtrigger );
		}
 	}

	// amplitude: 5 ('S','A',a1,a2,a3) - node 2
 	amplitude_{ |amps, send=true, sendChanged=true|
 		amplitudes = amps;
 		if ( send ){
			this.sendControl( [ $S.ascii, $A.ascii ] ++ amps, \soundamps );
 		};
 		if ( sendChanged ){
 			this.changed;
		}
	}

	// repeat :   5 ('S','H',h1,h2,h3)
	repeat_{ |reps, send = true, sendChanged=true|
		repeats = reps ? repeats;
 		if ( send ){
			this.sendControl( [ $S.ascii, $H.ascii ] ++ repeats, \soundrepeats );
 		};
		if ( sendChanged ){
			this.changed;
		}
	}

	// offset :   5 ('S','O',o1,o2,o3)
	offset_{ |offs, send=true, sendChanged=true|
		var offsetBytes;
		offsets = offs ? offsets;
		offsetBytes = offsets.collect{ |i| [ (i/256).floor, i%256 ] }.flatten;
 		if ( send ){
			this.sendControl( [ $S.ascii, $O.ascii ] ++ offsetBytes, \soundoffsets );
 		};
		if ( sendChanged ){
			this.changed;
		}
	}

	// wave :     5 ('S','W',w1,w2,w3)
	wave_{ |wvs, send=true, sendChanged=true|
		waves = wvs ? waves;
 		if ( send ){
			this.sendControl( [ $S.ascii, $W.ascii ] ++ waves, \soundwaves );
		};
		if ( sendChanged ){
			this.changed;
		};
	}

	// frequency: 8 ('S','F', freq1*2, freq2*2, freq3*2)
 	frequency_{ |freqs,send=true,sendChanged=true|
		frequencies = freqs ? frequencies;
 		if ( send ){
			this.sendControl( [ $S.ascii, $F.ascii ] ++ freqs.collect{ |i| [ (i/256).floor, i%256 ] }.flatten, \soundfreqs );
 		};
 		if ( sendChanged ){
 			this.changed;
		}
	}

	// duration:  8 ('S','L', dur1*2, dur2*2, dur3*2)
	duration_{ |durs,send=true,sendChanged=true|
		durations = durs ? durations;
 		if ( send ){
			this.sendControl( [ $S.ascii, $L.ascii ] ++ durs.collect{ |i| [ (i/256).floor, i%256 ] }.flatten, \sounddurs );
		};
		if ( sendChanged ){
			this.changed;
		}
	}

	filterEnable_{ |onoff, send=true, sendChanged=true|
		filterEnable = onoff;
		if ( send ){
			this.filter_( filter, true, false );
		};
		if ( sendChanged ){
			this.changed;
		}
	}

	// filter :   8 ('S','P', A0, A1, A2, B0, B1, signs)
	filter_{ |cfs,send=true,sendChanged=true|
		var abs, coefs;
		filter = cfs ? filter;
		abs = filter.abs.normalizeSum;
		coefs = ( abs.collect{ |it| ( it * filterMax ).floor } ) ++
 		(cfs.collect{ |it| if( it.sign>0){1}{0} } * [1,2,4,8,16] ).sum;
 		if ( send ){
			this.sendControl( [$S.ascii, $P.ascii ] ++ coefs, \soundfilter );
 		};
 		if ( sendChanged ){
 			this.changed;
		}
	}

	// random :   15 ('S','R', modes, r1*2, r2*2, r3*2, rd1*2, rd2*2, rd3*2)
	random_{ |mods,randfreqs,randdurs,send=true,sendChanged=true|
		randomModes = mods ? randomModes;
		randomFreqs = randfreqs ? randomFreqs;
		randomDurs = randdurs ? randomDurs;
		if ( send ){
			this.sendControl(
				[ $S.ascii, $R.ascii ]
				++ ( mods * [1,4,16] ).sum
				++ ( [randfreqs,randdurs].flop.flatten.collect{ |i| [ (i/256).round(1), i%256 ] }.flatten ), \soundrandom );
		};
		if ( sendChanged ){
			this.changed;
		};
	}

	// envelope: 14 ('S','E', 3*(phase, attack, decay, steps) )
	envelope_{ |envs,send=true,sendChanged=true|
		envelopes = envs ? envelopes;
 		if ( send ){
			this.sendControl( [ $S.ascii, $E.ascii ] ++ envelopes, \soundenv );
 		};
		if ( sendChanged ){ this.changed };
	}

	// all settings: 50 (2+(3*14)) ('S','S', 3*(modes, amp, dur*2,attack,decay,freq*2,offset,rand*2,rand*2,steps) + coefs filter (6)) )
	sendAll{
		var int2byte = { |int| [ (int/256).floor, int%256 ] };
		var msg,abs,coefs;
		//TODO: gather settings from all, and send it out
 		msg = 3.collect{ |i|
 			[ repeats[i].leftShift(7) + randomModes[i].leftShift(5) + envelopes[i*4].leftShift(3) + waves[i] ] ++
			amplitudes[i] ++
			int2bytes( offsets[i] ) ++
			// envelopes.at( [1,2,3] + (i*4) ) ++
			envelopes.at( [0,1,2] + (i*3) ) ++
 			int2byte.value( frequencies[i]) ++
 			int2byte.value( randomFreqs[i]) ++
			int2byte.value( durations[i] ) ++
 			int2byte.value( randomDurs[i])
 		}.flatten;
 		//msg = msg ++
 		abs = filter.abs.normalizeSum;
 		coefs = ( abs.collect{ |it| ( it * filterMax ).floor } ) ++ (filter.collect{ |it| if( it.sign>0){1}{0} } * [1,2,4,8,16] ).sum;
 		msg = msg ++ coefs;
		this.sendControl( [ $S.ascii, $S.ascii ] ++ msg, \soundsetAll );
 	}

	sendOneByOne{
		this.sendOne( 0 );
		this.sendOne( 1 );
		this.sendOne( 2 );
		this.filter();
	}

	sendOne{ |i|
		var msg;
		var int2byte = { |int| [ (int/256).floor, int%256 ] };
		msg = ([ repeats[i].leftShift(7) + randomModes[i].leftShift(5) + envelopes[i*4].leftShift(3) + waves[i] ] ++
			amplitudes[i] ++
			int2bytes( offsets[i] ) ++
			// envelopes.at( [1,2,3] + (i*4) ) ++
			envelopes.at( [0,1,2] + (i*3) ) ++
			int2byte.value( frequencies[i]) ++
			int2byte.value( randomFreqs[i]) ++
			int2byte.value( durations[i] ) ++
			int2byte.value( randomDurs[i])
		).flatten;
		this.sendControl( [ $S.ascii, $s.ascii, i ] ++ msg, (\soundset ++ i ).asSymbol );
	}

	asPreset{
		^NPPreset[
			\amplitudes -> amplitudes.copy,
			\repeats -> repeats.copy,
			\offsets -> offsets.copy,
			\waves -> waves.copy,
			\frequencies -> frequencies.copy,
			\envelopes -> envelopes.copy,
			\durations -> durations.copy,
			\randomFreqs -> randomFreqs.copy,
			\randomDurs -> randomDurs.copy,
			\randomModes -> randomModes.copy,
			\filter -> filter.copy,
			\filterMax -> filterMax.copy,
			\filterEnable -> filterEnable.copy
		];
	}

	storePreset{ |name,lib|
		var preset = this.asPreset;
		lastPreset = name.asSymbol;
		preset.lib = lib;
		preset.store( name );
		//		lib.store( name, this.asPreset );
	}

	fromPreset{ |preset, lib, send=true|
		if ( preset.isKindOf( NPPreset ) ){
			this.prFromPreset( preset, send );
		}{
			if ( lib.notNil and: preset.isKindOf( Symbol ) ){
				this.fromPreset( lib[ preset ] );
			}
		}
	}

	prFromPreset{ |preset, send=true|
		this.amplitude_( [0,0,0], true, false ); // initial silence
		lastPreset = preset[ \name ];
		this.amplitude_( preset[\amplitudes].copy, false, false );
		this.repeat_( preset[\repeats].copy, false, false );
		this.offset_( preset[\offsets].copy, false, false );
		this.wave_( preset[\waves].copy, false, false );
		this.frequency_( preset[\frequencies].copy, false, false );
		this.duration_( preset[\durations].copy, false, false );
		this.random_( preset[\randomModes].copy, preset[\randomFreqs].copy, preset[\randomDurs ].copy, false, false );
		this.envelope_( preset[\envelopes].copy, false, false );
		this.filterMax_( preset[\filterMax].copy );
		this.filterEnable_( preset[\filterEnable].copy ? true, false, false );
		this.filter_( preset[\filter].copy, send, false ); // send filter settings
		if ( send ){ // send oscillator settings
			this.sendOne( 0 );
			this.sendOne( 1 );
			this.sendOne( 2 );
			// this.sendAll;
		};
		this.changed;
	}

	guiClass{
		^NPSoloSoundGui;
	}
}
