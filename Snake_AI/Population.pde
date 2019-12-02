class Population{
  Brain brains[];
  int best;
  float fitnessSum;
  
  Population(int popSize){
    brains = new Brain[popSize];
    
    for(int i = 0; i < brains.length; i++){
      brains[i] = new Brain(0.01, 0.06, new int[]{3, 3, 4});//mr then lr
    }
  }
  
  Brain generation(){//returns the best snake
    move();
    mutate();
    return brains[best];
  }
  Brain generation(int gens){
    for(int i = 0; i < gens; i++){
      generation();
    }
    println("Generation: " + ++generation);
    return brains[best];
  }
  
  void move(){
   for(Brain brain : brains){
     if(brain.snake.alive){
      for(int j = 0; j < maxMoves; j ++){
        brain.move();
      }
     }
   }
  }
  
  void mutate(){
    int len = brains.length;
    Brain [] newBrains = new Brain[len];
    fitnessSum();
    best = highestFitness();
    
    newBrains[0] = brains[best]; 
    int i = 1;
 
    for(; i < len/100; i++){
      newBrains[i] = new Brain(newBrains[0].mr, newBrains[0].lr, newBrains[0].dims);
    }

  
    for(; i < len; i++){
      newBrains[i] = selectOffspring();
    }
    newBrains[0].restart();
    brains = newBrains;
  }
  
  void restart(){
    for(Brain brain : brains){
      brain.restart();
    }
  }
  
  Brain selectOffspring(){
      float sum = 0;
      float random = (float)Math.random()*fitnessSum;
      for(Brain brain : brains){
        sum += brain.fitness();
        if(sum >= random){
          return brain.mutate();
        }
      }
      
      println("Something went wrong with SelectOffspring");
      return null;
  }
  
  float fitnessSum(){
    float sum = 0;
    for(Brain brain : brains){
      sum += brain.fitness();
    }
    this.fitnessSum = sum;
    return sum;
  }
  
  int highestFitness(){
    int highest = 0;
    float highestFitness = brains[0].fitness;
    for(int i = 1; i < brains.length; i ++){
      float fitness = brains[i].fitness;
      if(highestFitness < fitness){
        highest = i;
        highestFitness = fitness;
      }
    }
    return highest;
  }
}
