
import oscP5.*;
import netP5.*;

import peasy.*;


OscP5 oscP5;

PeasyCam cam;

String line;

PFont font;

int NUM_PADS = 4;
PressurePad pads[] = new PressurePad[ NUM_PADS ];

/* ------------------------------- */
void setup()  { 
  
  size(600, 700, P3D); 
  frameRate(60);
  
  font = loadFont("Monaco-48.vlw");
  textFont(font, 12);


  cam = new PeasyCam(this, 0,0,0, 200);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(1000);

  ambientLight(150, 150, 150, 0 , 50, 0);
  strokeWeight(1);
  colorMode(RGB, 100); 
  noFill();  

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);

  createPads();
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
//  print("### received an osc message.");
//  print(" addrpattern: "+theOscMessage.addrPattern());
//  println(" typetag: "+theOscMessage.typetag());

  // in case of four minibees for the four pads
  if(theOscMessage.checkAddrPattern("/minibee/data")==true){
    if(theOscMessage.checkTypetag("if")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int minibeeID = theOscMessage.get(0).intValue();  
      float val = theOscMessage.get(1).floatValue();
//      println( "x :" + x + " y :" + y +" z :" + z );
      pads[minibeeID-1].updatePressure( val );
      return;
    }
  }
  if(theOscMessage.checkAddrPattern("/minibee/stddev")==true){
    if(theOscMessage.checkTypetag("if")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int minibeeID = theOscMessage.get(0).intValue();  
      float val = theOscMessage.get(1).floatValue();
      pads[minibeeID-1].updateVariation( val );
      return;
    }
  }

  // in case of four pads connected to one:
  if(theOscMessage.checkAddrPattern("/minibee/data")==true){
    if(theOscMessage.checkTypetag("iffff")) { // four pressure values in one
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int minibeeID = theOscMessage.get(0).intValue();  
      float val1 = theOscMessage.get(1).floatValue();
      float val2 = theOscMessage.get(2).floatValue();
      float val3 = theOscMessage.get(3).floatValue();
      float val4 = theOscMessage.get(4).floatValue();
      pads[0].updatePressure( val1 );
      pads[1].updatePressure( val2 );
      pads[2].updatePressure( val3 );
      pads[3].updatePressure( val4 );
      return;
    }
  }
  if(theOscMessage.checkAddrPattern("/minibee/stddev")==true){
    if(theOscMessage.checkTypetag("iffff")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int minibeeID = theOscMessage.get(0).intValue();  
      float val1 = theOscMessage.get(1).floatValue();
      float val2 = theOscMessage.get(2).floatValue();
      float val3 = theOscMessage.get(3).floatValue();
      float val4 = theOscMessage.get(4).floatValue();
      pads[0].updateVariation( val1 );
      pads[1].updateVariation( val2 );
      pads[2].updateVariation( val3 );
      pads[3].updateVariation( val4 );
      return;
    }
  }

}


void createPads() {
  pads[0] = new PressurePad(this, "1", -25, -25, 0) ;
  pads[1] = new PressurePad(this, "2", -25, 25, 0) ;
  pads[2] = new PressurePad(this, "3", 25, -25, 0) ;
  pads[3] = new PressurePad(this, "4", 25, 25, 0) ;
}

void draw()  {
  background(0);
  drawPads();
} 

void drawPads() {
  for (int i = 0; i < pads.length; i++) {
    pads[i].display();
  }
}
