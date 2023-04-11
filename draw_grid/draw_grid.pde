void setup(){
  size(500, 500);
  drawgrid(5,5,100);
}
void draw(){
  
}

void mousePressed(){
  save("grid.png");
}


void drawgrid(int rows, int cols, int cellSize){
  stroke(0);
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      rect(j * cellSize, i * cellSize, cellSize, cellSize);
    }
  }
}
