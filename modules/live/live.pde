import http.requests.*;

String spreadsheetId = "1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM";
JSONObject meta;
JSONObject cases;

String[] key; 

String savePath = "/waterfall/processing/";
Stage s = new Stage(1024, 60, false, savePath);
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
    s.trace("00", key[0]+"key obtained.");
  }
  // get document info
  //GetRequest getMeta = new GetRequest("https://sheets.googleapis.com/v4/spreadsheets/"+spreadsheetId+"?key="+key[0]);
  //getMeta.send();
  //meta = parseJSONObject(getMeta.getContent());
  //JSONObject sheetMeta = meta.getJSONArray ("sheets").getJSONObject(0).getJSONObject ("properties");
  //println(sheetMeta.size());
  //println(sheetMeta.getString("title"));
  //
  // get the latest sheet
  //GetRequest getCases = new GetRequest("https://sheets.googleapis.com/v4/spreadsheets/"+spreadsheetId+"/values/A1:F1000?key="+key[0]);
  //getCases.send();
  //cases = parseJSONObject(getCases.getContent());


  cases = getJsonFrom("https://sheets.googleapis.com/v4/spreadsheets/"+spreadsheetId+"/values/A1:F1000?key="+key[0]);
  JSONArray _case = cases.getJSONArray ("values");
  
  s.trace ("00", str(_case.size()));
}
void draw () {
  background(0);
  s.render();
}
JSONObject getJsonFrom (String _url) {
  JSONObject _jsonObject; 
  GetRequest _get = new GetRequest (_url);
  _get.send();
  _jsonObject = parseJSONObject (_get.getContent());
  return _jsonObject;
}


// github doc for the library below 
// https://github.com/runemadsen/HTTP-Requests-for-Processing

/*
https://sheets.googleapis.com/v4/spreadsheets/1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM/values/A2:F2?key=AIzaSyASvrZTZGWJY73zXxSU98v6eAvcsFjaRBw
 
 sheetID = "1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM";
 key = "AIzaSyASvrZTZGWJY73zXxSU98v6eAvcsFjaRBw";
 
 https://sheets.googleapis.com/v4/spreadsheets/1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM?key=AIzaSyASvrZTZGWJY73zXxSU98v6eAvcsFjaRBw
 
 
 
 url to get basic info - 
 https://sheets.googleapis.com/v4/spreadsheets/1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM?key=AIzaSyASvrZTZGWJY73zXxSU98v6eAvcsFjaRBw
 API doc -> https://developers.google.com/sheets/api/reference/rest/v4/spreadsheets/get
 
 URL to read
 https://sheets.googleapis.com/v4/spreadsheets/1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM/values/A1:F1?key=AIzaSyASvrZTZGWJY73zXxSU98v6eAvcsFjaRBw
 API doc -> https://developers.google.com/sheets/api/reference/rest/v4/spreadsheets.values/get
 
 basic reading
 
 
 */
