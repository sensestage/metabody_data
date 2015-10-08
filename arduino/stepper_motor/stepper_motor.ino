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

#define ENABLE_FAULT_SENSE

#include <Wire.h>

// #include <LIS302DL.h>
#include <ADXL345.h>
// #include <TMP102.h>
// #include <BMP085.h>
// #include <HMC5843.h>

#include <XBee.h>
#include <MiniBee_APIn.h>

// #define LASER_PWM 6

#define STEPPER_STEP 3
#define STEPPER_DIRECTION 7

#define STEPPER_ENABLE 8
// #define STEPPER_SENSE 9

#define STEPPER_FAULT 10
#define STEPPER_RESET 11

#define STEPPER_M0 14
#define STEPPER_M1 15
#define STEPPER_M2 16

// #define DEFAULT_MAX_STEPS_FROM_HOME 60 // empirically found
// #define DEFAULT_MAX_STEPS_FROM_HOME 70 // empirically found
// #define DEFAULT_MAX_STEPS_FROM_HOME 150

#define MAX_INACTIVE_COUNT 50000

bool stepperFault = false;
bool stepperOn = false;

// bool laserIsOn = false;
// bool laserOnWhileStepping = false;
// bool laserOnInSequence = false;
// bool laserMayBeOn = true;

// uint8_t laserpwm_value = 0;

// uint8_t loopmsg[12];

uint16_t stepsPerStep = 10;
uint16_t stepPeriod = 100;
uint16_t inactiveCount = 0;
uint16_t stepDirections = 0;
uint8_t currentStep = 1;
uint8_t numberOfSteps = 0;
// bool inactiveCountOn = true;
bool countPause = true;
uint16_t pausecount = 0;
uint16_t pausetime = 200;

// int maxHomeCount = 60;
// bool stepperAtHome = false;
// int stepsFromHome = 0;
// int maxStepsFromHome = DEFAULT_MAX_STEPS_FROM_HOME; // 3/4 of a turn
// int default_max_steps_from_home = DEFAULT_MAX_STEPS_FROM_HOME;

uint8_t microStepMode = 1;

/// timing
// pulse on    - pulse off   - next step=pulse on
// start timer - timeout 1=A - timeout 2=B

// prescaler at 8
// #define STEP_PULSETIME 4 // double what datasheet says it needs
// prescaler at 1024 - empirically found value that works
// #define STEP_PULSETIME 15 // 
#define STEP_PULSETIME 20 // 
// prescaler at 1
// #define STEP_PULSETIME 64 // double what datasheet says it needs

uint16_t newstepdelayA = STEP_PULSETIME;
uint16_t newstepdelayB = STEP_PULSETIME*2;

// stepping:
uint8_t stepsToTake = 10;
uint8_t stepsTaken = 0;
bool stepping = false;


MiniBee_API Bee = MiniBee_API();

void stepMotorWithTimer( uint8_t direction, uint8_t steps, uint8_t delaytime ){
  if ( !stepperFault ){
    stepperOn = true;
    digitalWrite( STEPPER_ENABLE, LOW ); // enable stepper driver
    pausecount = 0;
    countPause = true;
//     laserOnWhileStepping = laserOnWhileMoving;
//     bool mayMoveThisTime;
    
    if( direction )         // Direction is HIGH (CW)
    {
	PORTD  &= ~(1 << STEPPER_DIRECTION);  // Set DIR pin LOW.
// 	mayMoveThisTime = !stepperAtHome && ( stepsFromHome > 0); // only move in this direction if not at home
// 	steps = constrain( steps, 0, stepsFromHome ); // constrain to the number of steps we are still allowed
    }
    else                    // Direction is LOW (CCW)
    {
	PORTD  |= (1 << STEPPER_DIRECTION);  // Set DIR pin HIGH.
// 	mayMoveThisTime = stepsFromHome < maxStepsFromHome; // we can only move a certain amount of steps from home
// 	steps = constrain( steps, 0, maxStepsFromHome - stepsFromHome ); // constrain to the number of steps we are still allowed
    }
//     if ( mayMoveThisTime ){ // don't move when we may not
//       if ( !laserOnWhileStepping ){
// 	  PORTD &= ~(1 << LASER_PWM); // turn laser off
//       }
      delayMicroseconds(1);
//       if ( direction ){
// 	stepsFromHome -= steps;
//       } else {
// 	stepsFromHome += steps; 
//       }
      newstepdelayB = constrain( delaytime, STEP_PULSETIME*2, 255 );
      newstepdelayA = newstepdelayB >> 1;
      stepsToTake = steps;
      stepsTaken = 0;
      stepping = true;
    }
  //   PORTD  |= (1 << 3 );  // set step high    
    // enable TIMER1 overflow interrupt
  //   TIMSK1 |= (1<<OCIE1A) | (1<<OCIE1B);
//   }
}


void createSequence( uint8_t noStepsInSeq, uint16_t directions, uint8_t nStepsPerStep, uint8_t steptime, uint16_t pause ){
    stepDirections = directions;
    numberOfSteps = noStepsInSeq;
    pausetime = pause;   
    stepsPerStep = nStepsPerStep;
    stepPeriod = steptime;
//     laserOnInSequence = laserOnWhileMoving;
        
    currentStep = 0;
    
    doSequenceStep();    
}

void doSequenceStep(){
  stepMotorWithTimer( (stepDirections>>currentStep) & 1, stepsPerStep, stepPeriod );
  currentStep++;
}


/// this will be our parser for the custom messages we will send:
/// msg[0] and msg[1] will be msg type ('E') and message ID
/// the remainder are the actual contents of the message
/// if you want to send several kinds of messages, you can e.g.
/// switch based on msg[2] for message type

// laser msg: 'L' on/off, pulse on/off, intensity (1), fadein (2), hold (2), fadeout (2), pulsetime (1) 
// servo msg: 'S' newposition (2), movetime (2*), resettime (2*)
// uint16_t scantime;
uint8_t id;
void customMsgParser( uint8_t * msg, uint8_t size, uint16_t source ){
  switch( msg[2] ){
    case 's': // single step
      stepMotorWithTimer( msg[3] & 0x01, msg[4], msg[5] );
      break;
    case 'S': // sequence 
      createSequence( constrain( msg[3] & 0x1F, 1, 16 ), (msg[4] << 8) + msg[5], msg[6], msg[7], msg[8]*256 + msg[9] );
      break;
    case 'm':
      setMicroStepMode( msg[3] );
      break;
//     case 'H':
//       findHome();
//       break;
//     case 'h':
//       setMaxStepsFromHome( msg[3]*256 + msg[4], msg[5] );
//       break;
    case 'R':
      stepperReset();
      break;
    case 'p':
      enableMotor( msg[3] );
      break;
  }
}

boolean clockticked = false;
boolean servomoving = false;

uint8_t beecnt = 0;
uint8_t beecnt2 = 0;

uint8_t motorstatus = 0;
// uint8_t laserstatus = 0;
uint16_t statustoserver[2];


// uint8_t myConfig[] = { 'C', 0, 10, 0, 100, 1, // configuration, null, config id, msgInt high byte, msgInt low byte, samples per message
//   Custom, NotUsed, NotUsed, NotUsed, Custom, Custom, // D3 to D8 (D4 is reserved for status LED)
//   NotUsed, Custom, Custom, NotUsed, NotUsed,  // D9,D10,D11,D12,D13 (D12, D13 are also reserved)
//   Custom, Custom, Custom, NotUsed, NotUsed, NotUsed, NotUsed, NotUsed, // A0, A1, A2, A3, A4, A5, A6, A7
//   0
// };

void setup() {  
//   Bee.setRemoteConfig( 0 ); // 1 is id is remotely configured, configuration bytes are locally configured

  Bee.setup(57600, 'D' ); // arguments are the baudrate, and the board revision
  
//   Bee.setCustomPin( LASER_PWM, 0 );
  Bee.setCustomPin( STEPPER_ENABLE, 0 );
  Bee.setCustomPin( STEPPER_DIRECTION, 0 );
  Bee.setCustomPin( STEPPER_M0, 0 );
  Bee.setCustomPin( STEPPER_M1, 0 );
  Bee.setCustomPin( STEPPER_M2, 0 );
//   Bee.setCustomPin( STEPPER_SENSE, 0 );
  Bee.setCustomPin( STEPPER_FAULT, 0 );
  Bee.setCustomPin( STEPPER_RESET, 0 );
  
  Bee.setCustomInput( 3, 1 ); // motor status, stepsToTake, stepstaken
  Bee.setCustomInput( 2, 2 ); // inactiveCount, pauseCount
    
  // set the custom message function
  Bee.setCustomCall( &customMsgParser );
  
//   Bee.readConfigMsg( myConfig, 26 );

    // Setup the outputs: pin 3 for STEP, pin 7 for DIR. Per DVR8825 pinout.
  DDRD   |= (1 << STEPPER_STEP);   // Enable pin 3 for OUTPUT to step the DRV8825
  DDRD   |= (1 << STEPPER_DIRECTION);   // Enable pin 5 for OUTPUT for step direction.
  PORTD  &= ~(1 << STEPPER_DIRECTION);  // Set DIR pin LOW.

//   pinMode( LASER_PWM, OUTPUT ); // laser
//   digitalWrite( LASER_PWM, LOW );
  
  pinMode( STEPPER_ENABLE, OUTPUT ); // enable motor
  digitalWrite( STEPPER_ENABLE, LOW );
  stepperOn = true;
  
  pinMode( STEPPER_M0, OUTPUT );
  pinMode( STEPPER_M1, OUTPUT );
  pinMode( STEPPER_M2, OUTPUT );
  setMicroStepMode( 1 );
  
  pinMode( STEPPER_RESET, OUTPUT );
  digitalWrite( STEPPER_RESET, HIGH );

//   pinMode( STEPPER_SENSE, INPUT );
  pinMode( STEPPER_FAULT, INPUT );

  noInterrupts();
  // configure Timer1 interrupts
  setupPwmTimer();
  interrupts();

//   // laser
//   laser.onoff = false;
//   laser.stage = OFF;
//   laser.pulse = false;
//   laser.time = 0;
    
//   delay(5);
//   findHome();
}

// uint8_t laserupdatecount = 0;

void loop() { 

  beecnt++;
//   laserupdatecount++;
  set_stepper();
  
//   if ( laserupdatecount > 5 ){
//     laserupdatecount = 0;
//     set_laser();
//     laser.time++;
//     laser.pulsetime++;
//   }
    
  // do a loop step of the remaining firmware:
  if ( beecnt > 10 ){ // every ten milliseconds - read incoming messages
    beecnt = 0;
    beecnt2++;
    
    if ( beecnt2 > 50 ){ // every 500 milliseconds - send status
      beecnt2 = 0;
//       laserstatus = (100 * laser.onoff) + (10 * laser.pulse) + laser.stage;
      motorstatus = (stepperFault) + (stepping<<1) + (stepperOn<<5);
//       statustoserver[0] = laser.current_intensity;
//       statustoserver[1] = stepsFromHome;
      statustoserver[0] = inactiveCount;
      statustoserver[1] = pausecount;
//       Bee.addCustomData( &laserstatus, 1 );
      Bee.addCustomData( &motorstatus, 1 );
      Bee.addCustomData( &stepsToTake, 1 );
      Bee.addCustomData( &stepsTaken, 1 );
      Bee.addCustomData( statustoserver, 2 );
      Bee.loopStep( false );
    } else {
      Bee.loopReadOnly();
    }
  }
  delay(1); // every 5 ms or so, do the callback
}

void set_stepper(){
#ifdef ENABLE_FAULT_SENSE
  stepperFaultSense();
#endif
  
  if ( !stepperFault ){
//     stepperHomeSense();
      
    if ( !stepping ){
//       laserMayBeOn = true;
      if ( countPause ){
	pausecount++;
      }
      
      if ( pausecount > pausetime ){
	  pausecount = 0;
	  if ( currentStep < numberOfSteps ){ // go to next step
	    doSequenceStep();
	  } else { // switches when over the number of steps
// 	    inactiveCountOn = true;
	    countPause = false; // stop counting the pause
	  }
      }
      
//       if ( inactiveCountOn && !laserIsOn ){
      if ( !countPause ){
	  inactiveCount++;
	  if ( inactiveCount > MAX_INACTIVE_COUNT ){
// 	    if ( !laserIsOn ){
		stepperOn = false;
		digitalWrite( STEPPER_ENABLE, HIGH ); // disable stepper driver
// 	    }
	    inactiveCount = 0;
	  }
      } else {
	inactiveCount = 0;
      }
//     } else {
//       laserMayBeOn = laserOnWhileStepping;
//     }
    }
  }  
}

// // this is actually a relatively slow procedure
// void set_laser(){
//   if ( laser.onoff ){ // if laser on:
//     if ( laser.time > laser.duration ){
// 	laser.stage = OFF;
//     }
//     // envelope of the laser:
//     switch( laser.stage ){
//       case OFF:
// 	laser.time = 0;
// 	laser.current_intensity = 0;
// 	laser.intensity_increment = int( (float) laser.intensity / (float) laser.fadein );
// 	break;
//       case FADEIN:
// 	laser.current_intensity += laser.intensity_increment;
// 	if ( laser.time > laser.fadein ){
// 	    laser.stage = HOLD;
// 	}
// 	break;
//       case HOLD:
// 	laser.current_intensity = laser.intensity;
// 	if ( laser.time > (laser.fadein + laser.hold) ){
// 	  laser.stage = FADEOUT;
// 	  laser.intensity_increment = int( (float) laser.intensity / (float) laser.fadeout );
// 	}
// 	break;
//       case FADEOUT:
// 	laser.current_intensity -= laser.intensity_increment;
// 	if ( laser.time > laser.duration ){
// 	  laser.stage = OFF;
// 	}
// 	break;
//     }
//     if ( laser.pulse ){
//       if ( laser.pulsetime < laser.pulseduty ){ // pulse duty on
// 	laser.currentvalue = (laser.current_intensity>>8);
//       } else if ( laser.pulsetime < laser.pulsedur ) { // pulse duty off
// 	laser.currentvalue = 0;
//       } else { // end of pulse, reset to start
// 	laser.currentvalue = 0;
// 	laser.pulsetime = 0;
//       }
//     } else {
//       laser.currentvalue = (laser.current_intensity>>8);
//     }
//   } else {
//     laser.stage = OFF; 
//     laser.current_intensity = 0;
//     laser.currentvalue = 0;
//   }
//   if ( laserMayBeOn && !stepperFault ){
//     laserIsOn = laser.currentvalue > 0;
//     if ( laserIsOn ){
//       stepperOn = true;
//       digitalWrite( STEPPER_ENABLE, LOW ); // enable stepper driver
//     }
//     analogWrite( LASER_PWM, laser.currentvalue );    
//   } else {
//     laserIsOn = false;
//     digitalWrite( LASER_PWM, 0 ); // laser off
//   }
// }


/// stepper routines



ISR(TIMER1_COMPA_vect){
  // pulse step low
  PORTD  &= ~(1 << STEPPER_STEP);  // set step low
  
  OCR1A = newstepdelayA;
  OCR1B = newstepdelayB;
}

// after 2nd timeout
ISR(TIMER1_COMPB_vect){  
  //  reset timer counter
  TCNT1 = 0;  
  if ( stepping ){
    stepsTaken++;
    if ( stepsTaken < stepsToTake ){
      PORTD  |= (1 << STEPPER_STEP );  // set step high     
      // pulse step high
    } else {
      stepping = false;
    }
  }
//   OCR1A = servos[servo].oldvalue;
}


/*
16bit Normal Mode,
timer now counts from 0..65535
pwm frequency
F_CPU/(OCR1A+OCR1B)
F_CPU/(servoMax+1)/numServos 
16e6/33601/4 = 119Hz
12e6/33601/4 = 89Hz
*/
void setupPwmTimer(){
// Timer1 for our PWM output
// clear Timer1 Modes and Prescaler
  TCCR1A = 0;
  TCCR1B = 0;
// set prescaler to 1, 1=1, 2=8, 3=64, 4=256, 5=1024
//   TCCR1B = (TCCR1B & 0xf8) | 0x01;
//   TCCR1B = (TCCR1B & 0xf8) | 0x02; 
  TCCR1B = (TCCR1B & 0xf8) | 0x05; 
  // set inital TIMER1 Compare values
  OCR1A = STEP_PULSETIME;
  OCR1B = STEP_PULSETIME*2;
  
// enable TIMER1 overflow interrupt
  TIMSK1 |= (1<<OCIE1A) | (1<<OCIE1B);
}



// stepper home routine

// void stepperHomeSense(){
//   if ( digitalRead( STEPPER_SENSE ) == 1 ){ // detected home
//     if ( !stepperAtHome ){
//       // we are at home:
//       stepsFromHome = 0;
//     }
//     stepperAtHome = true;
//   } else {
//     stepperAtHome = false;
//   }
// }
// 
// void setMaxStepsFromHome( int maxsteps, int maxcount ){
//   default_max_steps_from_home = maxsteps;
//   maxStepsFromHome = default_max_steps_from_home * microStepMode;
//   maxHomeCount = maxcount;
// }
// 
// void findHome(){
//   int homecount = 0;
//   stepsFromHome = default_max_steps_from_home * microStepMode * 2; // assume we are at the maximum distance, times two, so we always know we will hit it
//   while( !stepperAtHome ){
//       stepMotorWithTimer( 1, 3, 50, false );
//       stepperHomeSense();
//       homecount++;
//       if ( homecount > maxHomeCount ){
// 	  stepperAtHome = true;
//       }
//       delay(100);
//   }
//   // we are at home:
//   stepsFromHome = 0;
// }

void setMicroStepMode( uint8_t mode ){
//   stepsFromHome = stepsFromHome * mode / microStepMode;
  microStepMode = mode;
//   maxStepsFromHome = default_max_steps_from_home * mode;  
  switch( mode ){
    case 1: // full
      digitalWrite( STEPPER_M0, 0 );
      digitalWrite( STEPPER_M1, 0 );
      digitalWrite( STEPPER_M2, 0 );
      break;
    case 2: // half
      digitalWrite( STEPPER_M0, 1 );
      digitalWrite( STEPPER_M1, 0 );
      digitalWrite( STEPPER_M2, 0 );
      break;
    case 4: // quarter
      digitalWrite( STEPPER_M0, 0 );
      digitalWrite( STEPPER_M1, 1 );
      digitalWrite( STEPPER_M2, 0 );
      break;
    case 8: // eighth
      digitalWrite( STEPPER_M0, 1 );
      digitalWrite( STEPPER_M1, 1 );
      digitalWrite( STEPPER_M2, 0 );
      break;
    case 16: // sixteenth
      digitalWrite( STEPPER_M0, 0 );
      digitalWrite( STEPPER_M1, 0 );
      digitalWrite( STEPPER_M2, 1 );
      break;
    case 32: // 32th
      digitalWrite( STEPPER_M0, 1 );
      digitalWrite( STEPPER_M1, 0 );
      digitalWrite( STEPPER_M2, 1 );
      break;
  }
}

void enableMotor( uint8_t onoff ){
  stepperOn = onoff;
  digitalWrite( STEPPER_ENABLE, 1-onoff ); // enable stepper driver
}

void stepperReset(){
  digitalWrite( STEPPER_RESET, LOW );
  delay( 100 );
  digitalWrite( STEPPER_RESET, HIGH );
  delay( 10 );
  stepperFault = false;
}

void stepperFaultSense(){
  if ( digitalRead( STEPPER_FAULT ) == 0 ){ // detected fault
      stepperFault = true;
      // need to reset after a certain amount of time      
//   } else {
//       stepperFault = false;
  }
}
