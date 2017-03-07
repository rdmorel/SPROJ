/**
 * Sobel Filter. 
 * 
 */

double[][] kernelx = {{ -1, +0, +1}, 
                    { -2, +0, +2}, 
                    { -1, +0, +1}};
                    
double[][] kernely = {{ +1, +2, +1}, 
                    { +0, +0, +0}, 
                    { -1, -2, -1}};
                    
PImage img;

void setup() { 
  size(1200, 600);
  img = loadImage("tower.jpg"); // Load the original image
  noLoop();
}

void draw() {
  image(img, 0, 0); // Displays the image from point (0,0) 
  img.loadPixels();
  // Create an opaque image of the same size as the original
  PImage edgeImg = createImage(img.width, img.height, RGB);
  // Loop through every pixel in the image.
  for (int y = 1; y < img.height-1; y++) { // Skip top and bottom edges
    for (int x = 1; x < img.width-1; x++) { // Skip left and right edges
      double sumxr = 0; // Kernel sum for this pixel - red, horizontal
      double sumyr = 0; // red, vertical
      double sumxg = 0; // green, horizontal
      double sumyg = 0; // etc.
      double sumxb = 0;
      double sumyb = 0;
      double magnituder = 0; // magnitude red
      double magnitudeg = 0; // magnitude green
      double magnitudeb = 0; // magnitude blue
      int magintr = 0; // going to convert magnitudes to ints
      int magintg = 0;
      int magintb = 0;
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*img.width + (x + kx);
          // find RGB values for pixel
          double valred = red(img.pixels[pos]);
          double valgreen = green(img.pixels[pos]);
          double valblue = blue(img.pixels[pos]);
          // Multiply RGB values for pixels based on the kernel values
          sumxr += kernelx[ky+1][kx+1] * valred;
          sumyr += kernely[ky+1][kx+1] * valred;
          sumxg += kernelx[ky+1][kx+1] * valgreen;
          sumyg += kernely[ky+1][kx+1] * valgreen;
          sumxb += kernelx[ky+1][kx+1] * valblue;
          sumyb += kernely[ky+1][kx+1] * valblue;
        }
      }
      // For this pixel in the new image, set the RGB values
      // based on the sums from the kernel
      magnituder = Math.sqrt((sumxr * sumxr) + (sumyr * sumyr));
      magintr = (int)Math.round(magnituder);
      magnitudeg = Math.sqrt((sumxg * sumxg) + (sumyg * sumyg));
      magintg = (int)Math.round(magnitudeg);
      magnitudeb = Math.sqrt((sumxb * sumxb) + (sumyb * sumyb));
      magintb = (int)Math.round(magnitudeb);
      edgeImg.pixels[y*img.width + x] = color(magintr, magintg, magintb);
    }
  }
  // State that there are changes to edgeImg.pixels[]
  edgeImg.updatePixels();
  image(edgeImg, width/2, 0); // Draw the new image
}

