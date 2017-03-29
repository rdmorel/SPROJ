/**
 * Compute Vertical Seam
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
   System.out.println(lowest);
   for (int i = 1; i < bottomRow.length; i++){
     double summ = nodeArray[bottomRow[i]].getSum();
     System.out.println(summ);
     if (summ < lowest){
       lowest = summ;
       root = bottomRow[i];
     }
   }
   Node[] vertSeam = new Node[img.height*2]; // contains all nodes in lowest energy seam
   Node pixel = nodeArray[root];
   for (int i = 0; i<vertSeam.length; i++){
     vertSeam[i] = pixel;
     img.pixels[pixel.getY()*img.width + pixel.getX()] = color(255, 0, 0);// color seam red
     fill(255,0,0);
     ellipse(pixel.getX(), pixel.getY(),5,5);
     pixel = pixel.getparent();
     i++;
   }
   
   img.updatePixels();
   //image(img, 0, 0);
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
/**
 * Compute Vertical Seam
 *
 */
 
//import java.util*;
 
PImage img;
 
void setup() {
  img = loadImage("towerfilter.png"); // image that has been put through sobel filter
  size(img.width, img.height);
  
  //image(img, 0, 0);
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
     img.pixels[pixel.getY()*img.width + pixel.getX()] = color(255, 0, 0);// color seam red
     fill(255,0,0);
     noStroke();
     ellipse(pixel.getX(), pixel.getY(),3,3);
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
     if (inSeam == false) { // if pixel is not in seam, copy it into new image
       post.pixels[j] = img.pixels[i];
       j++;
     }
     else { inSeam = false; } // if pixel is in seam, skip it and reset inSeam variable
   }
   post.updatePixels();
   image(post,0,0);
   post.save("carved.png");
   System.out.println(post.width); //This is returning 598, but the saved file says 599?
   
 }
 
//void draw() {

 //}
 
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
