import java.io.*;//this is for the throwing fileNotFound exception
int i = 0;

NeuralNetwork net;
Drawing drawing;

Matrix X;
Matrix Y;
Matrix XTest;
Matrix YTest;
int[] dims;
int time;
float initialCost;
float initialTestCost;
float prevCost;
float prevTestCost;
int iteration = 0; //stores the number of iterations
boolean train = true;//this tells the application whether to train the data or not.

//the data base uses a 28 * 28 image but it is possible to reduce the dimensions by 
//cropping the image. Reducing the images allow for faster training times but potentially
//less accurate predictions
int desiredRows = 20;//this formats the images to use only this amount of Y-axis pixels
int desiredCols = 20;//this formats the images to use only this amount of X-axis pixels

//The learning rate determines how large of a "step" gradient descent makes. By taking 
//smaller steps, you're able to converge to a more precise minimum, but by taking larger steps 
//you'll converge much sooner
//Normal speak: 
//High Learning rate = faster training but at the cost of accuracy
//Low Learning rate = greater accuracy but slower training
float learningRate = .7;

void setup(){
  frameRate(60);
  //-------------------------------------------------------------------------------
  //Attempting to load up the mnist database for training data and test set
  //-------------------------------------------------------------------------------
  try{
    println("Loading MNIST Database. This may take a while...");
    Mnist data = new Mnist();
    int numberOfTrainingExamples = 20000;
    int numberOfTestingExamples = 4000;
    int n = data.rows*data.cols; //number of features in x
    float[][] x = new float[numberOfTrainingExamples][n];
    float[][] y = new float[numberOfTrainingExamples][10];
    float[][] xTest = new float[numberOfTestingExamples][n];
    float[][] yTest = new float[numberOfTestingExamples][10];
    for(int i = 0; i < numberOfTrainingExamples * 0; i++){//this is to skip examples
      data.nextTrainImage();
      data.nextTrainLabel();
    }
    for(int i = 0; i < numberOfTrainingExamples; i++){ //this is to load up training examples
      x[i] = data.nextTrainImage();
      y[i] = data.nextTrainLabel();
    }
    for(int i = 0; i < numberOfTestingExamples; i++){
      xTest[i] = data.nextTestImage();
      yTest[i] = data.nextTestLabel();
    }
    X = new Matrix(x);
    Y = new Matrix(y);
    XTest = new Matrix(xTest);
    YTest = new Matrix(yTest);
    
    println("Loaded MNIST.");
    println("X Number of Features: " + X.cols);
    println("Y Outputs: " + Y.cols);
  }
  catch (IOException e){
    println("Could not load Mnist - Add MNIST files to the processing directory at: \n" + sketchPath());
    //failed to load mnist database, closes the application
    exit();
  }
  //-------------------------------------------------------------------------------
  //Initialize Variables 
  //-------------------------------------------------------------------------------
  size(400, 400);
  dims = new int[]{X.cols, 25, 17, Y.cols}; //each element represents a layer and it's dimensions
  drawing = new Drawing(desiredRows, desiredCols);
  String weights[] = loadStrings("weights.txt");
  if(weights != null){
    net = new NeuralNetwork(weights, learningRate);
    //train = false;
    println("Loaded Pre-Trained Weights.");
  }else{
    net = new NeuralNetwork(dims, learningRate);//sets the NN given the dimensions and learning rate
  }
  initialCost = net.error(X, Y); //finds the cost of the NN before any backprop
  prevCost = initialCost; //this is used to for ensuring the cost never increases
  initialTestCost = net.error(XTest, YTest);
  prevTestCost = initialTestCost;
}

void draw(){
  background(255);//sets window to white
  i++;
  if(i % 120 == 0){
    thread("trainNetwork");
  }
  //-------------------------------------------------------------------------------
  //Draw the first examples to the canvas to ensure it is printing right 
  //-------------------------------------------------------------------------------
  //make sure frameRate is set to 1
  /*
  drawing.drawBox(XTest.getEx(i));
  println("Guess: " + net.predict(XTest.getEx(i)));
  println("Actual: " + YTest.getEx(i).max()[0]);
  */
  //-------------------------------------------------------------------------------
  //Draws to the canvas
  //-------------------------------------------------------------------------------

  //this activates whenever the user colors on the canvas

  if(mousePressed){
    drawing.drawBox();
    return;
  }
  //this prints the NN guess of what the user drew
  drawing.guess();
}

void mouseReleased(){
  drawing.cleanBox();
}
void keyPressed(){
  if (keyCode == ESC){
    end();
  }
  if (key == 'S' || key == 's'){
    saveWeights();
  }
  if (key == 'T' || key == 't'){
    train = false;
  }
}

//-------------------------------------------------------------------------------
//Performs the backpropagation until it hits the given error threshold
//-------------------------------------------------------------------------------
void trainNetwork(){
  if(train){
    this.iteration++;
    int iteration = this.iteration;
    net.backprop(X);
    float cost = net.error(X, Y);
    float testCost = net.error(XTest,YTest);
    println("Cost (" + iteration + "): " + cost);
    println("Test Cost (" + iteration + "): " + testCost);
    if(cost > prevCost || testCost > initialTestCost + 0.01 || testCost > prevTestCost + 0.01 ){
      println("Cost Increased! Try reducing the learning rate.");
      train = false;
      saveWeights();
    }
    if(testCost<0.1){ //this is just my arbitrary threshold for the goal cost
      end();
    }
    prevCost = cost;
    prevTestCost = testCost;
  }
}

void end(){
  for(int m = 0; m < 40; m++){
    int i = (int) random(XTest.rows);
     println("Should be: " + YTest.getEx(i).max()[0] + ". NN got: " + net.predict(XTest.getEx(i)));//if it prints out 0 for the NN that means all the guesses are the same
   }
  println("Initial Cost: " + initialCost);
  println("Initial Test Cost: " + initialTestCost);
  println("Cost: " + net.error(X, Y));
  println("Cost on Test: " + net.error(XTest, YTest));
  println("Finished in " + iteration + " iterations and " + millis()/1000.0 + " seconds");
  saveWeights();
  exit();
}

void saveWeights(){
  saveStrings("weights " + day() + "-" + month() + "-" + year() + "(" + hour() + ":" + minute() + ":" + second() + ")" + ".txt", net.saveWeights());
  println("Weights saved");
}
