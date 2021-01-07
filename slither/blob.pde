class Blob {

  boolean bcollided = false;
  float randx = random(-200, 1000);
  float randy = random(-200, 800);
  float d = random(5, 45);
  int colornum = int(random(0, 4));
  color[] colorlist = {#FF5733, #FFEC33, #33FF57, #BF33FF};

  Blob() {
  }

  void checkHit(float cx1, float cy1, float cr1, float cx2, float cy2, float cr2) {
    if (dist(cx1, cy1, cx2, cy2) < cr1 + cr2) {
      bcollided = true;
    }
  }

  void display() {
    fill(colorlist[colornum]);
    noStroke();
    circle(randx, randy, d);
  }
}
