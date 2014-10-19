/**
 * PressurePad v0.1
 * Marije Baalman
 * 
 */
 
import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

class PressurePad {
 
  String id;
  float variation, pressure;
  color boxColor;
  float posX, posY, posZ;
  
  PressurePad (PApplet parent, String id, float posX, float posY, float posZ ) {
    this.id = id;

    this.posX = posX;
    this.posY = posY;
    this.posZ = posZ;
    
    this.variation = 0;
    this.pressure = 1; // one is minimal pressure, 0 is maximal pressure
        
    this.boxColor = color ( 100, 100, 10 );
  }
  
  public void display() {
    pushMatrix();  
      translate( posX, posY, posZ ); 
      drawBox();
      drawIdLabel();
    popMatrix();
  }
  
  public void updateVariation( float ac ){
    this.variation = ac;
  }
  
  public void updatePressure( float ac ){
    this.pressure = ac;
  }
    
  // indicates the variation in color, and the pressure in z-dimension
  private void drawBox(){    
    pushMatrix(); 
        noStroke();
        fill( boxColor, map( variation, 0, 1, 10, 150) );
        box( 50, 50, map( pressure, 1, 0, 10, 110) ); // width, height, dimension      
    popMatrix(); 
  }
      
  private void drawIdLabel() {
    pushMatrix();
      textAlign(CENTER);
      fill(255, 255, 255);
      stroke(0);
      
      scale(1);
      rotateY(0);
      
      text( this.id, 0, 0, 60);
    popMatrix();
  }
}

