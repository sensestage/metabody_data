// start pydongui:
("cd" + "".resolveRelative ++ "; pydongui.py").runInTerminal;

// receive the OSC data:
(
OSCdef( \minibeePost, { |msg|
	msg.postln;
}, "/minibee/data" );
);

OSCdef( \minibeePost ).free;

