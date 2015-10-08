/**
 * Copyright (c) 2011 Marije Baalman. All rights reserved
 *
 * This file is part of the MiniBee API library.
 *
 * MiniBee_API is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * MiniBee_API is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with MiniBee_API.  If not, see <http://www.gnu.org/licenses/>.
 */


/// in the header file of the MiniBee you can disable some options to save
/// space on the MiniBee. If you don't the board may not work as it runs
/// out of RAM.

/// Wire needs to be included if TWI is enabled

#include <Wire.h>

// #include <LIS302DL.h>
#include <ADXL345.h>
// #include <TMP102.h>
// #include <BMP085.h>
// #include <HMC5843.h>

#include <XBee.h>
#include <MiniBee_APIn.h>

// #include <LEDOSC.h>

#include <TimerZero.h>

#include <NewSoftSerial.h>
#include <MBSoftSerialProtocol.h>

MBSoftSerialProtocol mbserial;
NewSoftSerial softSerial(7, 6);

#define TRIGPIN 8


// #include "CircularBuffer64.h"
// #include <util/atomic.h>

// CircularBuffer64 <unsigned char> ledbuffer1; // fixed size 64
// CircularBuffer64 <unsigned char> ledbuffer2; // fixed size 64
// CircularBuffer64 <unsigned char> ledbuffer3; // fixed size 64

#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))


// unsigned char ledval1A = 0;
// unsigned char ledval2A = 0;
// unsigned char ledval3A = 0;
// 
// unsigned char ledval1 = 0;
// unsigned char ledval2 = 0;
// unsigned char ledval3 = 0;
// 
// 
// LEDOSC ledosc1 = LEDOSC();
// LEDOSC ledosc2 = LEDOSC();
// LEDOSC ledosc3 = LEDOSC();

uint8_t count = 0;

#define MAXSENDCOUNT 5
// uint8_t sendcount = 0;
uint8_t sendRead = 0;
#define SENDREADRATIO 10

// int micin;
// int aup = 500;
// int adown = 600;
// int envtrack = 0;
// int aup2, adown2;
// int envbase = 1000;

// uint8_t ldrvalue[4] = { 0, 0, 0, 0 };

// byte curADC = 0;
// byte curLDR = 0;
// volatile boolean startnewadc = true;
// boolean measureLDR = false;
// byte newadc;
// volatile boolean hasnewadc = false;

boolean trigger_sound = false;

MiniBee_API Bee = MiniBee_API();

/// this will be our parser for the custom messages we will send:
/// msg[0] and msg[1] will be msg type ('E') and message ID
/// the remainder are the actual contents of the message
/// if you want to send several kinds of messages, you can e.g.
/// switch based on msg[2] for message type
void customMsgParser( uint8_t * msg, uint8_t size, uint16_t source ){
  uint8_t id;
  uint8_t modebyte;
  switch( msg[2] ){
    case 'S': // set sound parameters
       mbserial.sendSerial( msg[3], &msg[4], size - 4 );
       break;
    case 'T':
       trigger_sound = true;
       break;
    }
}

/// we use a fixed configuration for the MiniBee, rather than use a remote wireless configuration
/// Here we define:
/// pins D3, D5, D6, D9, D10, D11 as analog outputs
/// pin D7 as digital input
/// pin D8 as digital output
/// pins A0, A1, A2 as analog inputs
/// and we use the onboard ADXL accelerometer via the TwoWire interface
// uint8_t myConfig[] = { 0, 0, 10, 0, 50, 1, // 'C', msgid, config id, msgInt high byte, msgInt low byte, samples per message
//   Custom, NotUsed, NotUsed, Custom, Custom, NotUsed, // D3 to D8 (D4 is reserved for status LED)
//   Custom, Custom, Custom, NotUsed, NotUsed,  // D9,D10,D11,D12,D13 (D12, D13 are also reserved)
//   Custom, Custom, Custom, Custom, NotUsed, NotUsed, NotUsed, NotUsed, // A0, A1, A2, A3, A4, A5, A6, A7
//   0
// };

void setup() {
  //   Bee.setRemoteConfig( 1 ); // 1 is id is remotely configured, configuration bytes are locally configured
//   Bee.setRemoteConfig( 0 ); // 0 is completely local configuration

  Bee.setup(57600, 'D' ); // arguments are the baudrate, and the board revision - this sends serial number and sets status to WAITFORHOST
  
  Bee.setCustomPin( TRIGPIN, 0 );
  pinMode( TRIGPIN, OUTPUT );
  Bee.setCustomPin( 6, 0 ); // serial to synth
  Bee.setCustomPin( 7, 0 ); // serial to synth
    
  // set the custom message function
  Bee.setCustomCall( &customMsgParser );
  
  /// read the configuration message, this will automatically configure all the pins
//   Bee.readConfigMsg( myConfig, 26 );  // this sends configuration summary and sets status to 

  // set the data rate for the NewSoftSerial port
  softSerial.begin(19200);  
  mbserial.setup( softSerial );
  
//   TimerZero::init(100,ledISR); // set period, attach updateControlWithAutoADC()
//   TimerZero::start();
}

// void ledISR(){  
//   count++;
// }

void loop() {
  count++;
  if ( count > MAXSENDCOUNT ){
    trigger_sound = false; // reset the pin
    count = 0;
    sendRead++;
    if ( (sendRead >= SENDREADRATIO) ){
      sendRead = 0;
// 	// do a loop step of the remaining firmware:
      Bee.loopStep( false );
    } else {
      Bee.loopReadOnly();
    }
  }
  if ( trigger_sound ){
    digitalWrite( TRIGPIN, 1 );
  } else {
    digitalWrite( TRIGPIN, 0 );
  }
  delay(1);
}
