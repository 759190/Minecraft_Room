import java.awt.Robot;
//color pallette
color black=#000000; //wood
color white=#FFFFFF; //empty space
color blue=#7092BE; //mossy bricks

//textures
PImage light;
PImage dark;
PImage glass;

//Map variables
int gridSize;
PImage map;

//robot for mouse control
Robot rbt;

boolean wkey, akey, skey, dkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ;
float leftRightHeadAngle, upDownHeadAngle;
void setup() {
   //initialize texture
   light=loadImage("PrismarineBricks.png");
   dark=loadImage("DarkPrismarine.png");
   glass=loadImage("Glass.png");
  
   
   
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey=akey=skey=dkey=false;
  eyeX=width/2;
  eyeY=9*height/10;
  eyeZ=0;
  
  focusX=width/2;
  focusY=height/2;
  focusZ=10;
  
  tiltX=0;
  tiltY=1;
  tiltZ=0;
  leftRightHeadAngle=radians(270);
  
  // initialize map
  map=loadImage("map.png");
  gridSize=100;
  
 
 // noCursor();
 try{
   rbt=new Robot();
 } 
 catch (Exception e) {
   e.printStackTrace();
 }
  
}

void draw() {
  background(0);
  pointLight(255,255,255,eyeX,eyeY,eyeZ);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, tiltX, tiltY, tiltZ);

  drawFloor(-2000,2000,height,gridSize); //floor
  drawFloor(-2000,2000,height-gridSize*4,gridSize); //ceiling

  drawFocalPoint();
  controlCamera();
  drawMap();
}

void drawMap() {
  for (int x=0; x<map.width; x++) {
  for(int y=0; y< map.height; y++) {
  color c=map.get(x,y);
  if (c==blue) {
   texturedCube(x*gridSize-2000,height-gridSize,y*gridSize-2000,light,gridSize);
   texturedCube(x*gridSize-2000,height-gridSize*2,y*gridSize-2000,light,gridSize);
   texturedCube(x*gridSize-2000,height-gridSize*3,y*gridSize-2000,light,gridSize);
  }
  if(c==black) {
     texturedCube(x*gridSize-2000,height-gridSize,y*gridSize-2000,glass,gridSize);
   texturedCube(x*gridSize-2000,height-gridSize*2,y*gridSize-2000,glass,gridSize);
   texturedCube(x*gridSize-2000,height-gridSize*3,y*gridSize-2000,glass,gridSize);
  }
  
  }
  }
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}

void drawFloor (int start, int end, int level, int gap) {
  stroke(255);
strokeWeight(1);
int x=start;
int z=start;
 while(z<end) {
   texturedCube(x,level,z,dark,gap);
   x=x+gap;
   if(x>=end) {  
   x=start;
   z=z+gap;
   }
  }
}

void controlCamera () {

  if (wkey) {
    eyeX=eyeX + cos(leftRightHeadAngle)*10;
    eyeZ=eyeZ+ sin(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyeX=eyeX - cos(leftRightHeadAngle)*10;
    eyeZ=eyeZ- sin(leftRightHeadAngle)*10;
  }
  if (akey){
  eyeX=eyeX - cos(leftRightHeadAngle+radians(90))*10;
    eyeZ=eyeZ- sin(leftRightHeadAngle+radians(90))*10;  
  }
  if (dkey){
     eyeX=eyeX - cos(leftRightHeadAngle-radians(90))*10;
    eyeZ=eyeZ- sin(leftRightHeadAngle-radians(90))*10;  
  }

  leftRightHeadAngle=leftRightHeadAngle+ (mouseX-pmouseX)*0.01;
  upDownHeadAngle=upDownHeadAngle+(mouseY-pmouseY)*0.01;
  if (upDownHeadAngle>PI/2.5) upDownHeadAngle=PI/2.5;
  if (upDownHeadAngle<-PI/2.5) upDownHeadAngle=-PI/2.5;

  focusX=eyeX+ cos(leftRightHeadAngle)*300;
  focusZ=eyeZ+sin(leftRightHeadAngle)*300;
  focusY=eyeY+ tan(upDownHeadAngle)*300;
  
  if (mouseX>width-2) rbt.mouseMove(2, mouseY);
  else if (mouseX<2) rbt.mouseMove(width-2, mouseY);
  
}
void keyPressed () {
  if (keyCode=='W') wkey=true;
  if (keyCode=='S') skey=true;
  if (keyCode=='D') dkey=true;
  if (keyCode=='A') akey=true;
}

void keyReleased() {
  if (keyCode=='W') wkey=false;
  if (keyCode=='S') skey=false;
  if (keyCode=='D') dkey=false;
  if (keyCode=='A') akey=false;
}
