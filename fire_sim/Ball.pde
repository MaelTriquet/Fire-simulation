  class Ball {
  float radius;
  PVector acc;
  PVector vel;
  PVector pos;
  PVector prev_pos;
  color col;
  float mass = 1;
  boolean bouncy = false;
  int index;
  float temp = 0;
  float rad_max = 10;

  Ball(float radius_, PVector pos_, PVector vel_, int index_) {
    radius = radius_;
    vel = vel_;
    pos = pos_;
    prev_pos = pos.copy().sub(vel_);
    acc = new PVector(0, .6); //gravity
    //acc = new PVector(width/2, height/2).sub(pos).normalize().mult(1);
    index = index_;
  }

  void show() {
    temp *= 90;
    fill(temp, temp - 255, temp - 512);
    circle(pos.x, pos.y, radius * .7);
    fill(temp, temp - 255, temp - 512, 180);
    circle(pos.x, pos.y, radius * 1.6);
    fill(temp, temp - 255, temp - 512, 100);
    circle(pos.x, pos.y, radius * 2.5);
    fill(temp, temp - 255, temp - 512, 60);
    circle(pos.x, pos.y, radius * 3);
    temp /= 90;
    radius = temp/6 * rad_max;
    radius = max(2, radius);
  }
  
  void update() {
    temp-=.04;
    temp = max(temp, 0);
    acc = new PVector(0, .05);
    //acc = new PVector(width/2, height/2).sub(pos).normalize().mult(.1);
    acc.add(acc.copy().normalize().mult(-(temp/8) * (temp/12) * (temp/10)));
    vel = pos.copy().sub(prev_pos);
    prev_pos = pos.copy();
    vel.add(acc);
    pos.add(vel);
  }

  void wallCollide() {
    if (pos.x < radius/2) {
      pos.x = radius/2;
      if (bouncy) {
        vel.x *= -.5;
      } else {
        vel.x *= -.1;
      }
    }
    if (pos.x > width - radius/2) {
      pos.x = width - radius/2;
      if (bouncy) {
        vel.x *= -.5;
      } else {
        vel.x *= -.1;
      }
    }
    if (pos.y < radius/2) {
      pos.y = radius/2;
      if (bouncy) {
        vel.y *= -.5;
      } else {
        vel.y *= -.1;
      }
    }
    if (pos.y > height - radius/2) {
      pos.y = height - radius/2;
      temp += map(sqrt(abs(pos.x - width/2)/(width/2)), 0, 1, .8, 0.05);
      if (bouncy) {
        vel.y *= -.5;
      } else {
        vel.y *= -.1;
      }
    }
  }

  void collide(Ball other) {
    PVector distPos = PVector.sub(other.pos, pos);
    float dist = distPos.mag();
    float minDist = radius/2 + other.radius/2;
    if (dist <= minDist) {
      float overlap = (minDist-dist)/2;
      PVector d = distPos.copy();
      float responseCoef = .7;
      //float responseCoef = map(min(sumVel * sumVel, speed * speed), 0, speed * speed, .7, .05); 
      PVector correction = d.normalize().mult(overlap * responseCoef);
      other.pos.add(correction);
      pos.sub(correction);
      if (temp > other.temp) {
        temp-= .3;
        other.temp+= .3;
      } else {
        other.temp-= .3;
        temp+= .3;
      }
    }
  }
}
