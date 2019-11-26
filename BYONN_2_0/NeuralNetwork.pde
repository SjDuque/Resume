import java.util.Scanner;
class NeuralNetwork{
  Matrix [] Theta; //These are the weights for the Neural Network. The neural network itself
  
  float lr; //learning rate of the neural network
  float lambda = 1; //regularizing constant
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
  //Forward Propagation and Cost Function
  //-------------------------------------------------------------------------------
  int predict(Matrix x){
    return net.forward(x)[0][dims.length-1].max()[0];
  }
  
  Matrix[][] forward(Matrix x){
    return forward(x, Theta);
  }
  Matrix[][] forward(Matrix x, Matrix[] Theta){//returns the Z and A matrix, both of which are 3 dimensional
    Matrix[][] forward = new Matrix[2][];
    Matrix[] A = new Matrix[L];
    Matrix[] Z = new Matrix[L];
    
    A[0] = x;
    
    if(x.rowVector()){
      A[0] = A[0].transpose();
    }
    
    for(int l = 1; l < L; l++){
      A[l-1] = A[l-1].addBias();
      Z[l] = Theta[l-1].mult(A[l-1]);
      A[l] = Z[l].sigmoid();
    }
    forward[0] = A;
    forward[1] = Z;
    return forward;
  }
  
  float cost(Matrix X, Matrix Y){
    return cost(X, Y, Theta);
  }
  float cost (Matrix X, Matrix Y, Matrix[] Theta){
    float cost = error(X, Y, Theta);
    int m = X.cols;
    //this second loop calculates the regularization
    float regularized = 0;
    //I've decided to not include regularization because it's computationally expensive
    for(int l = 0; l < L-1; l++){
      regularized += Theta[l].removeColumn(0).pow(2).sum();
    }
    regularized *= lambda/m;//this is the normalization constant
    
    return cost + regularized;//adds the 2 together and finds the mean cost of each example
  }
  float error(Matrix X, Matrix Y){
    return error(X, Y, Theta);
  }
  float error(Matrix X, Matrix Y, Matrix[] Theta){//cost with no regularization
     float cost = 0;
    int m = X.rows;//number of training examples
    
    //this first for loop just calculates the error
    for(int i = 0; i < m; i++){
      Matrix x = X.getEx(i);
      Matrix y = Y.getRow(i);
      Matrix H = forward(x, Theta)[0][L-1]; //grabs the last layer of the neural network, aka hypothesis
      // This is a vectorized example
      cost += (y.mult(H.log()).add(          //positive example
      y.sub(1).mult(H.sub(1).log()))).sum(); //negative example then sums
      /*
      for(int k = 0; k < Y.cols; k++){
        float y = Y.mat[i][k];
        float h = H.mat[k][0];
        cost += y * log(h) + (1-y)*log((1-h));
      }
      */
    }
    return -cost/m;
  }
  
  //-------------------------------------------------------------------------------
  //Back Propagation and Gradients - Compute, check, and apply gradients
  //-------------------------------------------------------------------------------
  
  void backprop(Matrix X){
    
    for(int l = 0; l < L-1; l++){
      Matrix grad = gradients(X)[l];
      Theta[l] = Theta[l].sub(grad.mult(lr));
    }
    
  }
  Matrix[] gradients(Matrix X){ //finds the gradients necessary to minimize the cost
    Matrix[] Delta = new Matrix[L-1];//acts as the accumilator for adding every example's gradient
    for(int l = 0; l < L-1; l++){
      Delta[l] = new Matrix(Theta[l].rows, Theta[l].cols);
    }
    Matrix[] d = new Matrix[L];//acts as the temporary storage for the gradients
    int m = X.rows;
    for(int i = 0; i < m; i ++){//transverses through every example
      Matrix [][] AZ = forward(X.getEx(i));//gets the Activated and Unactivated nodes of the NN
      Matrix [] A = AZ[0]; //grabs the Activated Matrix from the AZ matrix
      Matrix [] Z = AZ[1]; //grabs the Unactivated Matrix from the AZ matrix
      d[L-1] = A[L-1].sub(Y.getEx(i)); //sets the outer delta to the a - y
      for(int l = L-2; l > 0; l--){ //starts after the d we just declared
        Matrix g = Z[l].deriv();
        Matrix theta = Theta[l].transpose();
        d[l] = theta.removeRow(0).mult(d[l+1]).eMult(g);
      }
      for(int l = 0; l < Delta.length; l++){
        Matrix dA = d[l+1].mult(A[l].transpose());
        Delta[l] = Delta[l].add(dA);
      }
    }
    
    for(int l = 0; l < Delta.length; l++){
        //This is the regularization addition to the gradients. I've decided to not include it because it's computationall expensive for litte gain in performance
        for(int r = 0; r < Theta[l].rows; r++){
          for(int c = 1; c < Theta[l].cols; c++){
            Delta[l].mat[r][c] += lambda*(Theta[l].mat[r][c]);//this is the regularization.
          }
        }
      Delta[l] = Delta[l].mult(1.0/m);
    }
    return Delta;
  }
  
  Matrix[] checkGradients(Matrix X, Matrix Y){
    float epsilon = 0.001;
    Matrix[] check = new Matrix[Theta.length];
    for(int l = 0; l < L-1; l++){
      check[l] = new Matrix(Theta[l].rows, Theta[l].cols);
      Matrix[] cloneTheta = new Matrix[Theta.length];//this holds the cloned theta
      for(int i = 0; i < Theta.length; i++){
        cloneTheta[i] = Theta[i].clone();
      }

      Matrix theta = cloneTheta[l];
      
      for(int r = 0; r < theta.rows; r++){
        for(int c= 0; c < theta.cols; c++){
          float[][] thetaP = theta.copy();
          thetaP[r][c] += epsilon;
          float[][] thetaM = theta.copy();
          thetaM[r][c] -= epsilon;
          cloneTheta[l] = new Matrix(thetaP);
          float cost1 = cost(X, Y, cloneTheta);
          cloneTheta[l] = new Matrix(thetaM);
          float cost2 = cost(X, Y, cloneTheta);
  
          check[l].mat[r][c] = (cost1-cost2)/(2 * epsilon);
        }
      }
    }
    return check;
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
