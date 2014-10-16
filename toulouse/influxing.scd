~influxes = 7.collect{ |it| Influx.new( [ \xm, \ym, \zm, \xs, \ys, \zs ], [\p1,\p2,\p3,\p4,\p5,\p6,\p7,\p8] ) };

(
~accs.do{ |it,i|
	it.addAction( \meanMapped, \influx, { |data|
		~influxes[i].set( \xm, data[0], \ym, data[1], \zm, data[2] );
	});
	it.addAction( \stdMapped, \influx, { |data|
		~influxes[i].set( \xs, data[0], \ys, data[1], \zs, data[2] );
	});
};
);

//// ------------------- testing code ------

~influxes[0].attachMapped( Ndef( \rlpf ) );

~influxes[0].detach( \rlpf );

//~influxes[0].rand

// store a preset:
~influxes[0].weights


