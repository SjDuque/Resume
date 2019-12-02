import java.util.LinkedList;

class Snake{
  LinkedList<Body> body = new LinkedList<Body>();
  int [] dir = {0, -1};//[x, y]
  int [] tailDir = {0, 1};//[x,y]
  int maxX = 20;
  int maxY = 20;
  int[][] grid = new int[maxX][maxY];//this is the game board, 0 is nothing, 1 is body, 2 is apple
  Apple apple = new Apple(grid, maxX, maxY);
  int score = 0;
  boolean alive = true;
  
  Snake(){
    body.add(new Body(grid, 10, 10));
    grid[10][10] = 1;
    body.add(new Body(grid, 10, 11));
    grid[10][11] = 1;
    body.add(new Body(grid, 10, 12));
    grid[10][12] = 1;
  }
  Body head(){
    return body.peek();
  }
  void move(){
    if(alive){
      //spawns the newhead into existence
      Body oldHead = body.peek();
      Body tail = body.peekLast();
      int newX = oldHead.x + dir[0];
      int newY = oldHead.y + dir[1];
      Body newHead = new Body(grid, newX, newY);//spawns in the new head of the snake
      
      try{
        if(grid[newX][newY] == 1 && !newHead.equals(tail)){//checks to see if the next block is a body
          alive = false;
          return;
        }
      }catch(Exception e){//this executes if the new block is out of the grid
        alive = false;
        return;
      }
      
      if(apple.eat(newHead)){
        score++;//adds the score to the snake
      }else{//if it moves on an apple, it doesn't lose it's tail for that turn
        body.pollLast().delete();//gets and removes tail from the body, then deletes it from the grid
      }
      grid[newX][newY] = 1;//sets the new position to a body
      body.addFirst(newHead);//adds the new head to the body
      tailDir[0] = dir[0];
      tailDir[1] = dir[1];
    }
  }
  
  void rotateLeft(){//rotates the snake head
    if(isRight()){
      up();
    }
    else if(isLeft()){
      down();
    }
    else if(isDown()){
     right();;
    }else{
      left();
    }
  }
  void rotateRight(){
    if(isRight()){
      down();
    }
    else if(isLeft()){
      up();
    }
    else if(isDown()){
      left();
    }else{
      right();
    }
  }
  boolean left(){ //moves left... self explanatory
    if(tailDir[0] == 0){
      changeDir(-1, 0);
      return true;
    }
    return false;
  }
  
  boolean right(){
    if(tailDir[0] == 0){
      changeDir(1, 0);
      return true;
    }
    return false;
  }
  
  boolean down(){
    if(tailDir[1] == 0){
      changeDir(0, 1);
      return true;
    }
    return false;
  }
  boolean up(){
    if(tailDir[1] == 0){
      changeDir(0, -1);
      return true;
    }
    return false;
  }
  boolean isLeft(){
    return tailDir[0] == -1;
  }
  boolean isRight(){
    return tailDir[0] == 1;
  }
  boolean isUp(){
    return tailDir[1] == -1;
  }
  boolean isDown(){
    return tailDir[1] == 1;
  }
  
  void changeDir(int x, int y){
    dir[0] = x;
    dir[1] = y;
  }
}

class Box{
  int x;
  int y;
  int[][] grid;
  
  Box(int[][] grid, int x, int y){
    this.x = x;
    this.y = y;
    this.grid = grid;
  }
  void delete(){
    grid[x][y] = 0;
  }
  
  boolean equals(Box box){
    return x == box.x && y == box.y;
  }
}

class Body extends Box{
  
  Body(int[][] grid, int x, int y){
    super(grid, x, y);
  }
  
}
class Apple extends Box{
  int xMax;
  int yMax;
  
  Apple(int[][] grid, int xMax, int yMax){
    super(grid, (int)random(xMax), (int)random(yMax));
    this.xMax = xMax;
    this.yMax = yMax;
    grid[this.x][this.y] = 2;
  }
  
  boolean eat(Body head){
    if(head.x == x && head.y == y){
      delete();//reduces the apple to ashes
      do {
        x = (int)random(xMax);//finds a new random x
        y = (int)random(yMax);//finds a new random y
      }while(grid[x][y] == 1);//makes sure the new apple doesn't spawn in the snake body
      
      grid[x][y] = 2;
      return true;
    }
    return false; //<>//
  }
}
