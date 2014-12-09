m = MBArduino.new( "/dev/ttyACM3", 115200 );

(
m.action = { |type,msg|
	[type,msg].postln;
};
);

// verbosity:

m.parser.verbose = 0;
m.parser.verbose = 2;
