TdefAllGui.new;

~microWash1.rgbw_( 255, 255, 255, 255 );
~microWash2.rgbw_( 255, 255, 255, 255 );

~microWash1.mode_( 0 );
~microWash2.mode_( 0 );

~microWash1.strobe_( 0 );
~microWash2.strobe_( 0 );

(
Tdef( \lightWave1, { |ev|
	loop{
		~microWash1.rgbw_( ev.red, ev.green, ev.blue, ev.white );
		0.05.wait;
	};
}).play;
);

(
Tdef( \lightWave2, { |ev|
	loop{
		~microWash2.rgbw_( ev.red, ev.green, ev.blue, ev.white );
		0.05.wait;
	};
}).play;
);

(
Tdef( \changeLightHues ).set( \saturation, 1, \hsvalue, 0.1 );
Tdef( \changeLightHues ).set( \upperHue, 0.5, \lowerHue, 0.2 );
Tdef( \changeLightHues, { |ev|
	loop{
		60.do{ |it|
			ev.currentHue = ( ( ev.upperHue - ev.lowerHue )*it/60 + ev.lowerHue ).wrap(0.0, 1.0);
			ev.newColor = Color.hsv( ev.currentHue, ev.saturation, ev.hsvalue, 1 );
			Tdef( \lightWave1 ).set( \red, (ev.newColor.red * 255).asInteger, \green, (ev.newColor.green * 255).asInteger, \blue, (ev.newColor.blue*255).asInteger );
			0.5.wait;
		};
		60.reverseDo{ |it|
			ev.currentHue = ( ( ev.upperHue - ev.lowerHue )*it/60 + ev.lowerHue ).wrap(0.0, 1.0);
			ev.newColor = Color.hsv( ev.currentHue, ev.saturation, ev.hsvalue, 1 );
			Tdef( \lightWave1 ).set( \red, (ev.newColor.red * 255).asInteger, \green, (ev.newColor.green * 255).asInteger, \blue, (ev.newColor.blue*255).asInteger );
			0.5.wait;
		}

	};
});
);


(
Tdef( \changeLightHues2 ).set( \saturation, 1, \hsvalue, 0.1 );
Tdef( \changeLightHues2 ).set( \upperHue, 0.2, \lowerHue, 0 );
Tdef( \changeLightHues2, { |ev|
	loop{
		60.do{ |it|
			ev.currentHue = ( ( ev.upperHue - ev.lowerHue )*it/60 + ev.lowerHue ).wrap(0.0, 1.0);
			ev.newColor = Color.hsv( ev.currentHue, ev.saturation, ev.hsvalue, 1 );
			Tdef( \lightWave2 ).set( \red, (ev.newColor.red * 255).asInteger, \green, (ev.newColor.green * 255).asInteger, \blue, (ev.newColor.blue*255).asInteger );
			0.5.wait;
		};
		60.reverseDo{ |it|
			ev.currentHue = ( ( ev.upperHue - ev.lowerHue )*it/60 + ev.lowerHue ).wrap(0.0, 1.0);
			ev.newColor = Color.hsv( ev.currentHue, ev.saturation, ev.hsvalue, 1 );
			Tdef( \lightWave2 ).set( \red, (ev.newColor.red * 255).asInteger, \green, (ev.newColor.green * 255).asInteger, \blue, (ev.newColor.blue*255).asInteger );
			0.5.wait;
		}

	};
});
);

Tdef( \changeLightHues ).play
Tdef( \changeLightHues2 ).play;



Tdef( \changeLightHues ).set( \upperHue, 1, \lowerHue, 0.7 );
Tdef( \changeLightHues2 ).set( \upperHue, 0.4, \lowerHue, 0.2 );

Tdef( \lightWave2 ).set( \red, 10, \green, 0, \blue, 0, \white, 0 );
Tdef( \lightWave1 ).set( \red, 10, \green, 0, \blue, 0, \white, 0 );
