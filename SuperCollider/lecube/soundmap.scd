s.boot;

NdefMixer.new(s);

// OSCdef( \minibeeData).free;
~accs = 3.collect{ MBAccelero.new };

OSCdef( \minibeeDat5a, { |msg| if ( msg[1] == 5 ){ ~accs[0].setData( msg.copyToEnd(2) ) ; } }, "/minibee/data" );
OSCdef( \minibeeDat6a, { |msg| if ( msg[1] == 6 ){ msg.postln; ~accs[1].setData( msg.copyToEnd(2) ) ; } }, "/minibee/data" );
OSCdef( \minibeeDat10a, { |msg| if ( msg[1] == 10 ){ ~accs[2].setData( msg.copyToEnd(2) ) ; } }, "/minibee/data" );




b = MBAcceleroSoundMap.new( \acc0 );
b.accelero = ~accs[0];

a = MBAcceleroSoundMap.new( \pulse ); // inner tent
a.accelero = ~accs[1];

c = MBAcceleroSoundMap.new( \acc2 );
c.accelero = ~accs[2];
