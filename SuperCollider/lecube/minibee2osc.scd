(
~basePath = "".resolveRelative;
// start minibee2osc + find serial device
~minibeeSendAddress = ~minibeeSendAddress ? NetAddr.new( "127.0.0.1", 57600 );
// q.minibeeRecvPort = q.minibeeRecvPort ? 57130;
// ~minibeeSerial = "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_A800f91J-if00-port0"; // ADJUST this
// ~minibeeSerial = "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_A700eFmt-if00-port0";
~minibeeSerial = "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_A800f7Ue-if00-port0"; // q.minibeeSerial = "/dev/ttyUSB0"; // ADJUST this
~minibee2oscPath = "/home/nescivi/git/ssdn/minibee2osc/bin/minibee2osc"; // ADJUST this
// ~minibee2oscConfigfile = ~basePath +/+ "../../minibee2osc/configuration_lecube.xml";
// ~minibee2oscConfigfile = ~basePath +/+ "../../minibee2osc/configuration_lecube.xml";
~minibee2oscConfigfile = "/home/nescivi/git/steim/motors/minibee2osc/configuration_motor.xml";

(~minibee2oscPath + "-c" + ~minibee2oscConfigfile + "-s" + ~minibeeSerial + "-p" + NetAddr.langPort ).runInTerminal;

ShutDown.add( {
	// ~minibeeSendAddress.sendMsg( "/minihive/quit" ); // does not work yet
	"killall minibee2osc".unixCmd;
} );
);

"pydongui.py".runInTerminal;

(
OSCdef( \minibeeStatus, { |msg| msg.postln; }, "/minibee/status" );
OSCdef( \minibeeInfo,   { |msg| msg.postln; }, "/minibee/info" );
OSCdef( \minibeeData,   { |msg| msg.postln; }, "/minibee/data" );
OSCdef( \minibeePrivat, { |msg| msg.postln; }, "/minibee/private" );
);

OSCdef( \minibeeData ).free;

n = NetAddr.new( "127.0.0.1", 57600 );

// n.sendMsg( "/minibee/run", 1, 1 );