s.boot;

NdefMixer.new(s);

(
// OSCdef( \minibeeData).free;
~accs = 3.collect{ MBAccelero.new };

OSCdef( \minibeeData1, { |msg| ~accs[0].setData( msg.copyToEnd(15) ) ; }, "/minibee/data", argTemplate: [ 1 ] );
OSCdef( \minibeeData2, { |msg| ~accs[1].setData( msg.copyToEnd(15) ) ; }, "/minibee/data", argTemplate: [ 2 ] );
OSCdef( \minibeeData3, { |msg| ~accs[2].setData( msg.copyToEnd(15) ) ; }, "/minibee/data", argTemplate: [ 3 ] );
);

(
a = MBAcceleroSoundMap.new( \acc0 );
a.accelero = ~accs[0];
a.accelero.makeGui;

b = MBAcceleroSoundMap.new( \acc2 );
b.accelero = ~accs[2];
b.accelero.makeGui;

c = MBAcceleroSoundMap.new( \pulse ); // inner tent
c.accelero = ~accs[1];
c.accelero.makeGui;
);


