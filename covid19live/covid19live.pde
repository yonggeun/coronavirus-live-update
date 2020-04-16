import twitter4j.*;
import twitter4j.util.*;
import twitter4j.util.function.*;
import twitter4j.auth.*;
import twitter4j.management.*;
import twitter4j.json.*;
import twitter4j.api.*;
import twitter4j.conf.*;
import java.util.*;
//
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import http.requests.*;
//
//Sketch manager
Stage s = new Stage(1280, 60, false, "/waterfall/processing/");
// SETTING MANAGE
Settings settings;
String settingsFile = "settings.json";
// worldometer.info
float interval = 8.0;
String spreadsheetId = "1qa-nSAq4Y_yn_MN3-cjMIs8qxtwnUNtg-xIvtMB-gtU";
String mapurl = "map.svg";
String isourl = "data/iso3166-1.json";
int updateCycle = 5;
String inTraining = "true";
String showByLongitude  = "false";
String[] key;
//
Loader caseLoader;
Map map;
Timer timer;
Sentinel sentinel;

public void settings () {
  smooth(4);
  size (s.width, s.height); //FX2D but this drains memory
}
void setup () {
  // REQUIREMENTS
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(s.fps);
  Ani.init (this);
  s.turnLog(false);

  // SETTING MANAGER
  // Load settings from json file.
  // if the loader fails to load the values within this file will be used
  settings = new Settings (settingsFile);
  if (settings.loaded) {
    interval = settings.getFloat("interval", interval);
    updateCycle = int (settings.getFloat("updateCycle", updateCycle));
    spreadsheetId = settings.getString("spreadsheetId", spreadsheetId);
    mapurl = settings.getString("mapurl", mapurl);
    isourl = settings.getString("isourl", isourl);
    inTraining = settings.getString("inTraining", inTraining);
    showByLongitude = settings.getString("showByLongitude", showByLongitude);
  }

  // Error handling
  sentinel =  new Sentinel ();
  sentinel.setMode (boolean(inTraining)); // off when app is running.

  // Load google key file
  key = loadStrings("google.key");
  if (key == null) {
    s.trace("> ", "Googke key unavailable.");
  } else {
    s.trace("> ", "Googke key obtained.");
  }

  // Data
  caseLoader = new Loader ("data");
  caseLoader.load (
    "https://sheets.googleapis.com/v4/spreadsheets/"+spreadsheetId+"/values/A1:K1000?key="+key[0], 
    isourl);
  //caseLoader.sentinel = sentinel;

  // Timer 
  timer = new Timer (interval, caseLoader.table.getRowCount()-1);

  // Map
  map = new Map ();
  map.updatedOn = caseLoader.updatedOn;
  map.showByLongitude = boolean(showByLongitude); // if false, the render sequence follows the order of total case number
  map.attachMap(mapurl, isourl);
  map.attachTable(caseLoader.table, caseLoader.toll);
}
void draw () {
  clear();
  // REQUIREMENTS
  // scale(map.scale);
  // translate(0, 0); // 0, -80
  background(19);

  // Render map
  map.render(timer.currentCut);

  // check timer
  if (timer.changed ) {
    if (timer.currentCut == 0) {
      print("Cycle ", nf(timer.cycle, 5), " done. " + sentinel.nowInString());
      settings.reload();
      if (settings.loaded) {
        interval = settings.getFloat("interval", interval);
        updateCycle = int (settings.getFloat("updateCycle", updateCycle));
        spreadsheetId = settings.getString("spreadsheetId", spreadsheetId);
        mapurl = settings.getString("mapurl", mapurl);
        isourl = settings.getString("isourl", isourl);
        inTraining = settings.getString("inTraining", inTraining);
        showByLongitude = settings.getString("showByLongitude", showByLongitude);
      }
      if (timer.cycle % updateCycle == 0) {
        print("\nDATA REFRESH\n" + sentinel.nowInString());
        // BEGINNING of REFREST
        caseLoader.refresh();
        map.updatedOn = caseLoader.updatedOn;
        map.showByLongitude = boolean(showByLongitude); 
        map.refresh(caseLoader.table, caseLoader.toll);
      }
    }
    map.updateView(timer.currentCut);
    //println(timer.currentCut, 
    //  " / ", 
    //  timer.totalCuts, 
    //  ", cycle : ", 
    //  timer.cycle);
    // push ani.to class.
    // Reload the data every 8th cycle.
  }
  timer.update();
  //s.render();
}
void keyPressed(KeyEvent e) {
  s.screenshot(e, "PNG");
}
