import java.util.Scanner;
class NeuralNetwork{
  Matrix [] Theta; //These are the weights for the Neural Network. The neural network itself
  
  float lr; //learning rate of the neural network

  final int dims[]; //stores the number of nodes in every layer
  final int L; //stores the number of layers of the matrix
  
  //-------------------------------------------------------------------------------
  //Constructor for the Neural Network
  //-------------------------------------------------------------------------------
  NeuralNetwork(String Weights[], float lr){
    this.Theta = loadWeights(Weights);
    this.lr = lr;
    this.L = Theta.length+1;
    this.dims = new int[L];

    dims[0] = Theta[0].cols-1;
    
    for(int i = 0; i < Theta.length; i++){
      dims[i+1] = Theta[i].rows;
    }

  }
  
  NeuralNetwork(Matrix[] Theta, float lr){
    this.Theta = Theta;
    this.lr = lr;
    this.L = Theta.length+1;
    this.dims = new int[L];

    dims[0] = Theta[0].cols-1;
    for(int i = 0; i < Theta.length; i++){
      dims[i+1] = Theta[i].rows;
    }
  }
  
  NeuralNetwork(int[]dimensions){
    this(dimensions, 1);
  }
  NeuralNetwork(int[] dimensions, float lr){
    dims = dimensions;
    L = dims.length;
    Theta = new Matrix[L-1];
    this.lr = lr;
    float thetaEpsilon = 0.12; //used for the random initialization for the weights of the NN
    for(int i = 0; i < Theta.length; i++){
      Theta[i] = new Matrix(dims[i+1], dims[i]+1);//sets theta to a random matrix with the next layers nodes by this layers nodes and a bias
      Theta[i].random(thetaEpsilon);
    }
  }
  
  //-------------------------------------------------------------------------------
  //Forward Propagation
  //-------------------------------------------------------------------------------
  
  Matrix forward(Matrix x){//returns the Z and A matrix, both of which are 3 dimensional
    Matrix[] A = new Matrix[L];
    Matrix[] Z = new Matrix[L];
    
    A[0] = x;
    
    if(x.rowVector()){
      A[0] = A[0].transpose();
    }
    
    for(int l = 1; l < L; l++){
      A[l-1] = A[l-1].addBias();
      Z[l] = Theta[l-1].mult(A[l-1]);
      A[l] = Z[l].activate();
    }
    return A[L-1];
  }
  NeuralNetwork clone(){
    Matrix[] thetaClone = new Matrix[L-1];
    for(int l = 0; l < L-1; l++){
      thetaClone[l] = Theta[l].clone();
    }
    return new NeuralNetwork(thetaClone, lr);
  }
  
  NeuralNetwork mutate(float mr){

    NeuralNetwork mutated = clone();
    Matrix thetaClone[] = mutated.Theta;
    for(int l = 0; l < L-1; l++){
        thetaClone[l] = thetaClone[l].mutate(mr, lr);
    }
    return mutated;
  }
  
  String [] saveWeights(){
    String str[] = new String[Theta.length+1]; //the string getting returned
    str[0] = "" + L;
    for(int l = 1; l < str.length; l++){
      str[l] = "";
      String part = Theta[l-1].toString();
      String[] lines = part.split(System.getProperty("line.separator"));
      for(int i = 0; i < lines.length; i++){
        String [] line = lines[i].trim().split(" "); //this stores the line seperated by spaces, should have floats
        if (line[0].equals("")){
          continue;
        }
        for(int n = 0; n < line.length; n++){
          try{
            String add = line[n].trim();
            Float.parseFloat(add);
            str[l] += add + " ";
          } catch(NumberFormatException nfe){
            
          }
        }
        if(i < lines.length-1){
          str[l] += "\n";
        }
      }
    }
    return str;
  }
  Matrix[] loadWeights(String[] savedWeights){
    int L = Integer.parseInt(savedWeights[0].trim());
    Matrix[] Theta = new Matrix[L-1];
    int line = 1;
    for(int l = 0; l < L-1; l++){
      String size[] = savedWeights[line++].split(" ");//grabs the row and column from the line
      
      int rows = Integer.parseInt(size[0].trim());
      int cols = Integer.parseInt(size[1].trim());

      float[][] theta = new float[rows][cols];
      
      for(int r = 0; r < rows; r++){
        String[] weights = savedWeights[line++].split(" ");
        for(int c = 0; c < cols; c++){
        try{
          theta[r][c] = Float.parseFloat(weights[c].trim());
         } catch(NumberFormatException nfe){
            
         }
        } 
       }
       Theta[l] = new Matrix(theta);
    }
    
    return Theta;
  }
}
