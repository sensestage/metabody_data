

~accs[2].makeGui

~accs[0].addAction( \accMapped, \test, { |data| data.postln; } );

~accs[0].removeAction( \accMapped, \test );



Ndef( \pulseMotorLow, { RLPF.ar( LFPulse.ar( \freq.kr(230).lag(0.1) * [1,2,3,4], 0, Phasor.ar(0, \rate.kr(1), \start.kr(0), \end.kr(1)), 0.5, -0.25), \ffreq.kr(240).lag(0.1) * [1,1,0.5,0.5], \rq.kr(0.1), [1,3/4,3/5,1/2] ).sum * \amp.kr(0.2) } );

Ndef( \pulseMotorLow ).play(5);

Ndef( \pulseMotorLow2, { RLPF.ar( LFPulse.ar( \freq.kr(150).lag(0.1) * [1,2,3,4], 0, Phasor.ar(0, \rate.kr(1), \start.kr(0), \end.kr(1)), 0.5, -0.25), \ffreq.kr(250).lag(0.1) * [1,1,0.5,0.5], \rq.kr(0.1), [1,3/4,3/5,1/2] ).sum * \amp.kr(0.2) } );

Ndef( \pulseMotorLow2 ).play(0);



Ndef( \pulseMotorLow ).addSpec( \freq, [ 200, 800, \exp ] );
Ndef( \pulseMotorLow ).addSpec( \ffreq, [ 400, 2000, \exp ] );
Ndef( \pulseMotorLow ).addSpec( \rate, [ 50, 200, \exp ] );
Ndef( \pulseMotorLow ).addSpec( \amp, [ 0.05, 1, \exp ] );
Ndef( \pulseMotorLow ).addSpec( \rq, [ 0.05, 0.2, \exp ] );

Ndef( \pulseMotorLow2 ).addSpec( \freq, [ 200, 800, \exp ] );
Ndef( \pulseMotorLow2 ).addSpec( \ffreq, [ 400, 2000, \exp ] );
Ndef( \pulseMotorLow2 ).addSpec( \rate, [ 50, 200, \exp ] );
Ndef( \pulseMotorLow2 ).addSpec( \amp, [ 0.05, 1, \exp ] );
Ndef( \pulseMotorLow2 ).addSpec( \rq, [ 0.05, 0.2, \exp ] );

~accs[1].addAction( \stdMapped, \freq, { |data| Ndef( \pulseMotorLow2 ).setUni( \freq, data[0] ) } );
~accs[1].addAction( \stdMapped, \ffreq, { |data| Ndef( \pulseMotorLow2 ).setUni( \ffreq, data[1] ) } );

~accs[1].addAction( \accMapped, \rate, { |data| Ndef( \pulseMotorLow2 ).setUni( \rate, data[2] ) } );

~accs[0].removeAction( \accMapped, \ffreq );

~accs[0].addAction( \stdMapped, \rate, { |data| Ndef( \pulseMotorLow ).setUni( \rate, data[2] ) } );
~accs[0].addAction( \stdMapped, \amp, { |data| Ndef( \pulseMotorLow ).setUni( \amp, data[0] ) } );
~accs[0].addAction( \stdMapped, \rq, { |data| Ndef( \pulseMotorLow ).setUni( \rq, data[1] ) } );

~accs[1].addAction( \stdMapped, \rate, { |data| Ndef( \pulseMotorLow2 ).setUni( \rate, data[2] ) } );
~accs[1].addAction( \stdMapped, \amp, { |data| Ndef( \pulseMotorLow2 ).setUni( \amp, data[0] ) } );
~accs[1].addAction( \stdMapped, \rq, { |data| Ndef( \pulseMotorLow2 ).setUni( \rq, data[1] ) } );

NdefMixer.new(s)