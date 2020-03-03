import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import http.requests.*;

Stage s = new Stage(1280, 60, false, "/waterfall/processing/");

// worldometer.info
String spreadsheetId = "1qa-nSAq4Y_yn_MN3-cjMIs8qxtwnUNtg-xIvtMB-gtU";
String[] key;
Table caseTable;
//
Loader2 caseLoader = new Loader2 ("data");
int[] caseToll;
Map2 map = new Map2 ();
//PFont font;
//StringDict sheetMeta;
public void settings () {
  size (s.width, s.height, P3D);
}
void setup () {
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(s.fps);
  smooth();
  // code block
  Ani.init (this);
  s.turnLog(false);
  key = loadStrings("google.key");
  if (key == null) {
    s.trace("00", "file load failed");
  } else {
    s.trace("00", "key obtained.");
  }
  caseLoader.load ("https://sheets.googleapis.com/v4/spreadsheets/"+spreadsheetId+"/values/A1:K1000?key="+key[0]);
  caseTable = caseLoader.table;
  caseToll = caseLoader.toll;
  caseLoader.setTimer ("0:30");
  //caseTable = caseLoader.load("data/cases.json");
  //StringDict = caseLoader.loadMedaData (metaURL);
  map.attachMap("map.svg");
  //translate(map.pos.x, map.pos.y);
  println("caseToll : ", caseLoader.toll);
  map.attachTable(caseTable, caseToll);
  //s.trace ("00", str(caseTable.getRowCount()));
}
void draw () {
  // must-have
  scale(map.scale);
  translate(0, -80);
  background(19);
  // check data
  // if (caseLoade.timer.cycle * caseLoader.timer.duration > )
  if (caseLoader.timer.changed ) {
    //updateInfo(caseLoader.timer.currentCut);
    print("cut - ", caseLoader.timer.totalCuts);
    println(" -> ", caseLoader.timer.currentCut);
    // push ani.to class.
    map.updateView(caseLoader.timer.currentCut);
  }
  map.render(caseLoader.timer.currentCut);
  caseLoader.timer.update();
  s.render();
  //
}
void keyPressed(KeyEvent e) {
  s.screenshot(e, "PNG");
}
