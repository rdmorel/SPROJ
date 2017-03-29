/**
 * Compute Horizontal Seam
 *
 */
 
//import java.util*;
 
PImage img;
 
void setup() {
  img = loadImage("towerfilter.png"); // image that has been put through sobel filter
  size(img.width, img.height);
  
  image(img, 0, 0);
  img.loadPixels();
  
  Node[] nodeArray = new Node[img.pixels.length];// create array of Nodes
   for (int i = 0; i<img.pixels.length; i++){// for each pixel, create corresponding Node
     int ypos = i/img.width; // calculating x and y coordinates based on position in array
     int xpos = i - (ypos * img.width);
     nodeArray[i] = new Node (xpos, ypos, nodeArray, img, i);
/**
 * Compute Horizontal Seam
 *
 */
 
//import java.util*;
 
PImage img;
 
void setup() {
  img = loadImage("towerfilter.png"); // image that has been put through sobel filter
  size(img.width, img.height);
  
  image(img, 0, 0);
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
     img.pixels[pixel.getY()*img.width + pixel.getX()] = color(255, 0, 0);// color seam red
     fill(255,0,0);
     noStroke();
     ellipse(pixel.getX(), pixel.getY(),3,3);
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
     if (inSeam == false) { // if pixel is not in seam, copy it into new image
       post.pixels[j] = img.pixels[i];
       j++;
     }
     else { inSeam = false; } // if pixel is in seam, skip it and reset inSeam variable
   }
   post.updatePixels();
   image(post,0,0);
   post.save("carved.png");
   System.out.println(post.height); //This is returning 406, but the saved file says 407?

 }
 
void draw() {

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
    
    if (this.x == img.width - 1){ // right column
      this.parent = null; // sum is already set to energy
    }
    else if (this.getY() == 0){ // top row 
      sum1 = this.getSum() + nodeArray[(this.getIndex() + img.width + 1)].getSum(); // node right & below
      n1 = nodeArray[(this.getIndex() + img.width + 1)];
      sum2 = this.getSum() + nodeArray[(this.getIndex() + 1)].getSum(); // node right
      n2 = nodeArray[(this.getIndex() + 1)];      
      if (sum1 <= sum2){// compare sums & assign sum and parent
        this.sum = sum1;
        this.parent = n1;
      }
      else{
        this.sum = sum2;
        this.parent = n2;
      }
    }
    else if (this.getY() == this.image.height - 1){ // bottom row 
      sum1 = this.getSum() + nodeArray[(this.getIndex() - img.width + 1)].getSum(); // node right & above
      n1 = nodeArray[(this.getIndex() - img.width + 1)];
      sum2 = this.getSum() + nodeArray[(this.getIndex() + 1)].getSum(); // node right
      n2 = nodeArray[(this.getIndex() + 1)];    
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
      sum1 = this.getSum() + nodeArray[(this.getIndex() + img.width + 1)].getSum(); // node right & below
      n1 = nodeArray[(this.getIndex() + img.width + 1)];
      sum2 = this.getSum() + nodeArray[(this.getIndex() + 1)].getSum(); // node right
      n2 = nodeArray[(this.getIndex() + 1)];   
      sum3 = this.getSum() + nodeArray[(this.getIndex() - img.width + 1)].getSum(); // node right & above
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
