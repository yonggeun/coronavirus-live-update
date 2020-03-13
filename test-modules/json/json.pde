import http.requests.*;

String spreadsheetId = "1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM";
String[] key; 

JSONObject cases;
Table caseTable;

CaseLoader caseLoader = new CaseLoader ();

void setup () {
  //cases = loadJSONObject ("cases___.json");
  //JSONArray _case = cases.getJSONArray ("values");
  //caseTable = parseCase (_case);
  //println(caseTable.toString());

  key = loadStrings("google.key");
  if (key == null) {
    println ("00", "file load failed");
  } else {
    println ("00", key[0]+"key obtained.");
  }
  caseLoader.load("https://sheets.googleapis.com/v4/spreadsheets/"+spreadsheetId+"/values/A1:F1000?key="+key[0]);
  //caseLoader.load("cases.json");
}

void draw() {
}

// -- eof
