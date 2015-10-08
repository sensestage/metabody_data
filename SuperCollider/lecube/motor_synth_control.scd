
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

~minibeeSendAddress.sendMsg( "/minibee/custom", 5, $T.ascii );

b = MBATTinySynth( 3 );
b.oscTarget_( ~minibeeSendAddress );

b.amplitude_( [ 10, 100, 200 ] );
b.repeat_( [ 1, 1, 0 ] );
b.wave_( [ 1, 0, 5 ] );
b.frequency_( [ 10, 30, 7000 ] );
b.envelope_( [ 20, 5, 10,  20, 5, 10, 10, 2, 20  ] );
b.duration_( [ 200, 200, 200 ] );
b.trigger();

~minibeeSendAddress.sendMsg( "/minibee/output", 1, 255 );
~minibeeSendAddress.sendMsg( "/minibee/output", 1, 0 );
~minibeeSendAddress.sendMsg( "/minibee/output", 2, 255 );
~minibeeSendAddress.sendMsg( "/minibee/output", 2, 0 );

OSCdef( \minibeeData, { |msg| msg.postln; }, "/minibee/data" );
OSCdef( \minibeeStatus, { |msg| msg.postln; }, "/minibee/status" );

OSCdef( \minibeeOutputError, { |msg| msg.postln; }, "/minibee/output/error" );
OSCdef( \minibeeOutputSucces, { |msg| msg.postln; }, "/minibee/output/success" );
