
import oscP5.*;
import netP5.*;

import peasy.*;



OscP5 oscP5;

int NUM_DATA_NODES = 12;
DataNode dataNodes[] = new DataNode[ NUM_DATA_NODES ];


PeasyCam cam;

String line;

PFont font;
boolean paused = true;

/* ------------------------------- */
void setup()  { 
  
  size(800, 800, P3D); 
  frameRate(60);
  
  font = loadFont("Monaco-48.vlw");
  textFont(font, 12);


  cam = new PeasyCam(this, 0,10,0, 200);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(500);

  ambientLight(150, 150, 150, 0 , 50, 0);
  strokeWeight(1);
  colorMode(RGB, 100); 
  noFill();  

    /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);

  createDataNodes();
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
 // print("### received an osc message.");
 // print(" addrpattern: "+theOscMessage.addrPattern());
 // println(" typetag: "+theOscMessage.typetag());
  
  if(theOscMessage.checkAddrPattern("/minibee/data")==true){
    if(theOscMessage.checkTypetag("ifff")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int minibeeID = theOscMessage.get(0).intValue();  
      float x = theOscMessage.get(1).floatValue() * 2 - 1 * 2;
      float y = theOscMessage.get(2).floatValue() * 2 - 1 * 2;
      float z = theOscMessage.get(3).floatValue() * 2 - 1 * 2;
//      println( "x :" + x + " y :" + y +" z :" + z );
      dataNodes[minibeeID-1].update( x, y, z );
      return;
    }
  }
  if(theOscMessage.checkAddrPattern("/minibee/stddev")==true){
    if(theOscMessage.checkTypetag("ifff")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int minibeeID = theOscMessage.get(0).intValue();  
      float x = theOscMessage.get(1).floatValue();
      float y = theOscMessage.get(2).floatValue();
      float z = theOscMessage.get(3).floatValue();
//      println( "x :" + x + " y :" + y +" z :" + z );
      dataNodes[minibeeID-1].update( x, y, z );
      return;
    }
  }
}

void createDataNodes() {
  dataNodes[0] = new DataNode(this, "head 1", -50, -50, 0) ;
  dataNodes[1] = new DataNode(this, "chest 1", -50, -20, 0) ;
  dataNodes[2] = new DataNode(this, "right arm 1", -90, -20, 0) ;
  dataNodes[3] = new DataNode(this, "left arm 1", -10, -20, 0) ;
  dataNodes[4] = new DataNode(this, "right foot 1", -60, 50, 0) ;
  dataNodes[5] = new DataNode(this, "left foot 1", -40, 50, 0) ;
  
  dataNodes[6] = new DataNode(this, "head 2", 50, -50, 0) ;
  dataNodes[7] = new DataNode(this, "chest 2", 50, -20, 0) ;
  dataNodes[8] = new DataNode(this, "right arm 2", 10, -20, 0) ;
  dataNodes[9] = new DataNode(this, "left arm 2", 90, -20, 0) ;
  dataNodes[10] = new DataNode(this, "right foot 2", 40, 50, 0) ;
  dataNodes[11] = new DataNode(this, "left foot 2", 60, 50, 0) ;
}

void draw()  {
  background(0);
  drawDataNodes();
} 

void drawDataNodes() {
  for (int i = 0; i < dataNodes.length; i++) {
    dataNodes[i].display( false );
  }
}
