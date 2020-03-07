import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import http.requests.*;
//import processing.core.*;
Stage s = new Stage(1280, 60, false, "/waterfall/processing/");
// worldometer.info
String spreadsheetId = "1qa-nSAq4Y_yn_MN3-cjMIs8qxtwnUNtg-xIvtMB-gtU";
String[] key;
Table caseTable;
//
Loader2 caseLoader = new Loader2 ("data");
float[] caseToll;
Map2 map = new Map2 ();
//PFont font;
public void settings () {
  smooth(4);
  size (s.width, s.height, FX2D); //FX2D
  //size (s.width, s.height); //
}
void setup () {
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(s.fps);
  // code block
  Ani.init (this);
  s.turnLog(false);
  key = loadStrings("google.key");
  if (key == null) {
    s.trace("00", "file load failed");
  } else {
    s.trace("00", "key obtained.");
  }
  // LOAD data
  caseLoader.load ("https://sheets.googleapis.com/v4/spreadsheets/"+spreadsheetId+"/values/A1:K1000?key="+key[0]);
  caseTable = caseLoader.table;
  caseToll = caseLoader.toll;
  // set timer in seconds
  caseLoader.setTimer (1); //8
  map.showByLongitude = true;
  map.attachMap("map.svg");
  map.attachTable(caseTable, caseToll);
  //s.trace ("00", str(caseTable.getRowCount()));
}
void draw () {
  // must-have
  scale(map.scale);
  translate(0, 0); // 0, -80
  background(19);
  //println(caseLoader.loaded);
  // check data
  // if (caseLoade.timer.cycle * caseLoader.timer.duration > )
  map.render(caseLoader.timer.currentCut);
  map.updateView(caseLoader.timer.currentCut);
  if (caseLoader.timer.changed ) {
    if (caseLoader.timer.currentCut == 0) {
      print("Cycle ", nf(caseLoader.timer.cycle, 5), " done. ");
      if (caseLoader.timer.cycle % 5 == 0) {
        print("\nDATA REFRESH\n");
      }
    }
    //println(caseLoader.timer.currentCut, 
    //  " / ", 
    //  caseLoader.timer.totalCuts, 
    //  ", cycle : ", 
    //  caseLoader.timer.cycle);
    // push ani.to class.
    // Reload the data every 8th cycle. 
    if (caseLoader.timer.cycle % 5 == 0 && caseLoader.timer.currentCut == 0) {
      //caseLoader.load ("https://sheets.googleapis.com/v4/spreadsheets/"+spreadsheetId+"/values/A1:K1000?key="+key[0]);
      caseLoader.refresh(caseTable, caseToll);
      //caseTable = caseLoader.table;
      //caseToll = caseLoader.toll;
      map.attachTable(caseTable, caseToll);
      map.refresh(caseTable, caseToll);
    }
    //map.updateView(caseLoader.timer.currentCut);
  }
  caseLoader.timer.update();
  s.render();
}
void keyPressed(KeyEvent e) {
  s.screenshot(e, "PNG");
}
