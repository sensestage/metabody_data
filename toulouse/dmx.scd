// This creates an instance of the DMX class (see the DMX quark):
d = DMX.new;
// create a DMX device (the argument is the serial path at which it can be reached; see SerialPort.devices)
e = EntTecDMXUSBPro.new( "/dev/ttyUSB1" );
// set the device for DMX
d.device = e;

// create an empty cue:
c = DMXCue.new;
// these are the work lights in one part of the room (DMX channels 98, 100, 102)

(
Tdef( \testLights, {
	(60..100).do{ |it|
		c.put( it, 1 );
		d.currentCue = c;
		d.setCue;
		it.postln;
		0.5.wait;
	};
}).play;
);


c.put( 1, 0.5 ); d.currentCue = c; d.setCue; // mid front two

c.put( 2, 1 ); d.currentCue = c; d.setCue; // right corner

c.put( 3, 0.75 ); d.currentCue = c; d.setCue; // middle

c.put( 5, 1 ); d.currentCue = c; d.setCue; // two back mid

c = DMXCue.new; d.currentCue = c; d.setCue; // blackout

c.put( 3, 0.25 ); c.put( 5, 0.25 ); d.currentCue = c; d.setCue; // mid front two

c.put( 1, 0 ); d.currentCue = c; d.setCue; // mid front two
