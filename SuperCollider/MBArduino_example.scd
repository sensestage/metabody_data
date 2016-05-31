m = MBArduino.new( "/dev/ttyACM3", 57600 );

(
m.action = { |type,msg|
	[type,msg].postln;
};
);

// verbosity:

m.parser.verbose = 0;
m.parser.verbose = 2;

m.close;
// verbosity:

m.parser.verbose = 0;
m.parser.verbose = 2;
