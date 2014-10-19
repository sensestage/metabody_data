
import oscP5.*;
import netP5.*;

import peasy.*;


OscP5 oscP5;

PeasyCam cam;

String line;

PFont font;

int NUM_FIELDS = 5;
EyeField eyeFields[] = new EyeField[ NUM_FIELDS ];

/* ------------------------------- */
void setup()  { 
  
  size(600, 700, P3D); 
  frameRate(60);
  
  font = loadFont("Monaco-48.vlw");
  textFont(font, 12);


  cam = new PeasyCam(this, 0,-50,0, 450);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(1000);

  ambientLight(150, 150, 150, 0 , 50, 0);
  strokeWeight(1);
  colorMode(RGB, 100); 
  noFill();  

    /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12001);

  createFields();
}

String[] activityTags = { "/activityNormal1","/activityNormal2","/activityNormal3","/activityNormal4","/activityNormalAll" };
String[] sensitiveTags = { "/activitySensitive1","/activitySensitive2","/activitySensitive3","/activitySensitive4","/activitySensitiveAll" };
String[] centerTags = { "/centerX1", "/centerX2", "/centerX3", "/centerX4", "/centerXAll" };
String[] heightTags = { "/height1", "/height2", "/height3","/height4","/heightAll" };
String[] widthTags = { "/width1", "/width2", "/width3", "/width4", "/widthAll" };

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
//  print("### received an osc message.");
//  print(" addrpattern: "+theOscMessage.addrPattern());
//  println(" typetag: "+theOscMessage.typetag());

  for (int i = 0; i < activityTags.length; i++) {
    if(theOscMessage.checkAddrPattern( activityTags[i] )==true){
      if(theOscMessage.checkTypetag("f")) {
	float val = theOscMessage.get(0).floatValue();
	eyeFields[i].updateActivity( val );
	return;
      }
    }
  }

  for (int i = 0; i < sensitiveTags.length; i++) {
    if(theOscMessage.checkAddrPattern( sensitiveTags[i] )==true){
      if(theOscMessage.checkTypetag("f")) {
	float val = theOscMessage.get(0).floatValue();
	eyeFields[i].updateSensitive( val );
	return;
      }
    }
  }
  
  for (int i = 0; i < centerTags.length; i++) {
    if(theOscMessage.checkAddrPattern( centerTags[i] )==true){
      if(theOscMessage.checkTypetag("f")) {
	float val = theOscMessage.get(0).floatValue();
	eyeFields[i].updateCenterX( val );
	return;
      }
    }
  }

  for (int i = 0; i < heightTags.length; i++) {
    if(theOscMessage.checkAddrPattern( heightTags[i] )==true){
      if(theOscMessage.checkTypetag("f")) {
	float val = theOscMessage.get(0).floatValue();
	eyeFields[i].updateHeight( val );
	return;
      }
    }
  }

  for (int i = 0; i < widthTags.length; i++) {
    if(theOscMessage.checkAddrPattern( widthTags[i] )==true){
      if(theOscMessage.checkTypetag("f")) {
	float val = theOscMessage.get(0).floatValue();
	eyeFields[i].updateWidth( val );
	return;
      }
    }
  }

}


void createFields() {
  eyeFields[0] = new EyeField(this, "1", -100, -100, 0) ;
  eyeFields[1] = new EyeField(this, "2", 100, -100, 0) ;
  eyeFields[2] = new EyeField(this, "3", 100, 100, 0) ;
  eyeFields[3] = new EyeField(this, "4", -100, 100, 0) ;
  eyeFields[4] = new EyeField(this, "ALL", 0, -200, 0) ;
}

void draw()  {
  background(0);
  drawFields();
} 

void drawFields() {
  for (int i = 0; i < eyeFields.length; i++) {
    eyeFields[i].display();
  }
}
