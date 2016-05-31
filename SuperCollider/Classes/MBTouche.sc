MBTouche {

	var <values;
	var <maValues;
	var <>maCoef = 0.5;
	var <>action;

	// gui:
	var <guiOn = false;
	var <window,<plotter;

	*new{ |size=120|
		^super.new.init( size );
	}

	init{ |size=120|
		values = Array.fill( size, { 0 } );
		maValues = Array.fill( size, { 0 } );
	}

	peak{
		^maValues.maxIndexAndItem;
	}

	value_{ |newvalues|
		values = newvalues;
		maValues = ((1-maCoef)*newvalues) + (maCoef*maValues);
		if ( guiOn ){
			{ plotter.value_( maValues ) }.fork( AppClock );
		};
		if ( action.notNil ){
			action.value( maValues );
		};
	}


	gui{
		window = Window.new( "touche", Rect(0,0,500,300) );
		plotter = Plotter.new( "touche", Rect(0,0,500,300), window );
		plotter.value=maValues;
		plotter.specs_( [1,1023,\linear].asSpec );
		plotter.findSpecs_(false);
		window.front;
		window.isClosed( { this.guiOn = false; } );
		guiOn = true;
	}
}