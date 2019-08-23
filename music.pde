import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
FFT fftLin;

String [] path = {"Han_Christmas.mp3", "Han_Electric.mp3", "Han_Elegant.mp3", "Han_Epic.mp3", "Han_FairyTale.mp3",
                   "Han_Family.mp3", "Han_Joyous.mp3", "Han_Laurier.mp3", "Han_Mysterious.mp3", "Han_Playful.mp3"};
float centerFrequency = 0;

// 左聲道、右聲道、頻率、音量、bmp、功率
void setup() {

  size(1000,700, P3D);
  
  smooth();
  lights();

  minim = new
  Minim(this);
  
  // 像讀圖的方法一样 在目錄下的data文件夹里讀取文件，也可以讀取绝对地址的文件
  player = minim.loadFile(path[int(random(10))]);
  fftLin = new FFT( player.bufferSize(), player.sampleRate() );
  fftLin.linAverages( 30 );

  player.play();
}

void draw() {

  background(0);
  
  fftLin.forward(player.mix);
  
   for(int i = 0; i < fftLin.specSize(); i++) {
        centerFrequency = fftLin.indexToFreq(i);
        stroke( 0, random(255), random(int(map(centerFrequency, 500, 25000, 0, 255))));
    }

  // 由 left.get() 和 right.get() 返回的值將是 -1 和 1 之间，所以需要映射到合適的大小
  
   strokeWeight(2);
   pushMatrix();
   translate(70, height * 0.5, -100);
   noFill();
   sphereDetail(int(constrain(player.mix.level() * 60, 0, 20)));
   rotateX(mouseY * 0.05);
   rotateY(mouseX * 0.05);
   sphere(100);
   popMatrix();
   
   pushMatrix();
   translate(930, height * 0.5, -100);
   noFill();
   sphereDetail(int(constrain(player.mix.level() * 60, 0, 20)));
   rotateX(mouseY * 0.05);
   rotateY(mouseX * 0.05);
   sphere(100);
   popMatrix();
   
   // println(player.getBalance());
     
  for(int i=0;i<player.bufferSize()-1;i++) {
        
    float x1 = map( i, 0, player.bufferSize(), 0, width );
    float x2 = map( i+1, 0, player.bufferSize(), 0, width);

    stroke(random(255), 0, 0);
    line( x1, 100+player.left.get(i)*50, player.left.level() * width, x2, player.left.get(i+1)*50, -1*player.left.level() * width);
    stroke(0, random(255), 0);
    line( x1, height+player.right.get(i)*50, -1*player.right.level() * width, x2, (height-100)+player.right.get(i+1)*50, player.right.level() * width);
  }
  
  float a = 0;
  float angle = (2*PI) / 200;
  int step = player.bufferSize() / 200;
  
  for(int i=0; i < player.bufferSize() - step; i+=step) {
    
    stroke(random(255), random(255), random(255), random(150, 255));
    strokeWeight(random(15));
    
    float x = width / 2 + cos(a) * (1000 * player.mix.get(i) + 150);
    float y = height / 2 + sin(a) * (1000 * player.mix.get(i) + 150);
    float x2 = width / 2 + cos(a + angle) * (1000 * player.mix.get(i+step) + 150);
    float y2 = height / 2 + sin(a + angle) * (1000 * player.mix.get(i+step) + 150);
    
    line(x, y, x2, y2);
    
    a += angle;
  }

  // 画一条线以显示歌曲当前播放的位置
  // float posx = map(player.position(), 0, player.length(), 0, width);

  // stroke(0,random(255),0);

  // line(posx, 0, posx, height);

  // if(player.isPlaying()){

     // text("Press any to pause playback.", 10, 20);
  // }
  // else{

    // text("Press any key to start playback.", 10, 20);
  // }
  
 if(player.position() >= player.length() - 200) {
    
    player = minim.loadFile(path[int(random(10))]);
    player.play(); 
  }
}

// player.position() == player.length()
void keyPressed(){
  
  // 如果播放到文件末尾，我们使他再播一遍
  if(key == 'r') {
    
    player.pause();
    player = minim.loadFile(path[int(random(10))]);
    player.play();
  } 
  else if(player.isPlaying()) {

    player.pause();
  }
  else {

    player.play();
  }
}
