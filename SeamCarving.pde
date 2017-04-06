/*
 *
 * Seam Carving
 *
 */

double[][] kernelx = {{ -1, +0, +1}, 
                    { -2, +0, +2}, 
                    { -1, +0, +1}};
                    
double[][] kernely = {{ +1, +2, +1}, 
                    { +0, +0, +0}, 
                    { -1, -2, -1}};
                    
PImage img;
int targetwidth = 500; // Set target dimensions
int targetheight = 400;

void setup() {
  img = loadImage("tower.jpg"); // Load the original image
  size(img.width, img.height);
  
  carve(img);
}
void carve(PImage img){
  
  if (targetwidth > img.width){
    vertseam(img);
  }
  
  else if (targetheight > img.height){
    horizseam(img);
  }
  
}

void vertseam(PImage orig){
  sobel(orig);
  PImage img = loadImage("filtered.png");
  img.loadPixels();
  
  Node[] nodeArray = new Node[img.pixels.length];// create array of Nodes
   for (int i = 0; i<img.pixels.length; i++){// for each pixel, create corresponding Node
     int ypos = i/img.width; // calculating x and y coordinates based on position in array
     int xpos = i - (ypos * img.width);
     nodeArray[i] = new Node (xpos, ypos, nodeArray, img, i);
   }
   for (int i = 0; i<nodeArray.length; i++){
     nodeArray[i].setParent();// set parent for each node
   }
   int[] bottomRow = new int[img.width];// array containing positions of bottom nodes in nodeArray
   int num = 0;
   for (int i = 0; i<nodeArray.length; i++){
     if (nodeArray[i].getY() == img.height - 1){
        bottomRow[num] = i;
        num++;
     }
   }
   int root = bottomRow[0]; // root = index of bottom node in the lowest energy seam
   double lowest = nodeArray[root].getSum();
   for (int i = 1; i < bottomRow.length; i++){
     double summ = nodeArray[bottomRow[i]].getSum();
     if (summ < lowest){
       lowest = summ;
       root = bottomRow[i];
     }
   }
   Node[] vertSeam = new Node[img.height*2]; // contains all nodes in lowest energy seam
   int[] seamIndex = new int[vertSeam.length];// array containing indexes of all pixels in seam
   Node pixel = nodeArray[root];
   for (int i = 0; i<vertSeam.length; i++){
     vertSeam[i] = pixel;
     seamIndex[i] = pixel.getIndex();
     pixel = pixel.getparent();
     i++;
   }
   
   img.updatePixels();
   
   PImage post = createImage(img.width - 1 , img.height, RGB);//final image
   post.loadPixels();
   int j = 0;
   boolean inSeam = false;
   for (int i = 0; i < img.pixels.length; i++){
     for (int x = 0; x < seamIndex.length; x++){
       if (i == seamIndex[x]){ // check to see if pixel is in the seam
         inSeam = true;
       }
     }
     if (inSeam == false) { // if pixel is not in seam, copy the pixel from the original into new image
       post.pixels[j] = orig.pixels[i];
       j++;
     }
     else { inSeam = false; } // if pixel is in seam, skip it and reset inSeam variable
   }
   post.updatePixels();
   image(post,0,0);
   post.save("carved.png");
   carve(post);
}

void horizseam(PImage orig){
  sobel(orig);
  PImage img = loadImage("filtered.png");
  img.loadPixels();
  
  Node[] nodeArray = new Node[img.pixels.length];// create array of Nodes
   for (int i = 0; i<img.pixels.length; i++){// for each pixel, create corresponding Node
     int ypos = i/img.width; // calculating x and y coordinates based on position in array
     int xpos = i - (ypos * img.width);
     nodeArray[i] = new Node (xpos, ypos, nodeArray, img, i);
   }
   for (int i = 0; i<nodeArray.length; i++){
     nodeArray[i].setParent();// set parent for each node
   }
   int[] leftSide = new int[img.height];// array containing positions of leftmost nodes in nodeArray
   int num = 0;
   for (int i = 0; i<nodeArray.length; i++){
     if (nodeArray[i].getX() == 0){
        leftSide[num] = i;
        num++;
     }
   }
   int root = leftSide[0]; // root = index of leftmost node in the lowest energy seam
   double lowest = nodeArray[root].getSum();
   for (int i = 1; i < leftSide.length; i++){
     double summ = nodeArray[leftSide[i]].getSum();
     if (summ < lowest){
       lowest = summ;
       root = leftSide[i];
     }
   }
   Node[] horizSeam = new Node[img.width*2]; // contains all nodes in lowest energy seam
   int[] seamIndex = new int[horizSeam.length];// array containing indexes of all pixels in seam
   Node pixel = nodeArray[root];
   for (int i = 0; i<horizSeam.length; i++){
     horizSeam[i] = pixel;
     seamIndex[i] = pixel.getIndex();
     pixel = pixel.getparent();
     i++;
   }
   
   img.updatePixels();
   
   PImage post = createImage(img.width, img.height - 1, RGB);//final image
   post.loadPixels();
   int j = 0;
   boolean inSeam = false;
   for (int i = 0; i < img.pixels.length; i++){
     for (int x = 0; x < seamIndex.length; x++){
       if (i == seamIndex[x]){ // check to see if pixel is in the seam
         inSeam = true;
       }
     }
     if (inSeam == false) { // if pixel is not in seam, copy the pixel from the original into new image
       post.pixels[j] = orig.pixels[i];
       j++;
     }
     else { inSeam = false; } // if pixel is in seam, skip it and reset inSeam variable
   }
   post.updatePixels();
   image(post,0,0);
   post.save("carved.png");
   carve(post);
}

void sobel(PImage img){
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
  edgeImg.save("filtered.png");
}

public class Node {// each node corresponds to a pixel
  int x, y;
  double valred, valgreen, valblue, energy, sum;
  PImage image; // not sure if I can get the image dimensions without passing the image to the object?
  Node[] nodeArray;
  Node parent;
  int index;

  public Node(int xpos, int ypos, Node[] arrayOfNodes, PImage imge, int ind){
    image = imge;
    x = xpos;
    y = ypos;
    valred = red(image.get(x,y));
    valgreen = green(image.get(x,y));
    valblue = blue(image.get(x,y));
    energy = valred + valgreen + valblue;// energy = sum of RGB values
    nodeArray = arrayOfNodes;
    sum = energy; // for now - will be updated in setParent()
    index = ind;
  }
  
  // basic getter/setter functions for Node attributes
  public int getX() { return this.x; }    
  public int getY() { return this.y; }  
  public double getEnergy() { return this.energy; } 
  public double getSum() { return this.sum; }
  public Node getparent() { return this.parent; }
  public int getIndex() { return this.index; }

  //do I even need setter functions?
  public void setX(int xval) { this.x = xval; }
  public void setY(int yval) { this.y = yval; }
  public void setEnergy(double en) { this.energy = en; }
  public void setSum(double sm) { this.sum = sm; }
  public void setIndex(int ind) { this.index = ind; }

  public void setParent(){// finds parent with least sum and sets sum for this node
    double sum1;
    double sum2;
    double sum3;
    Node n1;
    Node n2;
    Node n3;
    
    if (this.y == 0){ // top row
      this.parent = null; // sum is already set to energy
    }
    else if (this.x == 0){ // left column 
      sum1 = this.getSum() + nodeArray[(this.getIndex() - img.width + 1)].getSum(); // node above & right
      n1 = nodeArray[(this.getIndex() - img.width + 1)];
      sum2 = this.getSum() + nodeArray[(this.getIndex() - img.width)].getSum(); // node above
      n2 = nodeArray[(this.getIndex() - img.width)];      
      if (sum1 <= sum2){// compare sums & assign sum and parent
        this.sum = sum1;
        this.parent = n1;
      }
      else{
        this.sum = sum2;
        this.parent = n2;
      }
    }
    else if (this.getX() == this.image.width - 1){ // right column 
      sum1 = this.getSum() + nodeArray[(this.getIndex() - img.width - 1)].getSum(); // node above & left
      n1 = nodeArray[(this.getIndex() - img.width - 1)];
      sum2 = this.getSum() + nodeArray[(this.getIndex() - img.width)].getSum(); // node above
      n2 = nodeArray[(this.getIndex() - img.width)];  
      if (sum1 <= sum2){// compare sums & assign sum and parent
        this.sum = sum1;
        this.parent = n1;
      }
      else{
        this.sum = sum2;
        this.parent = n2;
      }
    }
    else{ // not on edge
      sum1 = this.getSum() + nodeArray[(this.getIndex() - img.width - 1)].getSum(); // node above & left
      n1 = nodeArray[(this.getIndex() - img.width - 1)];
      sum2 = this.getSum() + nodeArray[(this.getIndex() - img.width)].getSum(); // node above
      n2 = nodeArray[(this.getIndex() - img.width)];
      sum3 = this.getSum() + nodeArray[(this.getIndex() - img.width + 1)].getSum(); // node above & right
      n3 = nodeArray[(this.getIndex() - img.width + 1)];
      if (sum1 <= sum2 && sum1 <= sum3){// compare sums & assign parent
        this.sum = sum1;
        this.parent = n1;
      }
      else if (sum2 <= sum1 && sum2 <= sum3){
        this.sum = sum2;
        this.parent = n2;
      }
      else if (sum3 <= sum1 && sum3 <= sum2){
        this.sum = sum3;
        this.parent = n3;
      }
    }
  }
}
