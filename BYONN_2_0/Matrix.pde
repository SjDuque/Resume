class Matrix {
  final int rows;//the number of rows
  final int cols;//the number of columns
  float[][] mat;//The godly matrix that this class is based upon
  
  //-------------------------------------------------------------------------------
  //Constructors for the Matrix
  //-------------------------------------------------------------------------------

  Matrix(int rows, int columns){ //declares a matrix with given dimensions
    mat = new float[rows][columns];
    this.rows = rows;
    this.cols = columns;
  }
  
  Matrix(float[][] mat){ //sets mat with given matrix
    this.mat = mat;
    this.rows = mat.length;
    this.cols = mat[0].length;
  }
  
  Matrix(Matrix matrix){
    this(matrix.copy());
  }
  
  void random(float f){//randomizes a matrix consisting a different random number in every element
    
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){
        mat[r][c] = (float)((Math.random()*2-1)*f);
      }
    }
  }
  
  void random(){
    random(1);
  }
  
  Matrix zeros(int rows, int cols){//returns a matrix consisting of 0 in every element
    return number(rows, cols, 0);
  }
  
  Matrix ones(int rows, int cols){//returns a matrix consisting of 1 in every element
    return number(rows, cols, 1);
  }
  
  Matrix number(int rows, int cols, float f){//returns a matrix consisting of the same number in every element
    float[][] number = new float[rows][cols];
    
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){
        number[r][c] = f;
      }
    }
    return new Matrix(number);
  }
  
  Matrix clone(){
    return new Matrix(this.copy());
  }
  
  //-------------------------------------------------------------------------------
  //Basic Functionality of A Matrix
  //-------------------------------------------------------------------------------
  
  int [] size(){ //returns the number of rows and columns of the matrix in an array
    return new int[]{rows, cols};
  }
  int [] max(){ //returns the index of the greatest element
    int[] max = new int[]{0, 0};//stores the row and col
    for(int r = 0; r < rows; r++){
      int row = max[0];
      int col = max[1];
      for(int c = 0; c< cols; c++){
        if(mat[row][col] < mat[r][c]){
          max[0] = r;
          max[1] = c;
        }
      }
    }
    return max;
  }
  float [][] copy(){
    float[][] copy = new float[rows][cols];//this is the matrix that will get copied
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        copy[r][c] = mat[r][c]; //copies the float from mat to copy
      }
    }
    return copy;
  }
  
  boolean rowVector(){ //returns whether or not mat is a row vector, aka 1 * cols dimension
    return rows == 1; 
  }
  boolean columnVector(){//returns whether or not it's a column vector
    return cols == 1;
  }
  
  boolean scalar(){
    return rowVector() && columnVector();
  }
  String toString(){ //returns matrix as a string
    String str = "";
    str += rows + " by " + cols + " matrix:\n";
    for(int r = 0; r < rows; r++){
      str += "\n  ";
      //str += "Row " + r + ": ";
      for(int c = 0; c < cols; c++){
        str += mat[r][c] + " ";
      }
    }
    str += "\n";
    return str;
  }
  float get(int row, int column){
    return mat[row][column];
  }
  
  Matrix set(int row, int column, float f){
    float[][] copy = copy();
    copy[row][column] = f;
    return new Matrix(copy);
  }
  
  Matrix getRow(int r){ //gets a row from the matrix and returns it as a row vector
    float[][] vector = new float[1][cols];
    for(int c = 0; c < cols; c++){
      vector[0][c] = mat[r][c];
    }
    return new Matrix(vector);
  }
  
  Matrix getCol(int c){ //gets a column from the matrix and returns it as a column vector
    float[][] vector = new float[rows][1];
    for(int r = 0; r < rows; r++){
      vector[r][0] = mat[r][c];
    }
    return new Matrix(vector);
  }
  
  Matrix submatrix(int r1, int c1, int r2, int c2){//finds the submatrix of a matrix given the range of rows and columns, (r1, c1) and (r2, c2) are acting as coordinates
    int rows = r2 - r1;
    int cols = c2 - c1;
    float submatrix[][] = new float[rows][cols];
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        submatrix[r][c] = mat[r+r1][c+c1]; //copes the element to the submatrix, you only need the lower bounds because the upperbound is limited by the for loop
      }
    }
    return new Matrix(submatrix);
  }
  Matrix removeRow(int i){
    if(rows <= i){
      return new Matrix(this);
    }
    float[][] removed = new float[rows-1][cols];
    int testI = 0; //this varible turns into negative 1 when r == i to make the calculations a little easier for the removed because removed will be a row behind
    for(int r = 0; r < rows; r++){
      if(r == i){ //if the current row is equal to the skipped row then it skips to the new row
        testI--;
        continue;
      }
      for(int c = 0; c < cols; c++){
        removed[r+testI][c] = mat[r][c];
      }
    }
    return new Matrix(removed);
  }
  Matrix removeColumn(int i){
    if(rows <= i){
      return new Matrix(this);
    }
    float[][] removed = new float[rows][cols-1];
    int testI = 0; //this varible turns into negative 1 when c == i to make the calculations a little easier for the removed because romoved will be a column behind
    for(int c = 0; c < cols; c++){
      if(c == i){ //if the current row is equal to the skipped row then it skips to the new row
        testI--;
        continue;
      }
      for(int r = 0; r < rows; r++){
        removed[r][c+testI] = mat[r][c];
      }
    }
    return new Matrix(removed);
  }
  
  Matrix equals(float f){ //sets element to 1 if it is equal to f, 0 otherwise
    float[][] equals = new float[rows][cols];
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        float equal = 0;
        if(mat[r][c] == f){
          equal = 1;
        }
        equals[r][c] = equal; //copies the float from mat to copy
      }
    }
    return new Matrix(equals);
  }
  
  
  Matrix equals(Matrix X){ //sets element to 1 if it is equal to corresponding X element, 0 otherwise
    if(rows != X.rows || cols != X.cols){
      
    }
    float[][] equals = new float[rows][cols];
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        float equal = 0;
        if(mat[r][c] == X.mat[r][c]){
          equal = 1;
        }
        equals[r][c] = equal; //copies the float from mat to copy
      }
    }
    return new Matrix(equals);
  }
  Matrix lessThan(float f){ //sets element to 1 if it is equal to f, 0 otherwise
    float[][] less = new float[rows][cols];
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        float lessThan = 0;
        if(mat[r][c] < f){
          lessThan = 1;
        }
        less[r][c] = lessThan; //copies the float from mat to copy
      }
    }
    return new Matrix(less);
  }
  Matrix greaterThan(float f){ //sets element to 1 if it is equal to f, 0 otherwise
    float[][] equals = new float[rows][cols];
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        float equal = 0;
        if(mat[r][c] > f){
          equal = 1;
        }
        equals[r][c] = equal; //copies the float from mat to copy
      }
    }
    return new Matrix(equals);
  }
  //-------------------------------------------------------------------------------
  //Scalar Operations - A scalar is a 1 * 1 dimensional matrix, which is just a float
  //-------------------------------------------------------------------------------
  
  Matrix add(float scalar){
    float[][] sum = new float[rows][cols];//this is the matrix that will get copied
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        sum[r][c] = mat[r][c] + scalar; //copies the float from mat to copy
      }
    }
    return new Matrix(sum);
  }
  Matrix sub(float scalar){//this actually subtracts the matrix from the scalar
    float[][] sum = new float[rows][cols];//this is the matrix that will get copied
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        sum[r][c] = scalar - mat[r][c]; //subtracts the mat element from scalar
      }
    }
    return new Matrix(sum);
  }
  Matrix mult(float scalar){
    float[][] product = new float[rows][cols];//this is the matrix that will get copied
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        product[r][c] = mat[r][c] * scalar; //copies the float from mat to copy
      }
    }
    return new Matrix(product);
  }
  
  Matrix pow(float power){
    float[][] powers = new float[rows][cols];//this is the matrix that will get copied
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        powers[r][c] = (float)Math.pow(mat[r][c],power); //copies the float from mat to copy
      }
    }
    return new Matrix(powers);
  }
  
  Matrix log(float base){
    float[][] logs = new float[rows][cols];//this is the matrix that will get copied
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        logs[r][c] = (float)(Math.log(mat[r][c])/Math.log(base)); //copies the float from mat to copy
      }
    }
    return new Matrix(logs);
  }
  Matrix log(){
    float[][] logs = new float[rows][cols];//this is the matrix that will get copied
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        logs[r][c] = (float)Math.log(mat[r][c]); //copies the float from mat to copy
      }
    }
    return new Matrix(logs);
  }
  
  float sum(){//return the sum of all the elements in the matrix
    float sum = 0;
    for(float[] r : mat){
      for(float f : r){
        sum += f;
      }
    }
    return sum;
  }
  
  //-------------------------------------------------------------------------------
  //Matrix Operations - Math with other matrices
  //-------------------------------------------------------------------------------
  
  Matrix transpose(){ //returns the transposed version of mat
    float[][] transpose = new float[cols][rows];//this is the transposed matrix of mat
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        transpose[c][r] = mat[r][c]; //copies the rth row and cth col to the cth row and rth col of transpose
      }
    }
    return new Matrix(transpose);
  }
  Matrix eMult(Matrix X){
    if(rows != X.rows || cols != X.cols){
      println("\n----------");
      println("Invalid dimensions for element-wise multiplying matrices");
      println("Rows and Columns of first matrix: " + this.rows + " " + this.cols);
      println("Rows of second matrix: " + X.rows + " " + X.cols);
      return null;
    }
    float[][] product = new float[rows][cols];//this is the matrix that will store the product of each element
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        product[r][c] = mat[r][c] * X.mat[r][c]; //multiplies corresponding elements
      }
    }
    return new Matrix(product);
  }
  
  Matrix mult(Matrix X){//returns the product of 2 matrices, arguably the most important method in here
    if(this.scalar() && !X.scalar()){//Checks to see if the mat matrix is actually a scalar quantity
      return X.mult(mat[0][0]);
    }
    if(this.scalar() && !X.scalar()){//Checks to see if the X matrix is actually a scalar quantity
      return this.mult(X.mat[0][0]);
    }
    if(this.cols != X.rows){ //this checks to see if it's possible to multiply the 2 matrices
      println("\n----------");
      println("Invalid dimensions for multiplying matrices");
      println("Columns of first matrix: " + this.cols);
      println("Rows of second matrix: " + X.rows);
      return null;
    }
    final int rows = this.rows;//this is the new number of rows for the product,serves mainly for reading because technically nothing changes for the variable rows.
    final int cols = X.cols;// this is the new number of columns for the product
    float[][] product = new float[this.rows][X.cols]; //multiplying an m by n matrix with a n by k matrix results in a m by k dimensional prodiuct matrix
    
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){
        float sum = 0; //this acts as storage for the cell's products
        
        for(int i = 0; i < this.cols; i++){ //this transverses through the columns of the first matrix and the rows of the second
          sum += this.mat[r][i] * X.mat[i][c];
        }
        
        product[r][c] = sum;
      } 
    }
    return new Matrix(product);
  }
  
  Matrix add(Matrix X){
    if(this.scalar() && !X.scalar()){ //Checks to see if the mat matrix is actually a scalar quantity
      return X.add(mat[0][0]);
    }
    if(this.scalar() && !X.scalar()){ //Checks to see if the X matrix is actually a scalar quantity
      return this.add(X.mat[0][0]);
    }
    if(this.cols != X.cols || this.rows != X.rows){
      println("\n----------");
      println("Invalid dimensions for adding matrices");
      println("Row by Column of first matrix: " + this.rows + " " + this.cols);
      println("Rows by Column of second matrix: " + X.rows + " " + X.cols);
      return null;
    }
    
    float[][] sum = new float[rows][cols];
    
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){
        sum[r][c] = mat[r][c] + X.mat[r][c];
      }
    }
    return new Matrix(sum);
  }
   
  Matrix sub(Matrix X){//this could have easily been accomplished by mulitplying X by a -1 scalar but I want to save as much time as possible for operations
    if(this.cols != X.cols || this.rows != X.rows){
      println("\n----------");
      println("Invalid dimensions for adding matrices");
      println("Row by Column of first matrix: " + this.rows + this.cols);
      println("Rows by Column of second matrix: " + X.rows + X.cols);
      return null;
    }
    if(this.scalar() && !X.scalar()){ //Checks to see if the mat matrix is actually a scalar quantity
      return X.add(mat[0][0]);
    }
    if(this.scalar() && !X.scalar()){ //Checks to see if the X matrix is actually a scalar quantity
      return this.add(X.mat[0][0]);
    }
    
    float[][] difference = new float[rows][cols];
    
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){
        difference[r][c] = mat[r][c] - X.mat[r][c];
      }
    }
    return new Matrix(difference);
  }
  
  Matrix horizConc(Matrix X) {//horizonal concatenation of 2 matrices. Adding them like this M | N.
    if(rows != X.rows){
      println("\n----------");
      println("Invalid dimensions for horizonal concatenation of matrices");
      println("Rows of first matrix: " + this.rows);
      println("Rows of second matrix: " + X.rows);
      return null;
    }
    float[][] concat = new float[rows][cols + X.cols];
    for(int r = 0; r < rows; r++){
      int c = 0;
      for(;c<cols; c++){
        concat[r][c] = mat[r][c];
      }
      for(int i = 0; i < X.cols; i++){
        concat[r][c+i] = X.mat[r][i];
      }
    }
    return new Matrix(concat);
  }
  
  Matrix vertConc(Matrix X) {//vertical concatenation of 2 matrices. Adding them like this ÷
    if(cols != X.cols){
      println("\n----------");
      println("Invalid dimensions for vertical concatenation of matrices");
      println("Columns of first matrix: " + this.cols);
      println("Columns of second matrix: " + X.cols);
      return null;
    }
    float[][] concat = new float[rows + X.rows][cols];
    for(int c = 0; c < cols; c++){
      int r = 0;
      for(;r<rows; r++){
        concat[r][c] = mat[r][c];
      }
      for(int i = 0; i < X.rows; i++){
        concat[r+i][c] = X.mat[i][c];
      }
    }
    return new Matrix(concat);
  }
  
  //-------------------------------------------------------------------------------
  //Machine Learning Operations - Math for Neural networks
  //-------------------------------------------------------------------------------
  
  Matrix addBias(){
    if(columnVector()){
      return ones(1,1).vertConc(this);
    }
    return ones(rows, 1).horizConc(this);
  }
  
  Matrix removeBias(){
    if(columnVector()){
      return removeRow(0);
    }
    return removeColumn(0);
  }
  
  Matrix sigmoid(){
    float[][] sigmoid = new float[rows][cols];//this is the matrix that will store the sigmoids
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        sigmoid[r][c] = 1/(1+exp(-mat[r][c])); //calculates sigmoid for the current element
      }
    }
    return new Matrix(sigmoid);
  }
  
  Matrix deriv(){
    float[][] deriv = new float[rows][cols];//this is the matrix that will get copied
    for(int r = 0; r < rows; r++){
      for(int c = 0; c < cols; c++){//lol, c++
        float sigmoid = 1/(1+exp(-mat[r][c]));
        deriv[r][c] = sigmoid * (1-sigmoid); //calculates the derivative of the sigmoid which is g * (1-g)
      }
    }
    return new Matrix(deriv);
  }
  
  Matrix getEx(int r){//gets rth example from the X or Y matrix and returns it as a column vector
    //return getRow(i).transpose();//gets the rth row and transposes it to a column vector
    
    //I decided to not transpose because it slows down the process, so I made this copy the vector as a column rather than as a row
    
    float[][] vector = new float[cols][1];
    for(int c = 0; c < cols; c++){
      vector[c][0] = mat[r][c];
    }
    return new Matrix(vector);
  }
}
