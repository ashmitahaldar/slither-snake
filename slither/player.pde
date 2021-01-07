class Player {
  PVector location;
  PVector velocity;
  PVector acc;
  float topspeed;
  float d = 50;

  ArrayList<PVector> positions = new ArrayList<PVector>();

  Player() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    topspeed = 5;
  }

  void update() {
    PVector mouse = new PVector(mouseX, mouseY);
    PVector acc = PVector.sub(mouse, location);
    positions.add(0, new PVector(location.x, location.y));

    if (PVector.dist(mouse, location) < 20) {
      location = mouse;
    } else {
      acc.setMag(0.9);
      velocity.add(acc);
      velocity.limit(topspeed);
      location.add(velocity);
    }


    if (positions.size() > 50) {
      positions.remove(50);
    }
  }

  void show() {
    fill(#39E04A);
    noStroke();
    circle(location.x, location.y, d);

    noFill();
    stroke(#39E04A);
    strokeWeight(50);

    line(location.x, location.y, positions.get(0).x, positions.get(0).y);
    for (int i = 0; i < positions.size()-1; i++) {
      PVector one = positions.get(i);
      PVector two = positions.get(i+1);
      line(one.x, one.y, two.x, two.y);
    }
  }
}
