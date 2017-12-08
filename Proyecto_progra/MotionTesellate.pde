// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 16-13: Simple motion detection

import processing.video.*;
// Variable for capture device
Capture video;
// Previous Frame
PImage prevFrame;
// How different must a pixel be to be a "motion" pixel
float threshold = 20;


ArrayList <Figura> figuras;
float lado = 25;
float altura = sqrt(sq(lado) - sq(lado/2f));
float apotema = lado/ 2*tan(PI/6f);
float radio = altura - apotema;
float delta = 0;


void setup() {
  size(1200, 800);
  video = new Capture(this, width, height, 30);
  video.start();
  // Create an empty image the same size as the video
  prevFrame = createImage(video.width, video.height, RGB);
  
  
figuras = new ArrayList<Figura>();
for (float j = radio; j<=height; j+= altura){
int paso = (round((j - radio)/altura));
float offset =0;
if (paso%2 == 0){
offset = lado/2f;
}
for (float i =-offset; i<=width; i+= lado){
figuras.add(new Triangulo(i,j,lado,0));
}
for (float i =lado/2f-offset; i<=width; i+= lado){
figuras.add(new Triangulo(i,j-apotema,lado,PI));
}
}

}

void captureEvent(Capture video) {
  // Save previous frame for motion detection!!
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height); // Before we read the new frame, we always save the previous frame for comparison!
  prevFrame.updatePixels();  // Read image from the camera
  video.read();
}

void draw() {

  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {

      int loc = x + y*video.width;            // Step 1, what is the 1D pixel location
      color current = video.pixels[loc];      // Step 2, what is the current color
      color previous = prevFrame.pixels[loc]; // Step 3, what is the previous color

      // Step 4, compare colors (previous vs. current)
      float r1 = red(current); 
      float g1 = green(current); 
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous); 
      float b2 = blue(previous);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // Step 5, How different are the colors?
      // If the color at that pixel has changed, then there is motion at that pixel.
      if (diff > threshold) { 
        // If motion, display black
        pixels[loc] = color(#247D81);
      } else {
        // If not, display white
        pixels[loc] = color(255);
      }
    }
  }
  updatePixels();
  
  
noStroke();
fill(0);
for (Figura f: figuras){
f.display();
}

}


interface Figura
{
float perimetro ();
float area ();
void display();
}
class Triangulo implements Figura
{
float x,y,l,rc,ri,a,a1,deltax,deltay,h,b,rota;
Triangulo (float x_,float y_,float l_, float rota_)
{
x=x_;
y=y_;
l=l_;
rc=(l*sqrt(3))/3f;
b=l;
a1=TWO_PI/3;
rota = rota_;
}
float perimetro ()
{
return l*3;
}
float area ()
{
return ((l*l)*(sqrt(3)))/4;
}
void display()
{
fill (random(255),random(255),random(255),random(125));
pushMatrix();
translate(x,y);
rotate(HALF_PI - PI/3 + rota);
beginShape();
for(float a = 0;a<TWO_PI;a+=a1)
{
deltax=cos(a)*rc;
deltay=sin(a)*rc;
vertex(deltax,deltay);
}
endShape(CLOSE);
popMatrix();
}
}