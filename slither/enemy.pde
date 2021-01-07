class Enemy {
  PVector location;
  PVector velocity;
  PVector acc;
  float topspeed;
  PVector mouse;
  float d = 35;
  boolean ecollided = false;

  ArrayList<PVector> positions = new ArrayList<PVector>();

  Enemy() {
    location = new PVector(random(50, 800), random(50, 600));
    velocity = new PVector(0, 0);
    topspeed = 4;
    mouse = new PVector(random(-200, 1000), random(-200, 800));
  }

  void update() {

    if (frameCount % 30 == 0) {
      mouse = new PVector(random(-200, 1000), random(-200, 800));
    }
    PVector acc = PVector.sub(mouse, location);
    positions.add(0, new PVector(location.x, location.y));

    acc.setMag(0.7);
    velocity.add(acc);
    velocity.limit(topspeed);
    location.add(velocity);


    if (positions.size() > 50) {
      positions.remove(50);
    }
  }

  void show() {
    fill(255);
    noStroke();
    circle(location.x, location.y, d);

    noFill();
    stroke(255);
    strokeWeight(35);

    line(location.x, location.y, positions.get(0).x, positions.get(0).y);
    for (int i = 0; i < positions.size()-1; i++) {
      PVector one = positions.get(i);
      PVector two = positions.get(i+1);
      line(one.x, one.y, two.x, two.y);
    }
  }







  // COLLISION CODES

  boolean pointCircle(float px, float py, float cx, float cy, float cr) {
    if (dist(px, py, cx, cy) < cr) {
      return true;
    } else {
      return false;
    }
  }

  boolean linePoint(float x1, float y1, float x2, float y2, float px, float py) {

    // get distance from the point to the two ends of the line
    float d1 = dist(px, py, x1, y1);
    float d2 = dist(px, py, x2, y2);

    // get the length of the line
    float lineLen = dist(x1, y1, x2, y2);

    // since floats are so minutely accurate, add
    // a little buffer zone that will give collision
    float buffer = 0.1;    // higher # = less accurate

    // if the two distances are equal to the line's 
    // length, the point is on the line!
    // note we use the buffer here to give a range, 
    // rather than one #
    if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
      return true;
    }
    return false;
  }

  boolean checkHit(float x1, float y1, float x2, float y2, float cx, float cy, float r) {

    // is either end INSIDE the circle?
    // if so, return true immediately
    boolean inside1 = pointCircle(x1, y1, cx, cy, r);
    boolean inside2 = pointCircle(x2, y2, cx, cy, r);
    if (inside1 || inside2) return true;

    // get length of the line
    float distX = x1 - x2;
    float distY = y1 - y2;
    float len = sqrt( (distX*distX) + (distY*distY) );

    // get dot product of the line and circle
    float dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / pow(len, 2);

    // find the closest point on the line
    float closestX = x1 + (dot * (x2-x1));
    float closestY = y1 + (dot * (y2-y1));

    // is this point actually on the line segment?
    // if so keep going, but if not, return false
    boolean onSegment = linePoint(x1, y1, x2, y2, closestX, closestY);
    if (!onSegment) return false;

    // optionally, draw a circle at the closest
    // point on the line
    //fill(255,0,0);
    //noStroke();
    //ellipse(closestX, closestY, 20, 20);

    // get distance to closest point
    distX = closestX - cx;
    distY = closestY - cy;
    float distance = sqrt( (distX*distX) + (distY*distY) );

    if (distance <= r) {
      return true;
    }
    return false;
  }
}
