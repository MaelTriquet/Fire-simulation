ArrayList<Ball> balls = new ArrayList<Ball>();
int widthCell;
int heightCell;
int minRadius = 8;
int maxRadius = 9;
Cell[] cells;
int startI;
int stopI;
PVector[] init;
int startingFountainNb = 9;
int fountainNb = startingFountainNb;
Threading[] threads;
boolean showing = true;
color[] colors;
int lastChange = 0;
float startingSpeed = 1;
float speed = startingSpeed;
int substeps = 8;
boolean pause = false;
int maxBalls;
ArrayList<Integer> rand = new ArrayList<Integer>();

void setup() {
  size(500, 500);
  noStroke();
  background(0);
  widthCell = ((int)width) / maxRadius + 1;
  threads = new Threading[max(widthCell/4, 1)];
  heightCell = ((int)height) / maxRadius + 1;
  cells = new Cell[widthCell * heightCell];
  for (int i = 0; i < cells.length; i++) {
    cells[i] = new Cell(i);
  }
  for (int i = 0; i < 4000; i++) {
    balls.add(new Ball(maxRadius, new PVector(random(width), random(height)), new PVector(cos(frameCount / 150.), abs(sin(frameCount/150.))).mult(speed), balls.size()));
  }
}

void draw() {
  if (!pause) {
    background(0, 0, 0, 10);

    for (int i = 0; i < substeps; i++) {
      collision();
    }
    for (Ball b : balls) {
      if (showing) {
        b.show();
      }
      b.update();
    }
    lastChange++;
  } else {
    frameCount--;
  }
}

void collision() {
  for (Ball b : balls) {
    b.wallCollide();
  }
  updateCells();
  //first half to make it deterministic
  for (int i = 0; i < threads.length; i++) {
    threads[i] = new Threading((int) (i * (1. * widthCell/threads.length)), (int) (i *  (1. * widthCell/threads.length) + widthCell/(threads.length*2)), 1);
  }
  for (int i = 0; i < threads.length; i++) {
    threads[i].start();
  }
  try {
    for (int i = 0; i < threads.length; i++) {
      threads[i].join();
    }
  }
  catch (InterruptedException e) {
  }

  //second half
  for (int i = 0; i < threads.length; i++) {
    threads[i] = new Threading((int) (i * (1. * widthCell/threads.length) + widthCell/(threads.length*2)), (int)((i+1) *  (1. * widthCell/threads.length)), 2);
  }
  for (int i = 0; i < threads.length; i++) {
    threads[i].start();
  }
  try {
    for (int i = 0; i < threads.length; i++) {
      threads[i].join();
    }
  }
  catch (InterruptedException e) {
  }
}


void keyPressed() {
  if (key == 'p') {
    pause = !pause;
  } else if (key == 'e') {
    lastChange = 500;
  }
}
