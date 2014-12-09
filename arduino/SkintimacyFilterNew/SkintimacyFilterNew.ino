/**
 * Data from Skintimacy Players with Filter / Processing
 * by JPGS
 * 
 * Reads values from four Skintimacy Players connected to the
 * analog input pins 0-3. The values read from the sensors are proportional
 * to the amount of touch they receive from Skintimacy MASTER Player.
 * The values read pass through a Filter that makes them smoother
 * The filtered values are printed comma separated through the serial 
 * to use them in Processing
 * Based on Sending Multiple Data example
 * by BARRAGAN http://barraganstudio.com 
 * 
 * Skintimacy is an open project initiated by Alexander Mueller Rakow
 * at Design Research Lab | University of the Arts Berlin
 * http://skintimacy.org 
 */

// Skintimacy Players before filter
int skintimacyP1, skintimacyP2, skintimacyP3, skintimacyP4;

// Skintimacy Players after filter
int fSkintimacyP1, fSkintimacyP2, fSkintimacyP3, fSkintimacyP4;

// initialize filter
float m1,m2,m3,m4 = 0.0;

///-- start message protocol:
#define MAX_MESSAGE_SIZE 16
#define MAX_SEND_MESSAGE_SIZE 16

#define S_NO_MSG '0'
#define S_LOOPBACK 'L'

#define S_RAW 'R'
#define S_FILTERED 'F'

#define S_READY 'g'

#define ESC_CHAR '\\' 
#define DEL_CHAR '\n'
#define CR '\r'

uint8_t byte_index;
uint8_t escaping;

char incoming;
char msg_type;

// incoming message
uint8_t *message;
// outgoing message
char *sendMsg;

// -- end message protocol


void setup()
{
  Serial.begin(115200);
  setup_message();

}

void loop()
{
  // set SkintimacyPlayers to Analog Sensors
  skintimacyP1 = analogRead(0);  // read sensor in analog input 0
  skintimacyP2 = analogRead(1);  // read sensor in analog input 1
  skintimacyP3 = analogRead(2);  // read sensor in analog input 2
  skintimacyP4 = analogRead(3);  // read sensor in analog input 3

    // filter for Skintimacy Players
  float dif1 = skintimacyP1 - m1;
  if (abs(dif1) > 1.0) {
    m1 = m1 + dif1/10.0;
  }
  m1 = constrain(m1, 0, 1023);
  fSkintimacyP1=int(m1);

  float dif2 = skintimacyP2 - m2;
  if (abs(dif2) > 1.0) {
    m2 = m2 + dif2/10.0;
  }
  m2 = constrain(m2, 0, 1023);
  fSkintimacyP2=int(m2);

  float dif3 = skintimacyP3 - m3;
  if (abs(dif3) > 1.0) {
    m3 = m3 + dif3/10.0;
  }
  m3 = constrain(m3, 0, 1023);
  fSkintimacyP3=int(m3);

  float dif4 = skintimacyP4 - m4;
  if (abs(dif4) > 1.0) {
    m4 = m4 + dif4/10.0;
  }
  m4 = constrain(m4, 0, 1023);
  fSkintimacyP4=int(m4);
   
//   // alternatively print unfiltered values to Serial
//   Serial.print(skintimacyP1, DEC);    // print sensor 1
//   Serial.print(",");                 // print ','
//   Serial.print(skintimacyP2, DEC);   // print sensor 2
//   Serial.print(",");                 // print ','
//   Serial.print(skintimacyP3, DEC);   // print sensor 3
//   Serial.print(",");                 // print ','
//   Serial.println(skintimacyP4, DEC); // print sensor 4 and newline (println)
//   delay(50);                         // wait 50ms for next reading
  
  
  sendMsg[0] = skintimacyP1;
  sendMsg[1] = skintimacyP2;
  sendMsg[2] = skintimacyP3;
  sendMsg[3] = skintimacyP4;
  send_message( S_RAW, sendMsg, 4 );
  
//   sendMsg[0] = fSkintimacyP1;
//   sendMsg[1] = fSkintimacyP2;
//   sendMsg[2] = fSkintimacyP3;
//   sendMsg[3] = fSkintimacyP4;
//   send_message( S_FILTERED, sendMsg, 4 );
  
  delay( 5 );
}

// cut the code below and paste it into Processing

//// ======================= messaging interface =======================

void routeMsg(char type, uint8_t *msg, uint8_t size) {
// 	uint8_t curid = 255;
// 	uint8_t msgswitch = 0;
// 	switch(type) {
// 		case S_PRESET:
// 		  curid = msg[0];
// 		  preset1s[ curid-1 ] = msg[1];
// 		  preset2s[ curid-1 ] = msg[2];
// 		  preset3s[ curid-1 ] = msg[3];
// 		  preset4s[ curid-1 ] = msg[4];
// 		  if ( curid == rammelaarSelect ){
// 		    showSelectedRammelaar();
// 		  }
// 		  msgswitch = 1;
// 		  break;
// 		case S_RAMMELAAR_ON:
// 		  curid = msg[0];
// 		  rammelaars_connected[ curid ] = msg[1]; // on (1) or off (0)
// 		  showConnectedRammelaars();
// 		  showSelectedRammelaar();
// 		  msgswitch = 2;
// 		  break;
// 		case S_RAMMELAAR_SELECT:
// 		  if ( msg[0] < 4 ){
// 		      rammelaarSelect = msg[0];
// 		  }
// 		  msgswitch = 3;
// 		  showSelectedRammelaar();
// 		  break;
// 		case S_READY:
// 		  msgswitch = 4; // TODO: stop boot sequence
// 		  break;
// 		case S_LED:
// 		  strip.setPixelColor( msg[0], strip.Color( msg[1], msg[2], msg[3] ) );
// 		  strip.show();
// 		  msgswitch = 5;
// 		  break;
// 		case S_VOLUME:
// 		  msgswitch = 6;
// 		  volumeVal = msg[0];
// // 		  modes[2] = msg[1]; // aan/stil
// 		  setMode( 3, msg[1] );
// 		  break;
// 		case S_PATTERN:
// 		  msgswitch = 7;
// 		  patternVal = msg[0];
// // 		  modes[1] = msg[1]; // met/zonder begeleiding
// 		  setMode( 2, msg[1] );
// 		  break;
// 		case S_MODE_SELECT:
// 		  msgswitch = 8;
// // 		  modes[3] = msg[0]; // samen/solo
// 		  setMode( 4, msg[0] );
// 		  break;
// 		case S_BATTTH:
// 		  msgswitch = 9;
// 		  batteryThreshold = msg[0]*256 + msg[1];
// 		  break;
// 		case S_NOPATSNDS:
// 		  msgswitch = 10;
// 		  numberOfSoundsInPattern = msg[0];
// 		  break;
// 		default:
// 			break;
// 		}
// #ifdef SEND_LOOPBACK
//   for ( uint8_t i=0; i<size; i++ ){
//       sendMsg[i] = msg[i];
//   }
//   sendMsg[size] = type;
//   sendMsg[size+1] = msgswitch;
//   sendMsg[size+2] = curid;
//   send_message( S_LOOPBACK, sendMsg, size+3 );
// #endif
// #ifdef SEND_LOOPBACK
//   for ( uint8_t i=0; i<3; i++ ){
//       sendMsg[i] = rammelaars_connected[i];
//   }
//   sendMsg[3] = rammelaarSelect;
//   send_message( S_CONNECTED, sendMsg, 4 );
// #endif
}


void setup_message(){
    msg_type = S_NO_MSG;
    byte_index = 0;
    escaping = false;
    message = (uint8_t*)malloc(sizeof(uint8_t) * MAX_MESSAGE_SIZE);    
    sendMsg = (char *)malloc(sizeof(char)* MAX_SEND_MESSAGE_SIZE );
}

void send_message(char type, char *p, int size) {
	Serial.write(ESC_CHAR);
	Serial.write(type);
	for( uint8_t i = 0;i < size;i++) slip(p[i]);
	Serial.write(DEL_CHAR);
}

void slip(char c) {
	if((c == ESC_CHAR) || (c == DEL_CHAR) || (c == CR))
	    Serial.write(ESC_CHAR);
	Serial.write(c);
}

void read_serial() {
	incoming = Serial.read();
	if(escaping) {	//escape set
		if((incoming == ESC_CHAR)  || (incoming == DEL_CHAR) || (incoming == CR)) {	//escape to integer
			if ( msg_type != S_NO_MSG ){ // only add if message type set
			  message[byte_index] = (uint8_t) incoming;
			  byte_index++;
			}
		} else {	//escape to char
			msg_type = incoming;
		}
		escaping = false;
	} else {	//escape not set
		if(incoming == ESC_CHAR) {
			escaping = true;
		} else if(incoming == DEL_CHAR) {	//end of msg
			message[byte_index] = '\0'; // null-termination
			routeMsg(msg_type, message, byte_index);	//route completed message
			msg_type = S_NO_MSG;
			byte_index = 0;	//reset buffer index
		} else {
			if ( msg_type != S_NO_MSG ){ // only add if message type set
			  message[byte_index] = (uint8_t) incoming; 
			  byte_index++;
			}
		}
	}
}
