class Map2 { //<>// //<>//
  PShape shape;
  float scale;
  PVector pos;
  Table table;
  JSONObject isoList;
  float[] toll;
  Geometry geo;
  Boolean loaded;
  // ANIMATION
  Boolean showByLongitude = false;
  int TA; // tollbox alignment , if left then 0, if right then 1
  char displayMode; // R or L
  int currentCountryIDonMap;
  PShape local;
  //
  float cell;
  float bboxX;
  float bboxXT;
  float bboxY;
  float bboxYT;
  Ani bboxXAni;  
  Ani bboxYAni;
  // -
  float tollboxX;
  float tollboxXT;
  float tollboxY;
  float tollboxYT;
  Ani tollboxXAni;  
  Ani tollboxYAni;
  // FONT
  PFont H2;
  PFont H3;
  // COLOR
  color clr_infected;
  color clr_local;
  // global rectmode must be CORNERS
  Map2 () {
    geo = new Geometry();
    // animate the variables x and y in 1.5 sec to mouse click position
  }
  // 0. init
  void init() {
    colorMode (HSB, 360, 100, 100, 100);
    clr_infected = color (0, 100, 79.2, 50);
    //H2 = loadFont("R-CB.vlw");
    H2 = createFont("font/Roboto Condensed 700.ttf", 100);
    //H3 = loadFont("R-L.vlw"); // roboto condensed light
    //H3 = loadFont("R-C.vlw"); // roboto condensed regular
    H3 = createFont("font/Roboto Condensed regular.ttf", 100);
    cell = width/9;
    strokeJoin(ROUND);
    strokeCap(ROUND);
    //showByLongitude = false;
  }
  // 1. Attach map
  void attachMap (String L) {
    shape = loadShape (L);
    shape.disableStyle();
    scale = width / shape.width;
    //println(" / width (scaled) : ", shape.getWidth());
    pos = new PVector ((width-shape.getWidth())/2, (height - shape.getHeight())/8);
    //translate(pos.x, pos.y);
    //
    isoList = loadISOList ("data/iso3166-1.json");
  }
  // 2. Attach table
  void attachTable(Table T, float[] Toll) {
    loaded = false;
    table = T;
    //println(T.getRow(1).getColumnTitle(T.getColumnCount()-1));
    T.addColumn("x", Table.FLOAT);
    //int cls = T.getColumnCount();
    for (int i = 0; i < T.getRowCount(); i++) {
      T.setFloat(i, "x", getCountryCentFromDatarowNO(i).x);
    }
    //table = T;
    if (showByLongitude) {
      T.sort("x");
    }
    table = T;
    toll = Toll;
    loaded = true;
  }
  // 3. Render
  void render (int _now) {
    init();
    int c = 0;
    int d = 0;
    int r = 0;
    // render the world map first
    for (int i = 0; i < shape.getChildCount(); i++) {
      PShape ps = shape.getChild(i);
      String currentISO = ps.getName();
      //if (currentISO.equals(table.getRow(_now).getString("iso"))) {
      //  local = ps;
      //}
      String currentName = getNameFromISO(currentISO);
      Boolean hasCase = false;
      //get currunt shape info
      for (int k = 0; k < table.getRowCount(); k++) {
        //println(currentName," ",T.getRow(k).getString(1));
        if (table.getRow(k).getString(8).equals(currentISO)) {
          hasCase = true;
          //println(table.getRow(k).getString(8), " marked");
          c = table.getRow(k).getInt(1);
          d = table.getRow(k).getInt(3);
          r = table.getRow(k).getInt(5);
        }
      }
      if (table.getRow(_now).getString(8).equals(currentISO)) {
        currentCountryIDonMap = i;
        clr_local = color (0, 
          map(log(c)/log(2), 0, log(toll[1])/log(2), 80, 100), // Saturation
          map(log(c)/log(2), 0, log(toll[3])/log(2), 20, 80), // Brightness
          map(log(c)/log(2), 0, log(toll[5])/log(2), 80, 100) // Alpha
          );
      }
      // Disable the colors found in the SVG file
      ps.disableStyle();
      strokeWeight(0.5);
      stroke(0);
      fill(42);
      if (hasCase) {
        fill(0, // Hue 0 is red
          map(log(c)/log(2), 0, log(toll[1])/log(2), 80, 100), // Saturation
          map(log(c)/log(2), 0, log(toll[3])/log(2), 20, 80), // Brightness
          map(log(c)/log(2), 0, log(toll[5])/log(2), 80, 100) // Alpha
          );
        //fill(clr_local);
      } else {
        strokeWeight(0.5);
        stroke(0);
        fill(42);
      } 
      // Draw a single state
      shape(ps, 0, 0);
    }
    drawCurrentCountry(shape.getChild(currentCountryIDonMap), _now);
  }
  void drawCurrentCountry(PShape cc, int _now) {
    // shaping the territory
    strokeWeight (1);
    stroke (255);
    fill(0, 0, 100, 100);
    shape(cc, 0, 0);
    float left = geo.getLeft(cc);
    float right = geo.getRight(cc);
    float top = geo.getTop(cc);
    float bottom = geo.getBottom(cc);
    float w = geo.getW(cc);
    float h = geo.getH(cc);
    float wh = (w > h) ? w : h;
    PVector cent; // cent works fine
    cent = geo.getCentroid(cc);
    if (cent.x < 3.5 * cell) {
      displayMode = '>';
      // tollbox is at the RIGHT of the screen.
      TA = 1;
    } else {
      // tollbox is at the LEFT of the screen.
      displayMode = '<';
      TA = 0;
    }
    //  -------------------------  -------------------------  ------------------------- //
    // TOLLBOX - DASHBOARD         -------------------------  ------------------------- //
    //  -------------------------  -------------------------  ------------------------- //
    float recoveredSide = getRectSide (toll[6], toll[1], 2*cell);
    float deathSide = getRectSide (toll[3], toll[1], 2*cell);
    float todaySide = getRectSide (toll[2], toll[1], 2*cell);
    float labelLineThickness = 2;
    //
    pushMatrix();
    translate (tollboxX, tollboxY);
    rectMode(CORNER);
    // boundingbox color background only
    // boundingbox stroke will be rendered at the end of this function.
    noStroke();
    fill(clr_infected);
    rect(0, 0, 2*cell, 2*cell);
    // Recovered 
    // Recovered Rectangle
    //strokeWeight(2);
    //stroke(0, 0, 100, 100);
    noStroke();
    fill(0, 0, 100, 50); // 50% white
    rect(gtex(TA, 0, recoveredSide, cell*2), 0, recoveredSide, recoveredSide);
    // Recovered Line
    strokeWeight(labelLineThickness);
    stroke(0, 0, 100, 100);
    // line (tollboxX + recoveredSide, tollboxY, tollboxX + recoveredSide, tollboxY - cell/2);
    if (TA == 0) {
      line (recoveredSide, 0, recoveredSide, -cell/2);
    } else {
      line (cell*2 - recoveredSide, 0, cell*2 - recoveredSide, -cell/2);
    }
    // Recovered Info
    fill(0, 0, 100, 100);
    textFont(H2, 32);
    String rn = nfc(int(toll[6])); 
    float recoveredLabelX = 0.0;
    if (TA == 0) {
      recoveredLabelX = recoveredSide;
    } else {
      recoveredLabelX = cell*2 - recoveredSide;
    }
    // Recovered Number
    if (TA == 0) {
      textAlign (RIGHT, BOTTOM);
      text(rn, recoveredLabelX-10, -10);
    } else {
      textAlign (LEFT, BOTTOM);
      text(rn, recoveredLabelX + 10, -10);
    }
    // Recovered Label
    textFont(H2, 20);
    String labelRecovered = "Recovered";
    labelRecovered += "\n";
    labelRecovered += str(float(round(toll[6]/toll[1]*10000)/100)) +"%";
    if (TA == 0) {
      textAlign (LEFT, BOTTOM);
      text(labelRecovered, recoveredLabelX + 10, -10);
    } else {
      textAlign (RIGHT, BOTTOM);
      text(labelRecovered, recoveredLabelX - 10, -10);
    }
    // DEATH INFO
    float deathRate = float(round(toll[3]/toll[1]*10000))/100;
    // death rect
    noStroke();
    fill(0, 0, 0, 75);
    //rect(tollboxX + cell*2 - deathSide, tollboxY + cell*2 - deathSide, deathSide, deathSide);
    rect(gtex(TA, 1, deathSide, cell*2), cell*2 - deathSide, deathSide, deathSide);
    // line
    strokeWeight(labelLineThickness);
    stroke(0, 0, 100, 100);
    //line (tollboxX + cell*2 - deathSide, tollboxY + cell*2, tollboxX + cell*2 - deathSide, tollboxY + cell*2.5);
    if (TA == 0) {
      line (cell*2 - deathSide, cell*2, cell*2 - deathSide, cell*2.5);
    } else {
      line (deathSide, cell*2, deathSide, cell*2.5);
    }
    // Death label
    fill(0, 0, 100, 100);
    textFont(H2, 20);
    String labelDeaths = "Deaths";
    labelDeaths += "\n";
    labelDeaths += str(deathRate) +"%";
    if (TA == 0) { // tollbox on the left
      textAlign (LEFT, TOP);
      text(labelDeaths, cell*2 - deathSide +10, cell*2+10);
      // Death number
      textFont(H2, 32);
      textAlign (RIGHT, TOP);
      text(nfc(int(toll[3])), cell*2 - deathSide -10, cell*2+10);
    } else { // tollbox on the right
      textAlign (RIGHT, TOP);
      text(labelDeaths, deathSide - 10, cell*2+10);
      // Death number
      textFont(H2, 32);
      textAlign (LEFT, TOP);
      text(nfc(int(toll[3])), deathSide + 10, cell*2+10);
    }
    // TODAY  
    // Today new RECT
    strokeWeight(2);
    stroke(0, 0, 100, 100);
    fill(0, 0, 100, 50);
    rect (gtex (TA, 1, todaySide, cell*2), 0, todaySide, todaySide);
    // today line
    strokeWeight(labelLineThickness);
    stroke(0, 0, 100, 100);
    if (TA == 0) {
      line (cell*2, todaySide, cell*2 + cell*0.5, todaySide);
    } else {
      line (0, todaySide, cell*-0.5, todaySide);
    }
    // today header
    String headerToday = "Today";
    textFont(H2, 20);
    fill(0, 0, 100, 100);
    if (TA == 0) {
      textAlign (LEFT, BOTTOM);
      text (headerToday, cell*2 + 10, todaySide - 10);
    } else {      
      textAlign (RIGHT, BOTTOM);
      text (headerToday, -10, todaySide - 10);
    }
    // today number 
    textFont(H2, 32);
    String numberToday1 = nfc(int(toll[2])); // new cases today
    String numberToday2 = nfc(int(toll[4])); // new deaths today

    if (TA == 0) {
      textAlign (LEFT, TOP);
      text (numberToday1, cell*2 + 10, todaySide + 10);
      text (numberToday2, cell*2 + 10, todaySide + 10 + cell*0.75);
    } else {      
      textAlign (RIGHT, TOP);
      text (numberToday1, -10, todaySide + 10);
      text (numberToday2, -10, todaySide + 10 + cell*0.75);
    }
    // today label
    String labelToday1 = "New\nCases";
    String labelToday2 = "New\nDeaths";
    textFont(H3, 17);
    textLeading(15);
    fill(0, 0, 100, 100);
    if (TA == 0) {
      textAlign (LEFT, TOP);
      text (labelToday1, cell*2 + 10, todaySide + 32 + 10);
      text (labelToday2, cell*2 + 10, todaySide + cell*0.75 + 32 + 10);
    } else {      
      textAlign (RIGHT, TOP);
      text (labelToday1, -10, todaySide + 32 + 10);
      text (labelToday2, -10, todaySide + cell*0.75 + 32 + 10);
    }
    // end of today
    // TOTAL INFO IN THE MIDDLE
    // total number
    textFont(H2, 65);
    textAlign(CENTER, BOTTOM);
    text(nfc(int(toll[1])), cell, cell);
    // total label
    textAlign(CENTER, TOP);
    textFont(H3, 35);
    text("Total Cases", cell, cell);
    popMatrix();
    // wrap again
    noFill();
    stroke(0, 0, 100, 100);
    strokeWeight(4);
    rect(tollboxX, tollboxY, 2*cell, 2*cell);

    // TOLLBOX - DASHBOARD  ------------------------ FINISH ------------------------ //
    //
    //
    // ------------------------- COUNTRY INFORMATION ------------------------- 
    // SETTINGS
    rectMode (CORNER);
    //
    // COUNTRY INFORMATION  -------------------------  ------------------------- //
    // Local Name
    String countryName = table.getRow(_now).getString(0);
    float nameWidth = textWidth(countryName);
    if (nameWidth > 2*cell) {
      textFont(H3, 34);
    } else {
      textFont(H2, 34);
    }
    fill(0, 0, 100, 100);
    textAlign(CENTER, BOTTOM);
    textFont(H2, 34);
    if (wh < cell*0.75) {      
      text(table.getRow(_now).getString(0), bboxX, bboxY-(cell/2));
    } else {
      text(table.getRow(_now).getString(0), bboxX, bboxY-(h/2));
    }
    // pushMatrix in -------------
    pushMatrix();
    //
    translate(bboxX, bboxY);
    // if country is too small draw circle surrounding the territoy
    if (wh < 10) {
      //noStroke();
      strokeWeight(2);
      stroke(0, 0, 100, 60);
      noFill();
      ellipse(0, 0, 30, 30);
    }
    // TODAY
    // TODAY label
    fill(0, 0, 100, 100);
    String localLabelToday = "Today";
    textFont(H3, 24);
    if (TA == 0) {
      textAlign(LEFT, BOTTOM);
    } else {
      textAlign(RIGHT, BOTTOM);
    }
    text(localLabelToday, gf(TA, -cell*1.5+10), -cell/2); 
    // RECT
    fill(clr_local);
    noStroke();
    rect (gf(TA, -cell*1.5), -cell/2, gf(TA, cell), cell);
    // LINES
    strokeWeight(2);
    stroke(0, 0, 100, 100); // white
    //// top line
    line (gf(TA, -cell*1.5), -cell/2, gf(TA, -cell*0.5), -cell/2);
    //// bottom line
    line (gf(TA, -cell*1.5), cell/2, gf(TA, cell*0.5), cell/2);
    // NUMBERS
    ////number local cases today
    fill(0, 0, 100, 100);
    String localNumberTodayCases = nfc(table.getRow(_now).getInt(2));
    if (TA == 0) {
      textAlign(LEFT, TOP);
    } else {
      textAlign(RIGHT, TOP);
    }
    textFont(H3, 32);
    text(localNumberTodayCases, gf(TA, -cell*1.5 + 10), -cell/2+10);
    //// number local deaths today
    String localNumberTodayDeaths = nfc(table.getRow(_now).getInt(4));
    text(localNumberTodayDeaths, gf(TA, -cell*1.5 + 10), 10);
    // label local cases today
    textFont(H2, 17);
    text("New Cases", gf(TA, -cell*1.5 + 10), -cell/2 + 42);
    // label local deaths today
    text("New Deaths", gf(TA, -cell*1.5 + 10), 42);
    //
    if (TA == 0) {
      textAlign(LEFT, BOTTOM);
    } else {
      textAlign(RIGHT, BOTTOM);
    }
    //// number local total cases
    textFont(H2, 32);
    String localNumberTotalCases = nfc(table.getRow(_now).getInt(1));
    text(localNumberTotalCases, gf(TA, -cell*1.5+10), cell*0.75 + 10);
    //// number local total deaths
    textFont(H2, 25);
    String localNumberTotalDeaths = nfc(table.getRow(_now).getInt(3));
    text(localNumberTotalDeaths, gf(TA, -cell*0.5), cell*0.75 + 10);
    if (TA == 0) {
      textAlign(RIGHT, BOTTOM);
    } else {
      textAlign(LEFT, BOTTOM);
    }
    //// number local death rate
    fill(0, 100, 100, 100);
    // labelRecovered += str(float(round(toll[6]/toll[1]*10000)/100)) +"%";
    String localNumberDeathRate = str(float(round(table.getRow(_now).getFloat(3) / table.getRow(_now).getFloat(1) * 10000)/100)) + "%";
    text(localNumberDeathRate, gf(TA, cell*0.5), cell*0.75 + 10);
    // LABELS
    textFont(H3, 17);
    if (TA == 0) {
      textAlign(LEFT, BOTTOM);
    } else {
      textAlign(RIGHT, BOTTOM);
    }
    fill(0, 0, 100, 100);
    //// label local total cases
    text("Total Cases", gf(TA, -cell*1.5 + 10), cell-10);
    //// label local total deaths
    text("Total Deaths", gf(TA, -cell*0.5), cell-10);
    //// label local total rate
    if (TA == 0) {
      textAlign(RIGHT, BOTTOM);
    } else {
      textAlign(LEFT, BOTTOM);
    }
    fill(0, 100, 100, 100);
    text("Rate", gf(TA, cell*0.5), cell-10);

    popMatrix();
    // popMatrix out -------------

    // CONNECTING LINE BETWEEN TOLLBOX AND LOCAL BOUNDINGBOX
    strokeWeight(2);
    if (TA == 0) { 
      line (tollboxX + cell*2.5, tollboxY + todaySide, bboxX - cell*1.5, bboxY - cell/2);
    } else {
      line (tollboxX - cell*0.5, tollboxY + todaySide, bboxX + cell*1.5, bboxY - cell/2);
    }
  }
  void updateView(int _cut) {
    //println("udate the map with current country");
    //list of any.to
    //Ani(Object Target, float Duration, String FieldName, float End)
    bboxXAni = Ani.to (this, 2, "bboxX", getCountryCentFromDatarowNO(_cut).x);
    bboxYAni = Ani.to (this, 1, "bboxY", getCountryCentFromDatarowNO(_cut).y);
    if (displayMode == '<') {
      tollboxXT = 20;
      tollboxYT = height/2-cell;
    } else {
      tollboxXT = width/2 + (2.5*cell) - 20;
      tollboxYT = height/2-cell;
    }
    tollboxXAni = Ani.to (this, 0.5, "tollboxX", tollboxXT);
    tollboxYAni = Ani.to (this, 0.5, "tollboxY", tollboxYT);
    //bboxYAni = Ani.to (this, 0.5, "bboxY", bboxYT);
  }
  // end of 3. Render
  PVector getCountryCentFromDatarowNO (int _rowNo) {
    PVector pos = new PVector ();
    String iso = table.getRow(_rowNo).getString("iso");
    //println("iso ", iso);
    for (int m = 0; m < shape.getChildCount(); m++) {
      if (iso.equals(shape.getChild(m).getName())) {
        pos = geo.getCentroid(shape.getChild(m));
      }
    }
    return pos;
  }

  float getCountryPosXminFromDatarowNO (int _rowNo) {
    float X = 0.0;
    String iso = table.getRow(_rowNo).getString("iso");
    //println("iso ", iso);
    for (int m = 0; m < shape.getChildCount(); m++) {
      if (iso.equals(shape.getChild(m).getName())) {
        X = geo.getXmin(shape.getChild(m));
      }
    }
    return X;
  }
  JSONObject loadISOList (String url) {
    JSONObject _job;
    _job = loadJSONObject (url);
    return _job;
  }
  String getISOFromName (JSONObject list, String name) {
    String code;
    String m = list.toString();
    String q = "([A-Z]{2})\\W+\""+name;
    String[] r = match(m, q);
    if (r == null) {
      code = "";
    } else {
      code = r[1];
    }
    //code = isoList.getString(name);
    return code;
  }
  String getNameFromISO (String isocode) {
    String name;
    name = isoList.getString(isocode);
    return name;
  }
  float getRectSide (float item, float sum, float side) {
    //float recoveredSide = getRectSide (toll[6], toll[1], 2*cell);
    float r;
    r = sqrt (pow(side, 2) / sum*item);
    return r;
  }
  float gtex(int BA, int EA, float w, float s) {
    // BA body alighment,
    // EA element alightment
    // w widht
    // s the length of side
    float X = 0.0;
    if (BA == 0 && EA == 0) {
      X = 0;
    } else if (BA == 1 && EA == 0) {
      X = s - w;
    } else if (BA == 0 && EA == 1) {
      X = s - w;
    } else if (BA == 1 && EA == 0) {
      X = 0;
    } else {
    }
    return X;
  }
  float gf (int BA, float x) { // get flipped 
    // get 
    float X = x;
    if (BA == 0) {
      X = x;
    } else if (BA == 1) {
      X = -1*x;
    }
    return X;
  }
}
