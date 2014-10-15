s.boot;

Ndef( \soundtest, { WhiteNoise.ar(0.05) } );

Ndef( \soundtest ).play(0);
Ndef( \soundtest ).play(1);

Ndef( \soundtest ).stop;

// channel 0 is low frequency
// channel 1 is full range