class Drawing{
  int guess; //this stores the guess for drawBox
  boolean [][] drawBox;//this is the drawing box for the canvas
  int rows;
  int cols;
  
  Drawing(int rows, int cols){
    this.rows = rows;
    this.cols = cols;
    drawBox = new boolean[rows][cols];
    for(int r = 0; r < rows; r++)
      for(int c = 0; c < cols; c++)
        drawBox[r][c] = false;
  }
  
  void cleanBox(){
    float[][] predict = new float[rows*cols][1];
    for(int r = 0; r < drawBox.length; r++){
      for(int c = 0; c < drawBox[0].length;c++){
        stroke(255);
        if (drawBox[r][c]){
          predict[r*cols+c][0] = 1;
        }
      } 
    }
    guess = net.predict(new Matrix(predict));
  
    for(int x = 0; x < drawBox.length; x++)
      for(int y = 0; y < drawBox[0].length; y++)
        drawBox[x][y] = false;
  }
  
  int guess(){
    textSize(200);
    fill(0);
    text(guess + "", width/2-63, height/2+63); 
    return guess;
  }
  void drawBox(){
    drawBox(drawBox);
  }
  void drawBox(Matrix X){
    drawBox(matrixToDrawing(X));
  }
  void drawBox(boolean[][] drawBox){
      int X = round(float(mouseX)/width * cols);
      int Y = round(float(mouseY)/height * rows-.5);
      fill(0, 20, 255);
      for(int x = -1; x < 1; x++){
        for(int y = -1; y < 1; y++){
          if(canDraw(X+x, Y+y)){
            drawBox[X+x][Y+y] = true;
          }
        }
      }
      for(int x = 0; x < drawBox.length; x++){
        for(int y = 0; y < drawBox[0].length;y++){
          stroke(255);
          if (drawBox[x][y]){
            rect(x*(width/desiredCols),y*(height/desiredRows), (width/desiredCols), (height/desiredRows));
          }
        }
      }
  }
  boolean[][] matrixToDrawing(Matrix X){
    X = X.greaterThan(0);
    boolean[][] ex = new boolean[drawBox.length][drawBox[0].length];
    for(int r = 0; r < drawBox.length; r++){
      for(int c = 0; c < drawBox[0].length;c++){
        ex[r][c] = false;
        if (X.get(r*desiredCols+c, 0) == 1){
          ex[r][c] = true;
        }
      }
      
    }
    return ex;
  }
  boolean canDraw(float X, float Y){
     if (X >= 0 && Y >= 0 && X < cols  && Y < rows){
       return true;
     }
    return false;
  }
}
