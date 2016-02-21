
import org.firmata.*;
import processing.serial.*;
Serial myPort; 
String val;
 

import ddf.minim.*;
import ddf.minim.analysis.*;
import cc.arduino.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl; 
Arduino arduino;

int ledPin =  2;    
int ledPin2 =  3;    
int ledPin3 =  5;    

float kickSize, snareSize, hatSize;

void setup() {
  size(512, 300, P3D);
  
  minim = new Minim(this);
  String portName = Serial.list()[2];

  
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  
  song = minim.loadFile("power.mp3", 2048);
  song.play();
 
 
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());

  beat.setSensitivity(50);  
  kickSize = snareSize = hatSize =  16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);
  
  arduino.pinMode(ledPin, Arduino.OUTPUT);    
  arduino.pinMode(ledPin2, Arduino.OUTPUT);  
  arduino.pinMode(ledPin3, Arduino.OUTPUT);  

}

void draw() {
  background(0);
  fill(255);


  
    if(beat.isKick()) {
      arduino.digitalWrite(ledPin, Arduino.HIGH);   // set the LED on
      kickSize = 32;
  }
  
  if(beat.isSnare()) {
      arduino.digitalWrite(ledPin2, Arduino.HIGH);   // set the LED on
      snareSize = 32;
  }
  if(beat.isHat()) {
      arduino.digitalWrite(ledPin3, Arduino.HIGH);   // set the LED on
      hatSize = 32;
  }
  
  
  
  
  arduino.digitalWrite(ledPin, Arduino.LOW);    // set the LED off
  arduino.digitalWrite(ledPin2, Arduino.LOW);    // set the LED off
  arduino.digitalWrite(ledPin3, Arduino.LOW); 

  // set the LED off
  textSize(kickSize);
  text("ONE", width/4, height/2);
  textSize(snareSize);
  text("TWO", width/2, height/2);
  textSize(hatSize);
  text("THREE", 3*width/4, height/2);

  
  kickSize = constrain(kickSize * 0.95, 16, 32);
  snareSize = constrain(snareSize * 0.95, 16, 32);
  hatSize = constrain(hatSize * 0.95, 16, 32);

}

void stop() {
  
  song.close();
 
  minim.stop();
 
  super.stop();
}