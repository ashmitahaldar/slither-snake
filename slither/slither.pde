import ddf.minim.*;

Player p;
ArrayList<Blob> blobs;
ArrayList<Enemy> enemies;
Minim minim;
AudioPlayer startsound;
AudioPlayer oversound;

int gamestate = 0;
int highscore = 0;
int level = 1;
float test = 0; //TEST = SCORE. The name 'score' isn't used because it's cursed.
float xoff, yoff;
String[] lines;
boolean bcollided = false;
boolean startSoundPlayed = false;
boolean overSoundPlayed = false;

void setup() {
  size(800, 600);
  p = new Player();
  blobs = new ArrayList<Blob>();
  enemies = new ArrayList<Enemy>();

  minim = new Minim(this);
  startsound = minim.loadFile("start.wav");
  oversound = minim.loadFile("gameover.wav");
}

void draw() {
  background(0);
  lines = loadStrings("save.txt");
  highscore = Integer.parseInt(lines[0]);

  // Intro Screen with Instructions
  if (gamestate == 0) {
    textSize(50);
    text("Slither Snake", 230, 150);
    textSize(30);
    text("Use your finger to move the snake around the screen", 15, 280);
    text("Eat food, but don't bump into the white snakes!", 50, 330);
    textSize(40);
    text("Click Space to start", 200, 500);
    test = 0;
    if (!startSoundPlayed) {
      startsound.play();
      startSoundPlayed = true;
      startsound.rewind();
    }
  }

  // Actual game
  else if (gamestate == 1) {
    startSoundPlayed = false;
    overSoundPlayed = false;

    xoff = p.location.x;
    yoff = p.location.y;
    translate((width/2)-xoff, (height/2)-yoff);
    p.update();
    p.show();

    for (int i = enemies.size()-1; i > 0; i--) {
      Enemy e = enemies.get(i);
      e.update();
      e.show();
      e.ecollided = e.checkHit(e.location.x, e.location.y, e.positions.get(e.positions.size()-1).x, e.positions.get(e.positions.size()-1).y, p.location.x, p.location.y, p.d);

      if (e.ecollided) {
        gamestate = 2;
        e.ecollided = false;
        level = 1;
      }
    }

    for (int i = blobs.size()-1; i > 0; i--) {
      Blob b = blobs.get(i);
      b.display();
      b.checkHit(p.location.x, p.location.y, p.d, b.randx, b.randy, b.d);

      if (b.bcollided) {
        int addtoscore =   (int)b.d;
        test += addtoscore;
        blobs.remove(blobs.indexOf(b));
      }
    }
    if (test > highscore) { 
      highscore = (int)test;
    }
    String[] towrite = {str(highscore)};
    saveStrings("save.txt", towrite);

    textSize(30);
    text("Score: " + (int)test, p.location.x - ((width/2) - 10), p.location.y - ((height/2)-30));
    text("Highscore: " + highscore, p.location.x-((width/2)- 10), p.location.y - ((height/2)-60));
    text("Level: " + level, p.location.x-((width/2) - 600), p.location.y - ((height/2) - 45));
  } 

  // 'You died!' Screen
  else if (gamestate == 2) {
    textSize(40);
    text("You died!", 150, 250);
    text("Score: " + test, 150, 350);
    text("Click Space to continue", 150, 400);
    if (!overSoundPlayed) {
      oversound.play();
      overSoundPlayed = true;
      oversound.rewind();
    }
  }

  if (blobs.size() == 1) {
    for (int i = 0; i < 20; i++) {
      blobs.add(new Blob());
    }
    level++;
  }
}

void keyPressed() {
  if ((key == ' ') && (gamestate == 0)) {
    gamestate = 1;
    blobs.clear();
    for (int i = 0; i < 30; i++) {
      blobs.add(new Blob());
    }
    enemies.clear();
    for (int i = 0; i < 4; i++) {
      enemies.add(new Enemy());
    }
  }

  if ((key == ' ') && (gamestate == 2)) {
    gamestate = 0;
  }
}
