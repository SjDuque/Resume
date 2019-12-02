Population pop;
Snake snake;
Brain brain;
int maxGens = 250;
int maxMoves = 100;
int maxTestMoves = maxMoves * 3;
int generation = 0; 
boolean pause = false;
int tick = 0;
int move = 0;
void setup(){
  size(400, 400);
  pop = new Population(100);
  pop.generation(maxGens);
  brain = pop.brains[0];
  snake = brain.snake;
  println("it works");
}

void draw(){
  
  if(snake.alive && !pause && move < maxTestMoves){
      move++;
      brain.move();
      printGrid(snake.grid);
  }
  else if(!snake.alive || move >= maxMoves){
    move = 0;
    println(brain);
    maxMoves ++;
    pop.generation(maxGens);
    
    brain = pop.brains[0];
    snake = brain.snake;
  }

}




void printGrid(int[][] grid){
  int scaleX = width/grid.length;
  int scaleY = height/grid[0].length;
  for(int x = 0; x < grid.length; x++){
    for(int y = 0; y < grid[0].length; y ++){
      if(grid[x][y] == 2){
        fill(255, 0, 0);
      }
      else if(grid[x][y] == 1){
        fill(255);
      }
      else{
        fill(0);
      }
      stroke(0);
      square(x*scaleX, y*scaleY, scaleX);
    }
  }
}

boolean arrowKey(){
  if(keyCode == UP){
    return snake.up();
  }
  else if(keyCode == DOWN){
    return snake.down();
  }
  else if(keyCode == LEFT){
    return snake.left();
  }
  else if(keyCode == RIGHT){
    return snake.right();
  }
  return false;
}
void keyPressed(){
  if(key == 'p' || key == 'P'){
    pause = !pause;
  }   
}
  
