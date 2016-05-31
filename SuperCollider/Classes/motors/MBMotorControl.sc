MBMotorControl {

	var <device;

	var <>temperature = 0, <>speed = 0, <>voltage = 0, <>encoder = 0;
	var <>error, <>limitError, <>serialError;

	//this needs to be fixed!
	*fromTwosComplement{ |v|
		var sign = [1,-1].at( v.asBinaryDigits.first );
		^(v.asBinaryDigits.keep(-7)*(Array.geom( 7, 2, 2 ).reverse)).sum * sign;
	}

	*int2bytes{ |v|
		^[ (v/256), v%256 ].floor(1).asInteger;
	}

	*long2bytes{ |v|
		^[ (v/16777216), (v/65536)%256, (v/256)%256, v%256 ].floor(1).asInteger;
	}

	*new{
		^super.new.init;
	}

	init{
	}


	device_{ |dev|
		device = dev;
		device.motorControl = this;
	}

	initMotor{
		if ( device.notNil ){
			device.sendMsg( $i, [ 0 ] );
		}{
			"MBMotorControl.device is nil!".warn;
		}
	}

	getInitMotorMsg{
		if ( device.notNil ){
			^device.getMsg( $i, [ 0 ] );
		}
	}

	exitSafe{
		if ( device.notNil ){
			device.sendMsg( $s, [ 0 ] );
		}{
			"MBMotorControl.device is nil!".warn;
		}
	}

	getExitSafeMsg{
		if ( device.notNil ){
			^device.getMsg( $s, [ 0 ] );
		}
	}

	moveMotor{ |direction, speed, duration|
		if ( device.notNil ){
			device.sendMsg( $m,
				[ direction.asInteger ] ++
				MBMotorControl.int2bytes( speed ) ++
				MBMotorControl.int2bytes( duration )
			);
		}{
			"MBMotorControl.device is nil!".warn;
		}
	}

	getMoveMotorMsg{ |direction, speed, duration|
		if ( device.notNil ){
			^device.getMsg( $m,
				[ direction.asInteger ] ++
				MBMotorControl.int2bytes( speed ) ++
				MBMotorControl.int2bytes( duration )
			);
		}
	}

	// mbSerial.setSerialCallback( 'h', serialHaltMotor );

	haltMotor{
		if ( device.notNil ){
			device.sendMsg( $h, [ 0 ] );
		}{
			"MBMotorControl.device is nil!".warn;
		}
	}

	getHaltMotorMsg{
		if ( device.notNil ){
			^device.getMsg( $h, [ 0 ] );
		}
	}


	// mbSerial.setSerialCallback( 'd', serialSetDirectionSign );
	setEncoderDirection{ |sign|
		if ( device.notNil ){
			device.sendMsg( $d, [ sign ] );
		}{
			"MBMotorControl.device is nil!".warn;
		}
	}

	getSetEncoderDirectionMsg{ |sign|
		if ( device.notNil ){
			^device.getMsg( $d, [ sign ] );
		}
	}

	// mbSerial.setSerialCallback( 'r', serialResetPosition );
	resetPosition{
		if ( device.notNil ){
			device.sendMsg( $r, [ 0 ] );
		}{
			"MBMotorControl.device is nil!".warn;
		}
	}

	getResetPositionMsg{
		if ( device.notNil ){
			^device.getMsg( $r, [ 0 ] );
		}
	}

	// mbSerial.setSerialCallback( 'p', serialMoveRelativePosition );
	/*
	moveRelativePosition{ | direction, speed, position|
		if ( device.notNil ){
			device.sendMsg( $p, [ direction ] ++
				MBMotorControl.int2bytes( speed ) ++
				MBMotorControl.long2bytes( position )
			);
		}{
			"MBMotorControl.device is nil!".warn;
		}
	}*/


}

MBMotorControlGui {

	var <>motorControl;

	var <temperature, <speed, <voltage, <encoder;
	var <error, <limitError, <serialError;

	var <motorSpeed, <motorDirection, <motorDuration, <motorGo;
	var <motorInitMotor, <motorExitSafe;

	var <motorPosition, <motorGo2;
	var <motorHalt, motorEncoderDirection, <motorResetPosition;

	var <window;
	var <skipJack;

	*new{ |id|
		^super.new.init( id );
	}

	init{ |id|
		window = Window.new( "Motor Control" + id, Rect( 0, 0, 400, 450 ) );
		window.addFlowLayout;

		motorDirection = EZSlider.new( window, Rect( 0, 0, 390, 30 ), "direction", [0,1,\linear,1].asSpec, labelWidth: 80 , initVal: 0 );
		motorSpeed = EZSlider.new( window, Rect( 0, 0, 390, 30 ), "speed", [0,2900,\linear,1].asSpec, labelWidth: 80 , initVal: 0 );
		motorDuration = EZSlider.new( window, Rect( 0, 0, 390, 30 ), "duration", [100,65000,\exponential,1].asSpec, labelWidth: 80 , initVal: 5000 );

		// motorPosition = EZSlider.new( window, Rect( 0, 0, 390, 30 ), "position", [100,65000,\exponential,1].asSpec, labelWidth: 80 , initVal: 5000 );

		motorGo = Button.new( window, Rect( 0,0,390, 30 ) ).states_( [ [ "MOVE MOTOR by DURATION" ] ] ).action_( { if ( motorControl.notNil ){
			motorControl.moveMotor( motorDirection.value, motorSpeed.value, motorDuration.value );
			}});

		// motorGo2 = Button.new( window, Rect( 0,0,390, 30 ) ).states_( [ [ "MOVE MOTOR by POSITION" ] ] ).action_( { if ( motorControl.notNil ){
		// motorControl.moveRelativePosition( motorDirection.value, motorSpeed.value, motorPosition.value );
// }});

		motorHalt = Button.new( window, Rect( 0,0,390, 30 ) ).states_( [ [ "HALT MOTOR" ] ] ).action_( { if ( motorControl.notNil ){
			motorControl.haltMotor;
			}});

		motorEncoderDirection = Button.new( window, Rect( 0, 0, 190, 30 ) ).states_( [[ "-" ], [ "+" ] ] ).value_(1).action_( { |v| if ( motorControl.notNil ){
			motorControl.setEncoderDirection( v.value );
		}});

		motorResetPosition = Button.new( window, Rect( 0, 0, 190, 30 ) ).states_( [[ "Reset pos" ]] ).action_( { |v| if ( motorControl.notNil ){
			motorControl.resetPosition;
		}});

		motorInitMotor = Button.new( window, Rect( 0, 0, 190, 30 ) ).states_( [[ "init motor" ] ] ).action_( { if ( motorControl.notNil ){
			motorControl.initMotor;
			}});

		motorExitSafe = Button.new( window, Rect( 0, 0, 190, 30 ) ).states_( [[ "exit safe" ] ] ).action_( { if ( motorControl.notNil ){
			motorControl.exitSafe;
			motorControl.error = "";
			motorControl.limitError = "";
			motorControl.serialError = "";
			}});

		encoder = EZNumber.new( window, Rect( 0, 0, 190, 30 ), "Position", [-1*(2**32),2**32].asSpec, labelWidth: 80  );
		speed = EZNumber.new( window, Rect(0,0, 190, 30), "Speed", [0,2**16].asSpec, labelWidth: 80 );
		temperature = EZNumber.new( window, Rect(0,0, 190, 30), "Temperature", ControlSpec.new( 0, 100, units: "C" ), labelWidth: 80, unitWidth: 20 );
		voltage = EZNumber.new( window, Rect(0,0, 190, 30), "Voltage", ControlSpec.new( 0, 100, units: "V" ), labelWidth: 80, unitWidth: 20 );

		error = EZText( window, Rect( 0,0,390, 20 ), "Error", labelWidth: 80 );
		limitError = EZText( window, Rect( 0,0,390, 20 ), "Limit Error" , labelWidth: 80 );
		serialError = EZText( window, Rect( 0,0,390, 20 ), "Serial Error", labelWidth: 80  );

		window.front;

		skipJack = SkipJack.new( { this.updateWindow }, 0.2, { window.isClosed } );
	}

	updateWindow{
		if ( motorControl.notNil ){
			temperature.value = motorControl.temperature;
			voltage.value = motorControl.voltage;
			speed.value = motorControl.speed;
			encoder.value = motorControl.encoder;

			error.value = motorControl.error;
			limitError.value = motorControl.limitError;
			serialError.value = motorControl.serialError;
		}
	}

}


MBMotorTaskControl {

	var <>motorControl;
	var <id;
	var <target;

	var <>taskProxy;
	var <>oscFunc;

	var <>gotMsg = false, <>newMsg = false, <>retries=0;

	var <>messageToSend;


	*new{ |id, target|
		^super.new.init( id, target );
	}

	init{ |i,tg|
		id = i;
		target = tg;
		this.createOSCFunc;
		this.createTask;
	}

	start{
		taskProxy.play;
	}

	sendMessage{ |message, sendNow=true|
		messageToSend = message;
		newMsg = sendNow;
	}

	createAndSendMessage{ |msg, msgArgs, sendNow=true|
		switch( msg,
			\move, { this.sendMessage( motorControl.getMoveMotorMsg( *msgArgs ), sendNow ) },
			\resetPosition, { this.sendMessage( motorControl.getResetPositionMsg( *msgArgs ), sendNow ) },
			\haltMotor, { this.sendMessage( motorControl.getHaltMotorMsg( *msgArgs ), sendNow ) },
			\exitSafe, { this.sendMessage( motorControl.getExitSafeMsg( *msgArgs ), sendNow ) },
			\initMotor, { this.sendMessage( motorControl.getInitMotorMsg( *msgArgs ), sendNow ) },
			\directionEncoder, { this.sendMessage( motorControl.getSetEncoderDirectionMsg( *msgArgs ), sendNow ) }
		);
	}

	stop{
		taskProxy.stop;
	}

	id_{ |i|
		id = i;
		this.createOSCFunc();
	}

	createOSCFunc{
		if (oscFunc.notNil ){
			oscFunc.free;
		};
		oscFunc = OSCFunc.new( { |msg|
			// could to check for matching message here:
			this.gotMsg = true;
		}, "/minibee/private", argTemplate: [ id ] );
	}

	createTask{
		if ( taskProxy.notNil ){
			taskProxy.stop;
		};
		taskProxy = TaskProxy.new( { |ev|
			loop{
				if ( this.motorControl.error.sum >= 2 ){
					this.messageToSend = this.motorControl.getInitMotorMsg();
					this.target.sendMsg( *(this.messageToSend) );
				}{
					if ( this.motorControl.error.sum == 1 ){
						this.messageToSend = this.motorControl.getExitSafeMsg();
						this.target.sendMsg( *(this.messageToSend) );
					}{
						if ( this.newMsg or: this.gotMsg.not ){
							// ev.messageTime = Main.elapsedTime;
							this.target.sendMsg( *(this.messageToSend) );
							this.newMsg = false;
							this.gotMsg = false;
						};
					};
				};
				0.1.wait;
				if ( this.gotMsg.not ){
					// if no reply within one second, resend
					// ev.newMsg = true;
					this.retries = this.retries + 1;
					"retry - message".postln;
				}{
					// keep waiting till loop is done, otherwise, just keep waiting for a new message to send
					this.retries = 0;
					this.newMsg = false;
				};
			}
		});
	}
}

MBMotorControlTaskGui {

	var <>motorControlTask;

	var <temperature, <speed, <voltage, <encoder;
	var <error, <limitError, <serialError;

	var <motorSpeed, <motorDirection, <motorDuration, <motorGo;
	var <motorInitMotor, <motorExitSafe;

	var <motorPosition, <motorGo2;
	var <motorHalt, motorEncoderDirection, <motorResetPosition;

	var <window;
	var <skipJack;

	*new{ |id|
		^super.new.init(id);
	}

	init{ |id|
		window = Window.new( "Motor Control" + id, Rect( 0, 0, 400, 450 ) );
		window.addFlowLayout;

		motorDirection = EZSlider.new( window, Rect( 0, 0, 390, 30 ), "direction", [0,1,\linear,1].asSpec, labelWidth: 80 , initVal: 0 );
		motorSpeed = EZSlider.new( window, Rect( 0, 0, 390, 30 ), "speed", [0,2900,\linear,1].asSpec, labelWidth: 80 , initVal: 0 );
		motorDuration = EZSlider.new( window, Rect( 0, 0, 390, 30 ), "duration", [100,65000,\exponential,1].asSpec, labelWidth: 80 , initVal: 5000 );

		// motorPosition = EZSlider.new( window, Rect( 0, 0, 390, 30 ), "position", [100,65000,\exponential,1].asSpec, labelWidth: 80 , initVal: 5000 );

		motorGo = Button.new( window, Rect( 0,0,390, 30 ) ).states_( [ [ "MOVE MOTOR by DURATION" ] ] ).action_( {
			if ( motorControlTask.notNil ){
				motorControlTask.createAndSendMessage( \move, [ motorDirection.value, motorSpeed.value, motorDuration.value ], true );
		}});

		// motorGo2 = Button.new( window, Rect( 0,0,390, 30 ) ).states_( [ [ "MOVE MOTOR by POSITION" ] ] ).action_( { if ( motorControl.notNil ){
		// motorControl.moveRelativePosition( motorDirection.value, motorSpeed.value, motorPosition.value );
// }});

		motorHalt = Button.new( window, Rect( 0,0,390, 30 ) ).states_( [ [ "HALT MOTOR" ] ] ).action_( { if ( motorControlTask.notNil ){
			motorControlTask.createAndSendMessage( \haltMotor, [], true );
			}});

		motorEncoderDirection = Button.new( window, Rect( 0, 0, 190, 30 ) ).states_( [[ "-" ], [ "+" ] ] ).value_(1).action_( { |v| if ( motorControlTask.notNil ){
			motorControlTask.createAndSendMessage( \directionEncoder, [v.value], true );
		}});

		motorResetPosition = Button.new( window, Rect( 0, 0, 190, 30 ) ).states_( [[ "Reset pos" ]] ).action_( { |v| if ( motorControlTask.notNil ){
			motorControlTask.createAndSendMessage( \resetPosition, [], true );
		}});

		motorInitMotor = Button.new( window, Rect( 0, 0, 190, 30 ) ).states_( [[ "init motor" ] ] ).action_( { if ( motorControlTask.notNil ){
			motorControlTask.createAndSendMessage( \initMotor, [], true );
			}});

		motorExitSafe = Button.new( window, Rect( 0, 0, 190, 30 ) ).states_( [[ "exit safe" ] ] ).action_( { if ( motorControlTask.notNil ){
			motorControlTask.createAndSendMessage( \exitSafe, [], true );
			motorControlTask.motorControl.error = "";
			motorControlTask.motorControl.limitError = "";
			motorControlTask.motorControl.serialError = "";
			}});

		encoder = EZNumber.new( window, Rect( 0, 0, 190, 30 ), "Position", [-1*(2**32),2**32].asSpec, labelWidth: 80  );
		speed = EZNumber.new( window, Rect(0,0, 190, 30), "Speed", [0,2**16].asSpec, labelWidth: 80 );
		temperature = EZNumber.new( window, Rect(0,0, 190, 30), "Temperature", ControlSpec.new( 0, 100, units: "C" ), labelWidth: 80, unitWidth: 20 );
		voltage = EZNumber.new( window, Rect(0,0, 190, 30), "Voltage", ControlSpec.new( 0, 100, units: "V" ), labelWidth: 80, unitWidth: 20 );

		error = EZText( window, Rect( 0,0,390, 20 ), "Error", labelWidth: 80 );
		limitError = EZText( window, Rect( 0,0,390, 20 ), "Limit Error" , labelWidth: 80 );
		serialError = EZText( window, Rect( 0,0,390, 20 ), "Serial Error", labelWidth: 80  );

		window.front;

		skipJack = SkipJack.new( { this.updateWindow }, 0.2, { window.isClosed } );
	}

	updateWindow{
		if ( motorControlTask.notNil ){
			if ( motorControlTask.motorControl.notNil ){
				temperature.value = motorControlTask.motorControl.temperature;
				voltage.value = motorControlTask.motorControl.voltage;
				speed.value = motorControlTask.motorControl.speed;
				encoder.value = motorControlTask.motorControl.encoder;

				error.value = motorControlTask.motorControl.error;
				limitError.value = motorControlTask.motorControl.limitError;
				serialError.value = motorControlTask.motorControl.serialError;
			}
		}
	}

}


MBMotorControlSerial{

	var <>motorControl;

	var <serial;
	var <>verbose = 0;

	*new{ |port|
		^super.new.init(port);
	}

	init{ |port|
		this.initSerial( port );
	}

	initSerial{ |port|
		serial = MBArduino.new( port, 57600 );

		serial.action = { |type,msg|
			switch( type,
				"T", { if ( msg.size > 2 ) {
					if ( motorControl.notNil ){
						motorControl.temperature = (msg[1]*256 + msg[2]) / 10;
					};
					if ( verbose > 2 ){
						"Temperature %\n".postf( (msg[1]*256 + msg[2]) / 10 );
					}
				} },
				"V", { if ( msg.size > 2 ) {
					if ( motorControl.notNil ){
						motorControl.voltage = (msg[1]*256 + msg[2]) / 1000;
					};
					if ( verbose > 2){
						"Voltage % mV\n".postf( msg[1]*256 + msg[2] );
					}
				} },
				"S", { if ( msg.size > 2 ) {
					if ( motorControl.notNil ){
						motorControl.speed = (					msg[1]*256 + msg[2]);
					};
					if ( verbose > 2){
						"Speed %\n".postf( msg[1]*256 + msg[2] );
					}
				} },
				"P", { if ( msg.size > 4 ) {
					if ( motorControl.notNil ){
						motorControl.encoder = (msg[1]<<24) + (msg[2]<<16) + (msg[3]<<8) + (msg[4]);
					};
					if ( verbose > 2){
						"Encoder %\n".postf( (msg[1]<<24) + (msg[2]<<16) + (msg[3]<<8) + (msg[4]) )
					}
				} },
				"E", { if ( msg.size > 2 ) {
					if ( motorControl.notNil ){
						motorControl.error = (msg[1].asBinaryDigits ++ msg[2].asBinaryDigits).keep(-9);
					};
					if ( verbose > 2){
						"Error: %\n".postf( (msg[1].asBinaryDigits ++ msg[2].asBinaryDigits).keep(-9) );
					}
				} },
				"X", { if ( msg.size > 2 ) {
					if ( motorControl.notNil ){
						motorControl.serialError = (msg[1].asBinaryDigits ++ msg[2].asBinaryDigits).keep(-5);
					};
					if ( verbose > 2){
						"Serial Error: %\n".postf( (msg[1].asBinaryDigits ++ msg[2].asBinaryDigits).keep(-5) );
					}
				} },
				"L", { if ( msg.size > 2 ) {
					if ( motorControl.notNil ){
						motorControl.limitError = (msg[1].asBinaryDigits ++ msg[2].asBinaryDigits).keep(-9);
					};
					if ( verbose > 2){
						"Limit Error: %\n".postf( (msg[1].asBinaryDigits ++ msg[2].asBinaryDigits).keep(-9) );
					}
				} },
				{ [type,msg].postln; }
			);
		};
	}

	sendMsg{ |type, data|
		if ( verbose > 1 ){
			[ "sendMsg", type, data ].postln;
		};
		if ( serial.notNil ){
			serial.sendMsg( type, data );
		}
	}

}


MBMotorControlMiniBee{

	var <>motorControl;

	var <netaddr;
	var <>id;
	var <>verbose = 0;

	var <oscFunc;

	*new{ |addr, id|
		^super.new.init(addr, id);
	}

	init{ |addr, myid|
		id = myid;
		this.netaddr_( addr );
	}

	netaddr_{ |addr|
		if ( oscFunc.notNil ){
			oscFunc.free;
		};
		netaddr = addr;
		oscFunc = OSCFunc.new( { |msg|
			if ( msg[1] == id, {
				if ( motorControl.notNil ){
					motorControl.encoder = (msg[2].asInteger<<24) + (msg[3].asInteger<<16) + (msg[4].asInteger<<8) + (msg[5].asInteger);
					motorControl.error = (msg[6].asBinaryDigits ++ msg[7].asBinaryDigits);
					// MBMotorControl.int2bytes( msg[9].asInteger ).collect{|it| it.asBinaryDigits	 }.flatten.keep(-9);
					motorControl.limitError = (msg[8].asBinaryDigits ++ msg[9].asBinaryDigits);
					// MBMotorControl.int2bytes( msg[10].asInteger ).collect{|it| it.asBinaryDigits	 }.flatten.keep(-9);
					motorControl.serialError = (msg[10].asBinaryDigits ++ msg[11].asBinaryDigits);
					// msg[11].asInteger.asBinaryDigits.keep(-5);
					motorControl.speed = msg[12];
					motorControl.voltage = msg[13];
					motorControl.temperature = msg[14];

				};
			});
		}, "/minibee/data" );
	}

	getMsg{ |type, data|
		if ( verbose > 1 ){
			[ "getMsg", type, data ].postln;
		};
		^([ "/minibee/custom", id, type.ascii ]++data);
	}

	sendMsg{ |type, data|
		if ( verbose > 1 ){
			[ "sendMsg", type, data ].postln;
		};
		if ( netaddr.notNil ){
			netaddr.sendMsg( *([ "/minibee/custom", id, type.ascii ]++data) );
		}
	}
}


