
~minibeeSendAddress.sendMsg( "/minibee/configuration", 3, 1 );
~minibeeSendAddress.sendMsg( "/minibee/configuration", 2, 1 );


~minibeeSendAddress.sendMsg( "/minihive/configuration/save", "lecube.xml" );

OSCFunc.trace(true);
OSCFunc.trace(false);

a = NPModule.new( ~minibeeSendAddress, 4 );
a.stepper.step( 1, 20, 20 )
a.stepper.step( 0, 255, 5 )

a.stepper.enableMotor( 0 );

a.stepper.sequence( 16, 0.dup(16), 100, 4, 1, 0 );

(
Tdef( \repeatRoll, {
	loop{
		a.stepper.sequence( 16, 1.dup(16), 250, 4, 1, 0 );
		30.wait;
	};
}).stop;
);

a.stepper.sequence( 16, 0.dup(16), 250, 4, 1, 0 );
a.stepper.sequence( 16, [1,0].dup(16).flatten, 250, 4, 1, 0 );

~minibeeSendAddress.sendMsg( "/minibee/custom", 3, $T.ascii );

v = MBATTinySynth( 11 );
v.oscTarget_( ~minibeeSendAddress );

v.amplitude_( [ 5, 100, 250 ] );
v.repeat_( [ 1, 1, 0 ] );
v.wave_( [ 1, 3, 5 ] );
v.frequency_( [ 5, 80, 3000 ] );
v.envelope_( [ 20, 5, 20,  20, 5, 20, 20, 2, 30  ] );
v.duration_( [ 200, 200, 200 ] );
v.trigger();



Tdef( \triggerSynth, { loop{ v.trigger(); 2.0.wait; } } ).play;

(
Tdef( \triggerSynth, {
	loop{
		10.do{ |i|
			v.frequency_( [ 5, 40, 100*i + 2000 ] );
			0.2.wait;
			v.trigger();
			5.0.wait;
		};
	}
} ).play;
);


v = MBATTinySynth( 12 );
v.oscTarget_( ~minibeeSendAddress );

v.amplitude_( [ 25, 60, 80 ] );
v.repeat_( [ 1, 1, 0 ] );
v.wave_( [ 1, 1, 6 ] );
v.frequency_( [ 5, 100, 2000 ] );
v.envelope_( [ 20, 5, 15,  20, 5, 15, 20, 2, 15  ] );
v.duration_( [ 200, 200, 200 ] );
v.filterEnable_( 1 );
v.filter_([ 1, 0.8, -0.5, 0.4, -0.8 ] );
v.filter_([ 1, 0.8, 0.25, 0.4, 0.8 ] );

v.filter
v
v.trigger();


TdefAllGui.new
Tdef( \triggerSynth, { loop{ v.trigger(); 2.0.wait; } } ).play;

(
Tdef( \triggerSynth, {
	loop{
		10.do{ |i|
			v.frequency_( [ 5, 40, 100*i + 2000 ] );
			0.2.wait;
			v.trigger();
			5.0.wait;
		};
	}
} ).play;
);


~minibeeSendAddress.sendMsg( "/minibee/output", 1, 255 );
~minibeeSendAddress.sendMsg( "/minibee/output", 1, 0 );
~minibeeSendAddress.sendMsg( "/minibee/output", 2, 255 );
~minibeeSendAddress.sendMsg( "/minibee/output", 2, 0 );


/// --------- from here onwards -----------

OSCdef( \minibeeData, { |msg| if ( msg[1] == 11 ){ a.setData( msg.copyToEnd( 2 ) ) }; }, "/minibee/data" );
OSCdef( \minibeeStatus, { |msg| msg.postln; }, "/minibee/status" );

a = MBAccelero.new;
a.makeGui;

v = MBATTinySynth( 11 );
v.oscTarget_( ~minibeeSendAddress );

v.amplitude_( [ 5, 100, 250 ] );
v.repeat_( [ 1, 1, 0 ] );
v.wave_( [ 1, 3, 5 ] );
v.frequency_( [ 5, 80, 3000 ] );
v.envelope_( [ 20, 5, 20,  20, 5, 20, 20, 2, 30  ] );
v.duration_( [ 200, 200, 200 ] );
v.trigger();

a.network[ \angleMean ].data[0]

~angleSpec = [30, 40, \linear ].asSpec;
~freqSpec = [ 1000, 8000, \exponential ].asSpec;

v.amplitude_( [ 5, 100, 250 ] );
v.repeat_( [ 1, 1, 0 ] );
v.wave_( [ 1, 3, 5 ] );
v.frequency_( [ 5, 80, 3000 ] );
v.envelope_( [ 20, 5, 20,  20, 5, 20, 20, 2, 30  ] );
v.duration_( [ 200, 200, 200 ] );
v.trigger();

(
Tdef( \checkAngle ).set( \thresholdOn1, 0.005, \thresholdOff1, 0.0025 );
Tdef( \checkAngle ).set( \thresholdOn2, 0.011, \thresholdOff2, 0.00125 );
Tdef( \checkAngle, { |ev|
	var freq, std;
	ev.wasTriggered = false;
	ev.wasTriggered2 = false;
	loop{
		std = a.network[ \stddev ].data.sum.postln;
		if ( std > ev.thresholdOn2 ){
			if ( ev.wasTriggered2.not ){
				"trig wave".postln;
				ev.wasTriggered2 = true;
				v.wave_( [ 1, 1, 6 ] );
				0.1.wait;
				v.trigger();
			};
		};
		if ( std < ev.thresholdOff2 ){
			v.wave_( [ 1, 1, 5 ] );
			ev.wasTriggered2 = false;
			0.1.wait;
			freq = a.network[ \angleMean ].data[0].specMap( ~angleSpec, ~freqSpec ).round(1);
			v.frequency_( [ 5, 80, freq.asInteger ] );
			0.1.wait;
		};

		if ( std > ev.thresholdOn1 ){
			if ( ev.wasTriggered.not ){
				ev.wasTriggered = true;
				v.trigger();
			};
		};
		if ( std < ev.thresholdOff1 ){
			ev.wasTriggered = false;
		};

		1.5.wait;
	}
});
);

a.removeAction( \angleMean, \beak );
a.addAction( \angleMean, \beak, { |v| } );

OSCdef( \minibeeOutputError, { |msg| msg.postln; }, "/minibee/output/error" );
OSCdef( \minibeeOutputSucces, { |msg| msg.postln; }, "/minibee/output/success" );

OSCdef( \minibeeCustomError, { |msg| msg.postln; }, "/minibee/custom/error" );
OSCdef( \minibeeCustomSucces, { |msg| msg.postln; }, "/minibee/custom/success" );

OSCdef( \minibeeCustomSucces ).free;