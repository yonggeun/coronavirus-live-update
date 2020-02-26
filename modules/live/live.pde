import http.requests.*;
Stage s = new Stage(1280, 60, false, "/waterfall/processing/");

// obsolete 
//String spreadsheetId = "1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM";
//String spreadsheetId = "1qa-nSAq4Y_yn_MN3-cjMIs8qxtwnUNtg-xIvtMB-gtU";
// worldometer.info
String spreadsheetId = "1qa-nSAq4Y_yn_MN3-cjMIs8qxtwnUNtg-xIvtMB-gtU";
//testing url
//https://sheets.googleapis.com/v4/spreadsheets/1qa-nSAq4Y_yn_MN3-cjMIs8qxtwnUNtg-xIvtMB-gtU/values/A1:H1000?key=AIzaSyASvrZTZGWJY73zXxSU98v6eAvcsFjaRBw

String[] key;
Loader2 caseLoader = new Loader2 ("sheet");

StringDict sheetMeta;

Table caseTable;
Map2 map = new Map2 ();

//PFont font;
public void settings () {
  //size (s.width, s.height);
  size (s.width, s.height, P3D);
}
void setup () {
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(s.fps);
  s.turnLog(false);
  smooth();
  // code block
  key = loadStrings("google.key");
  if (key == null) {
    s.trace("00", "file load failed");
  } else {
    s.trace("00", "key obtained.");
  }
  caseTable = caseLoader.loadSheetData ("https://sheets.googleapis.com/v4/spreadsheets/"+spreadsheetId+"/values/A1:K1000?key="+key[0]);
  caseLoader.setTimer ("0:30", 60);
  caseLoader.timer.repetition = true;
  //caseTable = caseLoader.load("data/cases.json");
  //StringDict = caseLoader.loadMedaData (metaURL);
  map.attachMap("map.svg");
  //translate(map.pos.x, map.pos.y);
  map.attachTable(caseTable);
  //s.trace ("00", str(caseTable.getRowCount()));
}
void draw () {
  // must-have
  scale(map.scale);
  //translate((width - map.shape.getWidth())/2, 0);
  //pushMatrix();
  translate(0, -80);
  background(19);
  //
  caseLoader.timer.update();
  if (caseLoader.timer.changed ) {
    //updateInfo(caseLoader.timer.currentCut);
    print("cut - " , caseLoader.timer.totalCuts);
    println(" -> " , caseLoader.timer.currentCut);
  }
  s.render();
  //popMatrix();
  //
  map.render(caseTable, caseLoader.timer.currentCut);
}
void keyPressed(KeyEvent e) {
  s.screenshot(e, "PNG");
}
