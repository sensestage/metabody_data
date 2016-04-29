///-- start message protocol:
#define MAX_MESSAGE_SIZE 16
#define MAX_SEND_MESSAGE_SIZE 16

#define S_NO_MSG '0'
#define S_LOOPBACK 'L'

#define S_ANA 'A'


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
  int analogValue;
  // set SkintimacyPlayers to Analog Sensors
  analogValue = analogRead(1);

  sendMsg[0] = char (analogValue >> 8);
  sendMsg[1] = analogValue%256;
  send_message( S_ANA, sendMsg, 2 );
    
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
// 		  break;
// 		case S_RAMMELAAR_ON:
// 		  curid = msg[0];
// 		default:
// 			break;
// 		}
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
