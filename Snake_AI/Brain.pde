class Brain{
  Snake snake = new Snake();
  NeuralNetwork brain;
  
  final float mr;//mutation rate
  final float lr;//learning rate
  final int[] dims;
  
  int moves = 1;
  float fitness; 
  
  Brain(float mutationRate, float learningRate, int[] dimensions){
    this(mutationRate, learningRate, dimensions, new NeuralNetwork(dimensions));
  }
  Brain(float mutationRate, float learningRate, int[] dimensions, NeuralNetwork brain){
    mr = mutationRate;
    lr = learningRate;
    dims = dimensions;//dimensions of neural network
    this.brain = brain;
  }
  Brain clone(){
    NeuralNetwork clone = brain.clone();
    return new Brain(mr, lr, dims, clone);
  }
  Brain mutate(){
    NeuralNetwork clone = brain.mutate(mr);
    return new Brain(mr, lr, dims, clone);
  }
  Matrix features(){
    Body head = snake.head();
    Apple apple = snake.apple;
    int maxX = snake.maxX;
    int maxY = snake.maxY;
    
    float xAppleDist = (float)(head.x - apple.x)/maxX;//normalized x distance from apple to snake
    float yAppleDist = (float)(head.y - apple.y)/maxY;
    
    //float sqXApple = xAppleDist * xAppleDist;
    //float sqYApple = yAppleDist * yAppleDist;
    
    //float slope = yAppleDist/xAppleDist;
    //float sqSlope = slope * slope;
    
    float x = (float) (head.x)/maxX;
    float x2 = x * x;
    
    float y = (float) (head.y)/maxY;
    
    float y2 = y * y;
    
    float slope = yAppleDist/xAppleDist;
    /*
    if(snake.isLeft()){
      slope = xAppleDist/yAppleDist;
      relX = 1-y;
      relY = x;
    } else if(snake.isRight()){
      slope = -xAppleDist/yAppleDist;
      relX = y;
      relY = 1-x;
    }else if(snake.isUp()){
      slope = yAppleDist/xAppleDist;
      relX = x;
      relY = y;
    } else {
      slope = -yAppleDist/xAppleDist;
      relX = 1-x;
      relY = 1-y;
    }
    */
    float [][] features = {{/*xAppleDist, yAppleDist,*/x, y, slope/*, horizontalDir, verticalDir*//*, sqSlope, sqLeftWallDist, sqUpWallDist*/}};
    
    return new Matrix(features);
  }
  void restart(){
    snake = new Snake();
    moves = 1;
  }
  void move(){
    if(snake.alive == true){
      moves++;
      int move = brain.forward(features()).max()[0];
  
      if(move == 0){
        snake.up();
      }
      else if(move == 1){
        snake.down();
      }
      else if(move == 2){
        snake.left();
      }
      else{
        snake.right();
      }
      
      snake.move();
   }
    
  }
  
  float fitness(){
    float distance = distanceApple();
    int score = snake.score;
    fitness = 1/(distance) + score*score;
    return fitness;
  }
  
  float distanceApple(){//returns the squared eclidian distance.
      Apple apple = snake.apple;
      Body head = snake.body.peek();
      return pow(apple.x-head.x, 2) + pow(apple.y-head.y, 2);
  }
  
  String toString(){
    fitness();
    return "score: " + snake.score + " fitness: " + fitness + " alive: " + snake.alive;
  }
  
  String save(){
    return "\n";
  }
}
