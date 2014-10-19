/**
 * EyeField v0.1
 * Marije Baalman
 * 
 */
 
import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

class EyeField {
 
  String id;
  float activityNormal, sensitive, centerX, heightY, widthX;
  color boxColor, sphereColor;
  float posX, posY, posZ;
  
  EyeField (PApplet parent, String id, float posX, float posY, float posZ ) {
    this.id = id;

    this.posX = posX;
    this.posY = posY;
    this.posZ = posZ;
    
    this.activityNormal = 0;
    this.sensitive = 0;
    this.centerX = 0.5;
    this.heightY = 0.5;
    this.widthX = 0;
        
    this.sphereColor = color ( 100, 10, 10 );
    this.boxColor = color ( 10, 10, 100 );
  }
  
  public void display() {
    pushMatrix();  
      translate( posX, posY, posZ ); 
      drawBox();
      drawSphere();
      drawIdLabel();
    popMatrix();
  }
  
  public void updateActivity( float ac ){
    this.activityNormal = ac;
  }
  
  public void updateSensitive( float ac ){
    this.sensitive = ac;
  }
  
  public void updateCenterX( float ac ){
    this.centerX = ac;
  }
  
  public void updateHeight( float ac ){
    this.heightY = ac;
  }
  
  public void updateWidth( float ac ){
    this.widthX = ac;
  }
  
  // indicates the activity in color, and the width in x-dimension
  private void drawBox(){    
    pushMatrix(); 
//        translate( -50, -50, 0 );
//        scale( 2 );
        //strokeWeight(1);
        //stroke(200, 50);
        noStroke();
        fill( boxColor, map(activityNormal, 0, 1, 10, 200) );
        box( map( widthX, 0, 1, 50, 100), 100, 10 ); // width, height, dimension      
    popMatrix(); 
  }
  
  // indicates position of centerX, height, and sensitive in color
  private void drawSphere() {
    pushMatrix();
//      println( centerX + "," + heightY );
	translate( map( centerX, 0, 1, -25, 25), map( heightY, 0, 1, -25, 25 ), 20 ); 
        noStroke();
        fill( sphereColor, map(sensitive, 0, 1, 10, 200) );
        sphereDetail( 12 );
        sphere(10);      
    popMatrix(); 
  }
    
  private void drawIdLabel() {
    pushMatrix();
      textAlign(CENTER);
      fill(255, 255, 255);
      stroke(0);
      
      scale(1);
      rotateY(0);
      
      text( this.id, 0, -50, 10);
    popMatrix();
  }
}

