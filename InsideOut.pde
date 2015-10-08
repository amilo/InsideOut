
//import Minim library
import ddf.minim.*;
import ddf.minim.UGen;
  
import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
  
//for displaying the sound's frequency
  import ddf.minim.analysis.*;
  import ddf.minim.ugens.*;


/**
  * InsideOut - visualScape for audio content - 
  * first developed during Summer2014 -
  * new version for Autumn2015 - Arno Babajanian concert
  * at Queen Mary University of London for InsideOut event
  *@author     Alessia Milo  contact@alessiamilo.com
  *@version    1.1
  *@since      Summer 2014
  */


//int fps = 30;
PeasyCam cam;
  Minim minim;
  float rightShift;
  float leftShift;
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
  
   int mode = 0; //drawing mode
  
//to make it play song files
  AudioPlayer song;
   //to make it "hear" audio input
  //AudioInput in;

  float sum=-5000000;
  
//for displaying the sound's frequency
  FFT fft;

void setup() {

  //sketch size
    //size(1200, 800, P3D); //do the adjustable size
     size(1280, 1024, P3D); //do the adjustable size
     //PeasyCam
    cam = new PeasyCam(this, width/2,height/2,500,50);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(3000);
 background(0,0);

 frameRate(20);
 textureMode(NORMAL);
 
  
  minim = new Minim(this);
 
  
  //load the song you want to play
  //drag the file into your sketch window
  //and replace "mysong.mp3" with the file name
  //in = minim.getLineIn(Minim.STEREO, 2048);

 song = minim.loadFile("TEST.wav", 2048);
 

    song.play();
  
  //an FFT needs to know how 
  //long the audio buffers it will be analyzing are
  //and also needs to know 
  //the sample rate of the audio it is analyzing
  
  //do something to switch between playback and live and 
    //fft = new FFT(in.bufferSize(), in.sampleRate());
    fft = new FFT(song.bufferSize(), song.sampleRate());
    //count=0;
  
    //values= new int[16];
    
}
 
void draw(){
  //fft.forward(in.mix);
  fft.forward(song.mix);

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
  translate(width/2, height/2, -1500);
 rotateX(-PI/2+frameCount*PI/(sum/fft.specSize()));
   //rotateX(-PI/2 + frameCount * PI / 100);
  //rotateX(frameCount*(-PI/3));
  //rotateY(frameCount * PI / 50); 
  //rotateY(frameCount * PI / 50);
  rotateY(frameCount * PI / 300);
  //rotateZ(frameCount * PI /4); 
 if (sum>10000000){
    sum = -sum;
    println("reverse sum");
  }
    for(int i=1; i < fft.specSize(); i++){
      
      sum=fft.getBand(i)+sum;
  
       //leftShift= int(map(in.left.get(i),-0.5, 0.5, -12, 0));
       //rightShift= int(map(in.right.get(i),-0.5, 0.5, 0, +12));
       
       leftShift= int(map(song.left.get(i),-0.5, 0.5, -12, 0));
       rightShift= int(map(song.right.get(i),-0.5, 0.5, 0, +12));
       
      //int alpha = int(map(fft.getBand(i),0, 500, 30, 200));
       //println (  song.left.get(i));
       //println ("for index" + i + "green ="  + green);
       /*
       construct a frequency analyzer
       hueMidi = map ((i), 44
       
       
       */
       
     //float x = log2(i)/log2(fft.specSize())*width + 20 ;
       float x = log2(2*i)*-150 ;
    
        //float y = log2(fft.getBand(i))*100;
        float y = log2(fft.getBand(i))*90;
        
        float yD = map (y, 0, 400, 0, 128);
        int alpha = int(map (y, 0, 1500, 30, 180));
       
      //fill(alpha,green,blue,alpha);
      colorMode(HSB, 255);
      //print( i+"=" + fft.indexToFreq(i) +";");
      
     fill(int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255))+leftShift+rightShift,    yD/2,   leftShift+rightShift+int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD,10+yD);
      //fill(int(map (i%12,0,12,0,255))+leftShift+rightShift,    leftShift+rightShift+int(yD)+satMidi,   brightMidi+50+leftShift+rightShift,alpha+satMidi);
     //spacing = int(map (i, 1, log(fft.specSize()), 0, width));
     
     //print(fft.getBand(i));
     //println(" ");
     stroke(255, 1);
     //noStroke();
     //ellipse(x, height - int(y)-height/12, 
     
     
      //ellipse(x,  height-int(y), 
              //in.left.get(i)*50+yD/3+5, in.right.get(i)*50+yD/3+5);
        // y/48, y*2);
              
              shape(x, y, i, leftShift, rightShift, yD);
              
      //stroke(255, 80);
      
      if ( fft.getBand(i)> 2){
         //print(i+ " :band:    " + fft.getBand(i)+ "   :");
         //print(i+ " :height:    " + relativeHeight+ "   :");
        //println(i+ " :    " + y+ "   :");
        stroke(255, 5);
      //line( x, height-height/12, -500, x,height - int(y)-height/12, 0);
        line( x, height, -500, x,height - int(y), 0);
      }
     
  }
  
  colorMode(RGB, 255);
   //if (count%5==0){
     //fill (255, 3);
     //fill (0, 30);  //black
     if (keyPressed) {
     if (key == ' ') {
       noStroke();
       fill (0, 20);
       rect (0,0,width+800,height+800);
    //rect(0,0, mouseX,mouseY);
     // text("cleaning",210,30); 
    }
     }
        if (frameCount%3==0){
       noStroke();
       //fill (255, 5);
       //rect (0,0,width+800,height+800);
        fill(0,10);
       rect (0,0,width+800,height+800);
     }
    
 // rect (-500,-500,width+700,height+700);
    //rect(0,0, mouseX,mouseY);
//}


  popMatrix();

}
 
void stop()
{
  //close the AudioPlayer you got from Minim.loadFile()
    //in.close();
    song.close();
  
  
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
}

void shape(float x, float y, int i, float leftShift, float rightShift, float yD) {
  

  switch(mode){
 
    case 0: 
    
    noFill();
    
    arc(x, height-int(y), y/48, y*2, PI/2+PI/28, PI/2+PI/28+PI/4, OPEN);
    
    break;
    
    case 1:
    
    ellipse(x,  height-int(y), y/48, y*2);   
 
    break;

    case 2:
    
    rect(x,  height-int(y), y/48, y*2);   
    
    break;
    
    case 3:
    
    noFill();
    stroke(255, 50);
    
    arc(x, height-int(y), x, y/48, 0, PI, OPEN);
    //stroke(255, 5);
    
    break;
    
    case 4:
    
    arc(x, x, y, y, PI/2+PI/28, PI/2+PI/28+PI/4, OPEN);
    
    break;
    
    case 5:
    
     noFill();
    //stroke(255,10);
    
     stroke (int(map ((log2(fft.indexToFreq(i)/55)*100)%100,0,100,0,255))+leftShift+rightShift,    yD/2,   leftShift+rightShift+int(map ((log2(fft.indexToFreq(i))),0,14,20,255))+yD,10+yD);
    pushMatrix();
    rotateX(PI/2);
    //rotateY(PI/2);
    rotateZ(PI/2);
    //rect(x,  height-int(y), y/12, y*2);  
   
     //arc(x, height-int(y), x + y/12, y+y*2, 0, PI*y/150, OPEN);
     arc(x, height-int(y), x + y/12, y+y*2, 0, PI*y/150, CLOSE);
     popMatrix();
    
    break;  
  } 
}
