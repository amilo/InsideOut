
//import Minim library
import ddf.minim.*;
import ddf.minim.UGen;
  
//import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
  
//for displaying the sound's frequency
  import ddf.minim.analysis.*;
  import ddf.minim.ugens.*;


/**
  * InsideOut - visualScape for audio content - 
  * first developed during Summer2014 -
  * new version for Autumrn2015 - Arno Babajanian concert
  * at Queen Mary University of London for InsideOut event
  *@author     Alessia Milo  contact@alessiamilo.com
  *@version    1.1
  *@since      Summer 2014
  */


//int fps = 30;
  PeasyCam cam;
  Minim minim;
  float rightShift; //this is for right channel (cello)
  float leftShift; // this is for left channel (violin and piano)
  
  float rightShiftTotal;
  float leftShiftTotal;
  
  int hueValue;
  int hueValueG;
    
  int count;
  int spacing;
  int string =440;
  int hueMidi =0;
  int satMidi = 0;
  int brightMidi = 0;
   int channel = 0;
  int pitch = 64;
  int velocity = 127;
  int number = 0;
  int value = 90;
  int []values;
  
 
 boolean COLORCIRCLE = false;
  
  boolean playStart = false;
  boolean listeningMode = false;
  
   int mode = 0; //drawing mode
  
//to make it play song files
 AudioPlayer song;
   //to make it "hear" audio input
  AudioInput in;

  //float sum=-5000000; // this parameter is how long it goes floating on and off
    float sum=-5000000; // this parameter is how long it goes floating on and off
color bg = color(255, 0, 0);


//for displaying the sound's frequency
  FFT fft;

void setup() {

  
 // fullScreen();
  //sketch size
    //size(1200, 800, P3D); //do the adjustable size
     //size(1280, 1024, P3D); //do the adjustable size
     //size(800, 600, P3D); //do the adjustable size
     size(1280, 600, P3D);
     
     noCursor();
     ((javax.swing.JFrame)frame).getContentPane().setBackground(java.awt.Color.black);
    
     //surface.setResizable(true);
     //PeasyCam
    cam = new PeasyCam(this, width/2,height/2,500,50);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(3000);
  
  
 background(0,0);
 //if implementing 3rd movement
 //background ( value, 0);

// frameRate(20);
 textureMode(NORMAL);
 
  
  minim = new Minim(this);
 
  
  //load the song you want to play
  //drag the file into your sketch window
  //and replace "mysong.mp3" with the file name
 in = minim.getLineIn(Minim.STEREO, 2048);

 song = minim.loadFile("TEST.wav", 2048);
 

 song.play();
  
  //an FFT needs to know how 
  //long the audio buffers it will be analyzing are
  //and also needs to know 
  //the sample rate of the audio it is analyzing
  
  //do something to switch between playback and live and 
//   fft = new FFT(in.bufferSize(), in.sampleRate());
  
 fft = new FFT(song.bufferSize(), song.sampleRate());
    //count=0;
  
    //values= new int[16];
    
}
 
void draw(){
  
  if (mode == 0){
    return;
  }
  
  else if  (mode != 0) {
    
 fft.forward(in.mix);
// fft.forward(song.mix);


    

    smooth();
    //noStroke();
    stroke(255,20);
    strokeWeight(1);
    ellipseMode(CENTER);
    
    //ellipse(width/2, height - fft.getBand(1)*100-height/3,
            //in.left.get(1)*800, in.right.get(1)*800);
   //ambient(250, 250, 250);
  //pointLight(255, 255, 255, 0, 0, 200);  
     
     
pushMatrix();
  //translate(width/2, height/2, -200 - 100*sin(frameCount/100*PI));
  
  //this goes far behind
  translate(width/2 - rightShiftTotal/200 , height/2+leftShiftTotal/200 , -1000);
 //rotateX(-PI/2+frameCount*PI/(sum/fft.specSize()));
 
 rotateX(+PI/2 + frameCount *  PI/(sum/fft.specSize()));
 
 
   //rotateX(-PI/2 + frameCount * PI / 100);
  //rotateX(frameCount*(-PI/3));
  //rotateY(frameCount * PI / 50); 
  //rotateY(frameCount * PI / 50);
  
  
  //rotateY(frameCount * PI / 300);
  
 // rotateZ(frameCount * PI / 300);
  
   rotateZ(frameCount * PI / (100+sum));
  
  //rotateZ(frameCount * PI /4); 
 //if (sum>10000000){
   if (sum>50000){
    sum = -sum;
    println("reverse sum");
  }
    for(int i=1; i < fft.specSize(); i++){   //specsize is 2048  bins
      
      if (i== 1) {
        
      leftShiftTotal = 0;
     rightShiftTotal = 0;
      }
      
      
      sum=fft.getBand(i)+sum;  // the amount sum is increased according to the energy that is put into the variable, for each bin
  
       leftShift= int(map(in.left.get(i),-1, 1, 0, 100));   //  we are getting the left input - we will try a butterfly  one  floating left, one floating right
       rightShift= int(map(in.right.get(i),-1, 1, 0, +100)); // the input from the right microphone is mapped from -0.5 to 0.5 between 0 + 12, while for left -12, 0
       //we will use this input as something which will pull the image more right or left. If the balance from both microphones is the same they will be equally pulled
     
     //how to achieve this? one way is to plot three different images. One is the central one, which takes both the inputs, while the left and the right are on the side
     
       
       //leftShift= int(map(song.left.get(i),-0.5, 0.5, -12, 0));
       //rightShift= int(map(song.right.get(i),-0.5, 0.5, 0, +12));
       
      //int alpha = int(map(fft.getBand(i),0, 500, 30, 200));
       //println (  song.left.get(i));
       //println ("for index" + i + "green ="  + green);
       /*
       construct a frequency analyzer
       hueMidi = map ((i), 44
       
       
       */
       
     //float x = log2(i)/log2(fft.specSize())*width + 20 ;
       float x = log2(2*i)*-150 ;    //  x is the x coordinate of the frequency bin - it depends on specsize
    
        //float y = log2(fft.getBand(i))*100;
        float y = log2(fft.getBand(i))*90;  //   this is the input of the bin multiplied for a factor (hard-coded 90) //change factor
//        println(fft.getBand(i));  //test
        float yD = map (y, 0, 400, 0, 128); // this is  a further mapping of  the yD 
        int alpha = int(map (y, 0, 1500, 30, 180));   // takes in and reduces between 30 and 180
       
      //fill(alpha,green,blue,alpha);
      colorMode(HSB, 255);    //  color mode is Hue Saturation Brightness   - We want Hue to be defined by pitch - Saturation and Brightness instead by intensity
      //print( i+"=" + fft.indexToFreq(i) +";");
      
      
      //what follows is the formula which takes the index and transforms it into a color so that for every bin there will be a different colour
      //we are inside a for loop
      
      
     fill(int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255)),    yD/2,   int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD,10+yD);
      
      //I will remove rightshift and leftshift
      //55 Hz is the first recognised number for the bin, so that the octaves follow the pattern : 55 - 110 - 220 - 440 - 880 - 1760 - 3520 - 7040 - 14080 - (too high...) every octace is then divided
      
     // Hue depends on pitch  0/100 is the octave  55 to 110 Hz 0,255 is the HUE octave;
     //Saturation depends on yD (input) - the more intensity the more 'full of colour'
     //Brightness depends on the position in the octaves, the lower, the darker, the higher, the brighter + intensity. This means that intensity can light up darker bins
     
     //alpha - more energy is equal to more 'PRESENCE' - not transparent
      
      
      //fill    (   HUE,   Saturation = YD / 2  ,    BRIGHTNESS,    ALPHA   )
          fill(int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255)),    yD/2,   int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD,     10+yD);

     
     
      //fill(int(map (i%12,0,12,0,255))+leftShift+rightShift,    leftShift+rightShift+int(yD)+satMidi,   brightMidi+50+leftShift+rightShift,alpha+satMidi);
     //spacing = int(map (i, 1, log(fft.specSize()), 0, width));
     
     //print(fft.getBand(i));
     //println(" ");
     
     stroke(255, 1);
     
     //our stroke is white but very thin. Alpha = 1;
     
     //noStroke();
     //ellipse(x, height - int(y)-height/12, 
     
     
      //ellipse(x,  height-int(y), 
              //in.left.get(i)*50+yD/3+5, in.right.get(i)*50+yD/3+5);
        // y/48, y*2);
              
              //shape is the custom fuction which will decide how to represent sound.
              //ideally the mapping of the colours should also go into this.
              //leftShift and rightShift should get the input - maybe there's a better way
              
              
              shape(x, y, i, leftShift, rightShift, yD);
              
      //stroke(255, 80);
      
      //this is the function which plots the grey lines of noise  // only if  above 2 - it says if there's background noise
      
      if ( fft.getBand(i)> 2){
         //print(i+ " :band:    " + fft.getBand(i)+ "   :");
         //print(i+ " :height:    " + relativeHeight+ "   :");
        //println(i+ " :    " + y+ "   :");
        
        //this is the weight of the stroke
        
       // stroke(255, 5);
              //line( x, height-height/12, -500, x,height - int(y)-height/12, 0);
      
      //the positioning depends on the height of the screen nand the input value y - we are still inside the for loop for each bin
      
        //line( x, height, -500, x,height - int(y), 0);
      }
     
     leftShiftTotal = leftShiftTotal+leftShift;
     rightShiftTotal = rightShiftTotal+rightShift;
     
     
  }
  
  //this goes back to the world of RGB where we can erase with backspace and a black canvas what has been drawn - its alpha is 20, it could be more
  
  
  colorMode(RGB, 255);
   //if (count%5==0){
     //fill (255, 3);
     //fill (0, 30);  //black
     if (keyPressed) {
     if (key == ' ') {
       noStroke();
       fill (0, 20);
      // rect (0,0,width+800,height+800);
       
               rect (-width-2000,-height-1000,width+2000,height-1000);

       
    //rect(0,0, mouseX,mouseY);
     // text("cleaning",210,30); 
    }
     }
     
     //this erases the canvas anyway - it is the passing of time - we are still in the main world
     
        if (frameCount%3==0){
       noStroke();
       //fill (255, 5);
       //rect (0,0,width+800,height+800);
        fill(0,10);
      // rect (0,0,width+800,height+800);
       
        rect (-width-2000,-height-1000,width+2000,height-1000);
      // rect (0,0,-width+2000,-height+800);
     }
    
 // rect (-500,-500,width+700,height+700);
    //rect(0,0, mouseX,mouseY);
//}

  popMatrix();
  
if (hueValue > 255){
  hueValue=0;}
  if (hueValue < 0){
  hueValue=255;}
 }
 
 if (hueValueG > 255){
  hueValueG=0;}
  if (hueValueG < 0){
  hueValueG = 255;} 
 
 
}
 
void stop()
{
  //close the AudioPlayer you got from Minim.loadFile()
    in.close();
    //song.close();
  
    minim.stop();
    //mm.finish();
 
  //this calls the stop method that 
  //you are overriding by defining your own
  //it must be called so that your application 
  //can do all the cleanup it would normally do
    super.stop();
}
float log2inv = 1/log(2);

float log2 (int x) {
  return (log(x) * log2inv );
}
float log2 (float x) {
  return (log(x) * log2inv);
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

void keyPressed() {
  
  //add mode to switch between playback and input listening
  
  if (key == 'p') {    
    playStart = true;
    listeningMode = false;
  }
   if (key == 'o') {    
    playStart = true;
    listeningMode = false;
  }
  if (key == 'i') {    
    playStart = true;
    listeningMode = false;
  }
  
   if (key == '0') {  
    mode = 0;
    println("mode = " + mode );
  }
  if (key == '1') {  
    mode = 1;
    println("mode = " + mode );
  }
   if (key == '2') {  
    mode = 2;
    println("mode = " + mode );
  }
   if (key == '3') {  
    mode = 3;
    println("mode = " + mode );
  }
  if (key == '4') {  
    mode = 4;
    println("mode = " + mode );
  }
   if (key == '5') {  
    mode = 5;
    println("mode = " + mode );
  }
   if (key == '6') {  
    mode = 6;
    println("mode = " + mode );
  }
  if (key == '7') {  
    mode = 7;
    println("mode = " + mode );
  }
   if (key == '8') {  
    mode = 8;
    println("mode = " + mode );
  }
   
     if (key == '9') {  
    mode = 9;
    println("mode = " + mode );
  }
  
   if (key == 'q') {  
    mode = 11;
    println("mode = " + mode );
  }
  
    if (key == 'k') {  
    mode = 12;
    println("mode = " + mode );
  }
  
      if (key == 'r') {  
    float sum=-5000000;
    println("sum = reset " );
  }
  
      if (key == 'f') {  
     COLORCIRCLE = !COLORCIRCLE;
    println("colorCircle = " + COLORCIRCLE );
  }
  
      if (key == 'g') {  
     hueValueG=++hueValueG;
    println("hueValueG = " + hueValueG );
  }
  
       if (key == 'v') {  
      hueValueG=--hueValueG;
    println("hueValueG = " + hueValueG );
  }
  
 
  if (key == CODED) {
  if (keyCode == UP) {  
        hueValue=++hueValue;

    println("hueValue = " + hueValue );
  }
  if (keyCode == DOWN) {  
    hueValue=--hueValue;
    println("hueValue = "+  hueValue );
  }
  }
}

void shape(float x, float y, int i, float leftShift, float rightShift, float yD) {
  
  //this is a fuction which actually draws shapes.
  //it can be interesting to differentiates between spaces 
  //at the moment the space is shared
  //it could be nice to jump from one to another

  switch(mode){
 
    case 0: 
    
   //0 noFill();
    
    //this doesn't work
   background(0,255);
    break;
    
    case 1:
    
    if ( fft.getBand(i)> 5){   
    pushMatrix();
    rotateX(PI/4);
    rotateZ(PI*yD/2);
      stroke (int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255)),    yD/2,  int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD/4,10+yD);
    //this tries to draw ellipses but it's weak   
    colorMode (RGB);
    fill(hueValue-yD/5,0+rightShift*255/100,255-leftShift*255/100,128-yD*2/3);
    // fill(240-yD/2*rightShift,255-yD,125,yD/2);
    ellipse(x,  height-int(y)-x, y/24, y);       
     // ellipse(x,  height-int(y)-x, y/24, y);       
    colorMode(HSB);   
 popMatrix();  
    } 
    break;

    case 2:
    
    //this draws rectangles and it works and it's fast   
       pushMatrix();
    rotateX(PI/4);
    //rotateZ(PI/2);/
  //rotateX(PI/8*yD/48);
     rotateY(PI/24);   
      //rotateX(PI/4);
    //rotateZ(PI*yD/2);   
    translate(rightShift*20-leftShift*20,0,0);
   //rotateZ(PI/7);
   rotateZ(PI*rightShift);
    rotateZ(PI*leftShift);   
   //rotateZ(PI/7);
        stroke (int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255)),    yD/2,  int(map ((log2(fft.indexToFreq(i))),0,14,20,128))+yD,10+yD/2);
  
         rect(x,  height-int(y), y/60, y*5);  
         translate(x,height-int(y),0);
         rotateX(PI/2);
         noFill();
         ellipseMode(CENTER);
       ellipse(0,  0, y/12+leftShift*20, y/12+rightShift*20);  
     // ellipse(rightShift,  height-int(yD), y/12, y/12);  
     //ellipse(leftShift,  height-int(yD), y/12, y/12);   
    colorMode(HSB);
    
 popMatrix();                    
    break;


    case 3:
    if ( fft.getBand(i)> 2){
    
    //this draws rectangles and it works and it's fast
    
    
       pushMatrix();
       
       translate (1200,300,0);
    rotateX(PI/2);
    //rotateZ(PI/2);
    //rotateX(PI/8);
    
     
  
    
 
    
    
         stroke (int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255)),    yD,  int(map ((log2(fft.indexToFreq(i))),0,14,20,128))+yD/2,10+yD/2);

    //this tries to draw ellipses but it's weak
    //colorMode (RGB);
    //fill(255-yD,0,yD/2,yD/2);
    // fill(240,255,125,yD/2);
   // ellipse(x,  height-int(y)-x, y/24, y);   
    
     // ellipse(x,  height-int(y)-x, y/24, y); 
     
         rect(x,  height-int(y)-leftShift*10, y/60, y*5);  
      
    colorMode(HSB);
    
 popMatrix(); 


    } 
    break;
    
    case 4:
    if ( fft.getBand(i)> 5){
    //this kinda work
    
    arc(x, x, y, y, PI/2+PI/28, PI/2+PI/28+PI/4, OPEN);
    }
    break;
    
    
    
    case 5:
    
    //black circles
    
    if ( fft.getBand(i)> 2){
     //noFill();     
      if (COLORCIRCLE == true){     
      colorMode(HSB);  
      fill(hueValueG,128,128,20); 
      }
      else if (COLORCIRCLE == false){
         //colorMode(RGB); 
         colorMode(HSB); 
        fill(0,20);
      }
      
       //fill(0,20);
       
//fill(0,20);
      
    //stroke(255,10);
    
    //this draws circle
    
     //stroke (int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255))+leftShift+rightShift,    yD/2,   leftShift+rightShift+int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD,10+yD);
    pushMatrix();
    
    //circles actually spin because coordinates are changing. 
    
    rotateX(PI/2);
    //rotateY(PI/2);
    
    stroke (int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255)),    yD/2, leftShift/2 + int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD,10+yD/4+leftShift);
    arc(x, height-int(y), x + yD/12, y+y*2, 0, PI*y/150, CLOSE);
    
    stroke (int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255)),    yD/2,  +rightShift/2 + int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD,10+yD/4+rightShift);
     arc(-x, height-int(y), x + yD/12, y+y*2, 0, PI*y/150, CLOSE);
    rotateZ(PI/8);
    //rect(x,  height-int(y), y/12, y*2);  
   
     //arc(x, height-int(y), x + y/12, y+y*2, 0, PI*y/150, OPEN);
     
         stroke (int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255))+leftShift,    yD/2, leftShift + int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD,10+yD);


     //arc(x, height-int(y), x + yD/12, y+y*2, 0, PI*y/150, CLOSE);
         stroke (int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255))+rightShift,    yD/2,  +rightShift + int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD,10+yD);


     //arc(-x, height-int(y), x + yD/12, y+y*2, 0, PI*y/150, CLOSE);
     popMatrix();
    }
    break;  
    
    
    case 6:
    //
    
      if ( fft.getBand(i)> 2){
    // noFill();
    //stroke(255,10);
    
    //this draws circle
    
    
     stroke (int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255))+leftShift+rightShift,    yD/2,   leftShift+rightShift+int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD,10+yD);
    pushMatrix();
    
    //circles actually spin because coordinates are changing. 
    colorMode (RGB);
    //fill(255-yD,255- rightShift*2,leftShift,yD/5);
    
    fill(255-yD,255- rightShift*2-yD/8,leftShift,yD/8);
    
    //rotateX(PI/2+yD);
    //rotateY(PI/2+yD);
    //rotateZ(PI/2);
    //rect(x,  height-int(y), y/12, y*2);  
    //colorMode (RGB);
    rotateY(yD/2);
     rotateZ(yD/3);
        // stroke (int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255))+leftShift+rightShift,    yD/2,   leftShift+rightShift+int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD,10+yD);
translate (800,0,200+yD);
rotateZ(PI/2);
     //arc(x, height-int(y), x + y/12, y+y*2, 0, PI*y/150, OPEN);
     arc(x/2, height-int(y), x + y/12, y+y*2, 0, PI-yD/100, CLOSE);
     
         fill(255-yD/4,255- rightShift*2-yD/8,leftShift,yD/8);

 if ( fft.getBand(i)> 8){
     stroke (hueValue,    yD/2,   int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD,10+yD);
      fill(hueValueG-yD,255- rightShift*2-yD/8,leftShift,yD/8);
    

 }
     arc(x/8, height-int(y), x + y/12, y+y*2, 0, PI-yD/100, CLOSE);
     popMatrix();
      }
    break;  
    
     case 7:
    if ( fft.getBand(i)> 5){
    //this draws rectangles and it works and it's fast
    
    
       pushMatrix();
    //rotateX(PI/4);
    //rotateZ(PI/2);/
  
  
  //  rotateX(PI/8*yD/48);
    // rotateY(PI/24);
     
      rotateX(PI/4);
    rotateZ(PI*yD/2);
     
   // rotateZ(PI*rightShift);
    //rotateZ(PI*leftShift);
    
  //  rotateZ(PI/7);
    
    
         stroke (int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255)),    yD/2,  int(map ((log2(fft.indexToFreq(i))),0,14,20,128))+yD,10+yD/2);

    //this tries to draw ellipses but it's weak
    //colorMode (RGB);
    //fill(255-yD,0,yD/2,yD/2);
    // fill(240,255,125,yD/2);
   // ellipse(x,  height-int(y)-x, y/24, y);   
    
     // ellipse(x,  height-int(y)-x, y/24, y); 
     
         rect(x,  height-int(y)-leftShift*10, y/60, y*5);  
      
    colorMode(HSB);
    
 popMatrix();  
    } 
    break;

case 8:

 arc(x, height-int(y), y/48, y*2, PI/2+PI/28, PI/2+PI/28+PI/4, OPEN);
    
    
    break;
    
case 9:

 ellipse(x,  height-int(y), y/48, y*2);  
 
 break;
 
 case 12:

   background(0,255);
    
    break;
 
  } 
}
