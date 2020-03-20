// The source code is under MIT licencce. 
// Yonggeun Kim, vizualizer.com / vizualizer@gmail.com
// 2020 16 March 2020

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

// CAUTION
// After you download this from github repo, 
// you stil need to add google spreadsheet file, google key file, twitte key file to make things work. 

// Sketch manager
Stage s = new Stage(1280, 30, false, "/waterfall/processing/");

// SETTING MANAGE
// setting class loads settings

// it is not necessary to define all the setting in the json file. 
// Only the declared option will be prioritized than the inline setting variables. 
// e.g interval for duration for 1 single country declared as 8 sec. 
// but if json file declares 3 seconds, getFloat() method will take the cofiguation from the json file.
Settings settings;
String settingsFile = "settings.json";  // in data folder
// worldometer.info
float interval = 8.0;
// spreadsheetid of your google sheet. use importhtml function to automatically import data on the web
// this app scrapes data from worldometer.info coronavirus page as below.
// =importhtml("https://www.worldometers.info/coronavirus/#countries", "table")
String spreadsheetId = "1qa-nSAq4Y_yn_MN3-cjMIs8qxtwnUNtg-xIvtMB-gtU";
String mapurl = "map.svg"; // in data folder
String isourl = "data/iso3166-1.json"; // in data folder
int updateCycle = 5;
int now;
boolean inTraining = true;
boolean showByLongitude  = false;
String[] key;

// Load the necessay files from local or internet. 
// 0. load the spreadsheet file above from google sheet. 
Loader caseLoader;
// 1. load map.svg (local) - 
// this file contains all vertor shape of each country with unique id. 
// The IDs are same as its iso acronym.
Map map;
// 2. Timer check the current frame count then returns the the order of country out of the number of total countries 
Timer timer;
// 3. this class catches the Throwable class instances when exception occurs then send twitte dm to the given id. 
// You need to have twitter key file (no linebreak, but semicolon(;)-seperated) to enable this function
// if you don't need this simply set inTraining variable true then it will not send any DM.
Sentinel sentinel;

public void settings () {
  //smooth(4);
  size (s.width, s.height); //FX2D but this drains memory
}
void setup () {
  // REQUIREMENTS
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(s.fps);
  Ani.init (this);
  s.turnLog(true);

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
    inTraining = settings.getBoolean("inTraining", inTraining);
    showByLongitude = settings.getBoolean("showByLongitude", showByLongitude);
  }

  // Error handling
  sentinel =  new Sentinel ();
  sentinel.setMode (inTraining); // off when app is running.

  // Load google key file
  // singleline key file in data folder.
  // Check https://developers.google.com/sheets/api/guides/authorizing#APIKey
  key = loadStrings("google.key");
  if (key == null) {
    s.trace("> ", "Googke key unavailable.");
  } else {
    s.trace("> ", "Googke key obtained.");
  }

  // Data
  caseLoader = new Loader ("data");
  caseLoader.load (
    "https://sheets.googleapis.com/v4/spreadsheets/"+spreadsheetId+"/values/A1:K1000?key="+key[0], isourl);

  // Timer 
  now = 0;
  //timer = new Timer (interval, caseLoader.table.getRowCount()-1);

  // Map
  map = new Map ();
  map.updatedOn = caseLoader.updatedOn;
  map.showByLongitude = showByLongitude; 
  // if showByLongitude is false, the render sequence follows the order of total case number

  // load map and iso file then attache them to Map clss to render
  map.attachMap(mapurl, isourl);

  // attach Table to map then add few more columns to draw them on the map.
  // caseLoader.toll is an array with the sum for each column
  map.attachTable(caseLoader.table, caseLoader.toll);
}
void draw () {
  // REQUIREMENTS
  background(19);

  pushMatrix();
  //scale(map.mapScale);
  translate(map.mapPosX, map.mapPosY);
  // Render map
  map.render(now);
  popMatrix();

  //
  strokeWeight (2);
  stroke(255);
  line (0, height/2, width, height/2);

  // check timer
  // timer changes on every interval, here every 8 seconds
  //if (timer.changed ) {
  //  // every time if the app finished showing the last country on the table, 
  //  if (timer.currentCut == 0) {
  //    print("Cycle ", nf(timer.cycle, 5), " done. " + sentinel.nowInString());
  //    // Reload settings
  //    // which means that you can change settings below withiout restarting the app.
  //    settings.reload();
  //    if (settings.loaded) {
  //      interval = settings.getFloat("interval", interval);
  //      updateCycle = int (settings.getFloat("updateCycle", updateCycle));
  //      spreadsheetId = settings.getString("spreadsheetId", spreadsheetId);
  //      mapurl = settings.getString("mapurl", mapurl);
  //      isourl = settings.getString("isourl", isourl);
  //      inTraining = settings.getBoolean("inTraining", inTraining);
  //      showByLongitude = settings.getBoolean("showByLongitude", showByLongitude);
  //    }
  //    // If updateCycle is 5, the date will be reloaded every 5 cycle.  
  //    if (timer.cycle % updateCycle == 0) {
  //      print("\nDATA REFRESH\n" + sentinel.nowInString());
  //      // BEGINNING of REFREST
  //      caseLoader.refresh();
  //      map.updatedOn = caseLoader.updatedOn;
  //      map.showByLongitude = showByLongitude; 
  //      map.refresh(caseLoader.table, caseLoader.toll);
  //    }
  //  }
  //map.updateView(timer.currentCut);
  //}
  //timer.update();
  // if the line below is uncommented, Stage.trace() will display message on screen. 
  //s.render();
}
//void keyPressed(KeyEvent e) {
//  // if you want you can save sceenshot the save path is defined in Stage class file. 
//  //s.screenshot(e, "PNG");
//}
void keyPressed(KeyEvent e) {
  if (keyCode == 32) {
    s.screenshot(e, "PNG");
  }
  if (keyCode == 39) {
    now++;
    if (now > map.table.getRowCount()-1) {
      now = 0;
    }
  }
  if (keyCode == 37) {
    now--;
    if (now < 0) {
      now = map.table.getRowCount()-1;
    }
  }
  map.updateView(now);
  
}

// OPENSOURCE LICENCE
// Twitter4j - http://twitter4j.org/en/index.html
