import http.requests.*;
Stage s = new Stage(1280, 60, false, "/waterfall/processing/");

// obsolete 
//String spreadsheetId = "1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM";
String spreadsheetId = "1qa-nSAq4Y_yn_MN3-cjMIs8qxtwnUNtg-xIvtMB-gtU";
String[] key;


Loader caseLoader = new Loader ("sheet");
Loader metaLoader = new Loader ("meta");
StringDict sheetMeta;

Table caseTable;
Map map = new Map();

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
  caseTable = caseLoader.loadSheetData ("https://sheets.googleapis.com/v4/spreadsheets/"+spreadsheetId+"/values/A1:F1000?key="+key[0]);
  //caseTable = caseLoader.load("data/cases.json");
  //StringDict = caseLoader.loadMedaData (metaURL);
  map.attachMap("map.svg");
  map.attachTable(caseTable);
  s.trace ("00", str(caseTable.getRowCount()));
}
void draw () {
  // must-have
  background(0);
  s.render();
  //
  map.render(caseTable);
}
void keyPressed(KeyEvent e) {
  s.screenshot(e, "PNG");
}
