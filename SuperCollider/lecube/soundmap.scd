s.boot;

NdefMixer.new(s);

// OSCdef( \minibeeData).free;
~accs = 3.collect{ MBAccelero.new };

OSCdef( \minibeeDat5a, { |msg| if ( msg[1] == 5 ){ ~accs[0].setData( msg.copyToEnd(2) ) ; } }, "/minibee/data" );
OSCdef( \minibeeDat6a, { |msg| if ( msg[1] == 6 ){ msg.postln; ~accs[1].setData( msg.copyToEnd(2) ) ; } }, "/minibee/data" );
OSCdef( \minibeeDat10a, { |msg| if ( msg[1] == 10 ){ ~accs[2].setData( msg.copyToEnd(2) ) ; } }, "/minibee/data" );

OSCdef( \minibeeData, { |msg| if ( msg[1] == 2 ){ Ndef( \phasor ).setUni( *(k.getUni( \p, msg[2]) ) ); ~pressure = msg[2]; ~accs[3].setData( msg.copyToEnd(3) ) ; } }, "/minibee/data" );


OSCdef( \minibeeData3, { |msg| if ( msg[1] == 3 ){ msg.postln; } }, "/minibee/data" );

OSCdef( \minibeeCE, { |msg| msg.postln; }, "/minibee/custom/error" );
OSCdef( \minibeeCS, { |msg| msg.postln; }, "/minibee/custom/success" );

k = KMap.new;
k.get( \p, 0.1 )
k.set( \p, msg[2] );
k.addPar( \p, \amp );
k.addSpec( \p, [1,0.75].asSpec );

~presSpec = [1,0.75].asSpec;
~vibSpec = [0,255,\linear,1].asSpec;
~pressure.specMap( ~presSpec, ~vibSpec );

(
Tdef( \updateVib, {
	loop{
		~minibeeSendAddress.sendMsg( "/minibee/output", 2, ~pressure.specMap( ~presSpec, ~vibSpec ).asInteger );
		1.0.wait; };
}).play;
);

~accs = ~accs.add(  MBAccelero.new );

// d = MBAcceleroSoundMap.new( \acc3 );
// d.accelero = ~accs[3];

// d.accelero.makeGui

b = MBAcceleroSoundMap.new( \acc0 );
b.accelero = ~accs[0];
b.accelero.makeGui;

c = MBAcceleroSoundMap.new( \acc2 );
c.accelero = ~accs[2];
c.accelero.makeGui;

a = MBAcceleroSoundMap.new( \pulse ); // inner tent
a.accelero = ~accs[1];

