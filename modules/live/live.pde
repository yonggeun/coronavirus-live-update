import http.requests.*;
Stage s = new Stage(1280, 60, false, "/waterfall/processing/");

String spreadsheetId = "1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM";
String[] key;


Loader caseLoader = new Loader ();

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
  s.turnLog(true);
  smooth();
  // code block
  key = loadStrings("google.key");
  if (key == null) {
    s.trace("00", "file load failed");
  } else {
    s.trace("00", "key obtained.");
  }
  caseTable = caseLoader.load("https://sheets.googleapis.com/v4/spreadsheets/"+spreadsheetId+"/values/A1:F1000?key="+key[0]);
  //caseTable = caseLoader.load("data/cases.json");
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
