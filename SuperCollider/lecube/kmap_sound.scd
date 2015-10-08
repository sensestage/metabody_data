~kmap1 = KMap.newFrom( ~baseKmap );

(
~accs[0].addAction( \accelero, \pulse, { |v|
	Ndef( \pulse ).setUni( *~kmap1.getUni( * ([ [\x,\y,\z], v ].flop.flatten ) ) )
} );

~accs[1].addAction( \mean, \pulse, { |v|
	Ndef( \pulse ).setUni( *~kmap1.getUni( * ([ [\mx,\my,\mz], v ].flop.flatten ) ) )
} );
~accs[1].addAction( \stddev, \pulse, { |v|
	Ndef( \pulse ).setUni( *~kmap1.getUni( * ([ [\dx,\dy,\dz], v ].flop.flatten ) ) )
});
);

