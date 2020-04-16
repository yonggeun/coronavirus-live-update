class Map { //<>//
  String url; // the location of the map
  PShape shape;
  float scale;
  PVector pos;
  Table table;
  processing.data.JSONObject isoList;
  //float[] toll;
  FloatDict toll;
  Geometry geo;
  Boolean loaded;
  String isourl;
  int updatedOn;
  // ANIMATION
  Boolean missing;
  Boolean showByLongitude = false;
  int TA; // tollbox alignment , if left then 0, if right then 1
  char displayMode; // R or L
  Boolean isoMissing = false; 
  int currentCountryIDonMap;
  PShape local;
  //
  float cell;
  float padding;
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
  PFont H1;
  PFont H2;
  PFont H3;
  // COLOR
  color clr_infected;
  color clr_local;

  // global rectmode must be CORNERS
  Map () {
    geo = new Geometry();
    // animate the variables x and y in 1.5 sec to mouse click position
    H1 = createFont("font/Roboto Slab 700.ttf", 30);
    H2 = createFont("font/Roboto Condensed 700.ttf", 100);
    H3 = createFont("font/Roboto Condensed regular.ttf", 100);
    // variable for grid system
    cell = width/9;
    padding = cell/20;
  }
  // 0. init
  void init() {
    colorMode (HSB, 360, 100, 100, 100);
    clr_infected = color (0, 100, 79.2, 50);

    ////H2 = loadFont("font/R-CB.vlw");
    ////H2 = createFont("font/Roboto Condensed 700.ttf", 100);
    ////H3 = loadFont("font/R-L.vlw"); // roboto condensed light
    ////H3 = loadFont("font/R-C.vlw"); // roboto condensed regular
    strokeJoin(ROUND);
    strokeCap(ROUND);
    //showByLongitude = false;
  }
  void refresh(Table T, FloatDict array) {
    attachMap (url, isourl);
    attachTable (T, array);
  }
  // 1. Attach map
  void attachMap (String L, String L2) {
    url = L;
    isourl = L2;
    shape = loadShape (url);
    shape.disableStyle();
    scale = width / shape.width;
    //println(" / width (scaled) : ", shape.getWidth());
    pos = new PVector ((width-shape.getWidth())/2, (height - shape.getHeight())/8);
    isoList = loadISOList (isourl);
  }
  // 2. Attach table
  void attachTable(Table T, FloatDict Toll) {
    loaded = false;
    table = T;
    //println(T.getRow(1).getColumnTitle(T.getColumnCount()-1));
    T.addColumn("d", Table.FLOAT);
    //int cls = T.getColumnCount();
    for (int i = 0; i < T.getRowCount(); i++) {
      if (T.getRow(i).getString("iso").equals("**")) {
        // if the iso value is missing set the x out side of this sketch first
        T.setFloat(i, "d", float(nf(int(width), 4)+nf(int(height), 4)));
      } else {
        T.setFloat(i, "d", getCountryDistanceFromDatarowNO(i));
      }
    }
    //table = T;
    if (showByLongitude) {
      T.sort("d");
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
      String shapeISO = ps.getName();
      //String currentName = getNameFromISO(shapeISO);
      Boolean hasCase = false;
      //get currunt shape info
      for (int k = 0; k < table.getRowCount(); k++) {
        if (table.getRow(k).getString("iso").equals(shapeISO)) {
          hasCase = true;
          //println(table.getRow(k).getString(8), " marked");
          c = table.getRow(k).getInt("Total Cases");
          d = table.getRow(k).getInt("Total Deaths");
          r = table.getRow(k).getInt("Total Recovered");
        }
      }
      if (table.getRow(_now).getString("iso").equals(shapeISO)) {
        currentCountryIDonMap = i;
        clr_local = color (0, 
          //map(log(c)/log(2), 0, log(toll[1])/log(2), 80, 100), // Saturation
          //map(log(c)/log(2), 0, log(toll[3])/log(2), 20, 80), // Brightness
          //map(log(c)/log(2), 0, log(toll[5])/log(2), 80, 100) // Alpha
          map(log(c)/log(2), 0, log(toll.get("Total Cases"))/log(2), 80, 100), // Saturation
          map(log(c)/log(2), 0, log(toll.get("Total Deaths"))/log(2), 20, 80), // Brightness
          map(log(c)/log(2), 0, log(toll.get("Total Recovered"))/log(2), 80, 100) // Alpha
          );
      }
      // Disable the colors found in the SVG file
      ps.disableStyle();
      strokeWeight(0.5);
      stroke(0);
      fill(42);
      if (hasCase) {
        fill(0, // Hue 0 is red
          map(log(c)/log(2), 0, log(toll.get("Total Cases"))/log(2), 80, 100), // Saturation
          map(log(c)/log(2), 0, log(toll.get("Total Deaths"))/log(2), 20, 80), // Brightness
          map(log(c)/log(2), 0, log(toll.get("Total Recovered"))/log(2), 80, 100) // Alpha
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
    if (table.getRow(_now).getString("iso").equals("**")) {
      rectMode(CORNER);
      fill(0, 0, 0, 80);
      noStroke();
      rect(0, 0, width, height);
      PShape slate;
      slate = createShape();
      slate.beginShape();
      slate.fill(0, 0, 0, 0);
      slate.noStroke();
      slate.vertex(bboxX, bboxY);
      slate.vertex(bboxY + cell, bboxY);
      slate.vertex(bboxX + cell, bboxY+ cell);
      slate.vertex(bboxX, bboxY+ cell);
      slate.endShape();
      slate.setVisible(false);
      drawCurrentCountry(slate, _now);
      isoMissing = true;
    } else {
      isoMissing = false;
      drawCurrentCountry(shape.getChild(currentCountryIDonMap), _now);
    }
    drawOthers();
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
      // tollbox is at the RIGHT of the screen.
      displayMode = '>';
      TA = 1;
    } else {
      // tollbox is at the LEFT of the screen.
      displayMode = '<';
      TA = 0;
    }
    //  -------------------------  -------------------------  ------------------------- //
    // TOLLBOX - DASHBOARD         -------------------------  ------------------------- //
    //  -------------------------  -------------------------  ------------------------- //
    float recoveredSide = getRectSide (toll.get("Total Recovered"), toll.get("Total Cases"), 2*cell);
    float deathSide = getRectSide (toll.get("Total Deaths"), toll.get("Total Cases"), 2*cell);
    float todaySide = getRectSide (toll.get("New Cases"), toll.get("Total Cases"), 2*cell);
    float labelLineThickness = 2;
    //
    pushMatrix();
    translate (tollboxX, tollboxY);
    rectMode(CORNER);
    // boundingbox color background only
    // boundingbox stroke will be rendered at the end of this function.
    noStroke();
    fill(0, 100, 78, 33);
    rect(0, 0, 2*cell, 2*cell);
    // Recovered 
    // Recovered Rectangle
    //strokeWeight(2);
    //stroke(0, 0, 100, 100);
    noStroke();
    fill(0, 0, 100, 20); // 50% white
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
    String rn = nfc(int(toll.get("Total Recovered"))); 
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
    textFont(H3, 20);
    String labelRecovered = "Recovered";
    labelRecovered += "\n";
    labelRecovered += str(float(round(toll.get("Total Recovered")/toll.get("Total Cases")*10000)/100)) +"%";
    if (TA == 0) {
      textAlign (LEFT, BOTTOM);
      text(labelRecovered, recoveredLabelX + 10, -10);
    } else {
      textAlign (RIGHT, BOTTOM);
      text(labelRecovered, recoveredLabelX - 10, -10);
    }
    // DEATH INFO
    float deathRate = float(round(toll.get("Total Deaths")/toll.get("Total Cases")*10000))/100;
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
    textFont(H3, 20);
    String labelDeaths = "Deaths";
    labelDeaths += "\n";
    labelDeaths += str(deathRate) +"%";
    if (TA == 0) { // tollbox on the left
      textAlign (LEFT, TOP);
      text(labelDeaths, cell*2 - deathSide +10, cell*2+10);
      // Death number
      textFont(H2, 32);
      textAlign (RIGHT, TOP);
      text(nfc(int(toll.get("Total Deaths"))), cell*2 - deathSide -10, cell*2+10);
    } else { // tollbox on the right
      textAlign (RIGHT, TOP);
      text(labelDeaths, deathSide - 10, cell*2+10);
      // Death number
      textFont(H2, 32);
      textAlign (LEFT, TOP);
      text(nfc(int(toll.get("Total Deaths"))), deathSide + 10, cell*2+10);
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
    int lastUpdate;
    lastUpdate = (hour() - 8 > 0) ? hour() - 8 : 24 + hour() - 8;
    String headerToday = "Last\n"+ lastUpdate +" hours";
    textFont(H3, 18);
    textLeading(20);
    fill(0, 0, 100, 100);
    if (TA == 0) {
      textAlign (RIGHT, BOTTOM);
      text (headerToday, cell*2.5 - padding/2, todaySide - padding/2);
    } else {      
      textAlign (LEFT, BOTTOM);
      text (headerToday, -cell/2 + padding/2, todaySide - padding/2);
    }
    // today number 
    textFont(H2, 32);
    String numberToday1 = nfc(int(toll.get("New Cases"))); // new cases today
    String numberToday2 = nfc(int(toll.get("New Deaths"))); // new deaths today

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
    float totalNumberTextSize = 60;
    textFont(H2, totalNumberTextSize);
    float totalNumberWidth = textWidth(nfc(int(toll.get("Total Cases"))));
    if (totalNumberWidth > cell*2*0.9) {
      float size = totalNumberTextSize;
      while (textWidth(nfc(int(toll.get("Total Cases")))) > cell*2*0.9) {
        size--;
        textFont(H2, size);
      }
      textFont(H2, size);
    } else {
      float size = totalNumberTextSize;
      while (textWidth(nfc(int(toll.get("Total Cases")))) < cell*2*0.9) {
        size++;
        textFont(H2, size);
      }
      textFont(H2, size);
    }
    textAlign(CENTER, BOTTOM);
    text(nfc(int(toll.get("Total Cases"))), cell, cell*1.25);
    // total label
    textAlign(CENTER, TOP);
    textFont(H3, 35);
    text("Total Cases", cell, cell*1.2);
    popMatrix();
    // wrap again
    noFill();
    stroke(0, 0, 100, 100);
    strokeWeight(4);
    rect(tollboxX, tollboxY, 2*cell, 2*cell);
    //
    // TOLLBOX - DASHBOARD  ------------------------ FINISH ------------------------ //

    // BBOX ------------------ COUNTRY INFORMATION ------------------------- 
    // SETTINGS
    rectMode (CORNER);
    // COUNTRY INFORMATION  -------------------------  ------------------------- //
    // Local Name
    String countryName = table.getRow(_now).getString(0);
    //println(countryName);
    float nameWidth = textWidth(countryName);
    fill(0, 0, 100, 100);
    textAlign(CENTER, BOTTOM);
    if (nameWidth > 1.75*cell) {
      textFont(H2, 28);
      textLeading(26);
      countryName = getDoublelineString (table.getRow(_now).getString(0));
    } else {
      textFont(H2, 34);
    }
    if (wh < cell*0.75) {      
      text(countryName, bboxX, bboxY-(cell/2));
    } else {
      text(countryName, bboxX, bboxY-(h/2));
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
    String localLabelToday = "Last "+ lastUpdate +" hrs.";
    //String headerToday = "Last\n"+ lastUpdate +" hrs";
    textFont(H3, 18);
    if (TA == 0) {
      textAlign(LEFT, BOTTOM);
    } else {
      textAlign(RIGHT, BOTTOM);
    }
    text(localLabelToday, gf(TA, -cell*1.5-padding*6), -cell/2-padding/2); 
    // RECT
    fill(clr_local);
    //fill(hue(clr_local), 
    //  map(saturation(clr_local), 0, 255, 0, 100), 
    //  map(brightness(clr_local), 0, 255, 0, 100), 
    //  map(alpha(clr_local), 0, 255, 0, 50)
    //  );
    noStroke();
    rect (gf(TA, -cell*1.5), -cell/2, gf(TA, cell), cell);
    // LINES
    strokeWeight(2);
    stroke(0, 0, 100, 100); // white
    //// top line
    line (gf(TA, -cell*1.5), -cell/2, gf(TA, -cell*0.5), -cell/2);
    //// bottom line
    line (gf(TA, -cell*1.5), cell/2, gf(TA, cell*0.5), cell/2);
    //// RECT 2nd if missing iso
    if (isoMissing) {
      //rect (gf(TA, -cell*0.5), -cell/2, gf(TA, cell), cell);
      noStroke();
      fill(0, 0, 100, 70);
      textAlign(CENTER, CENTER);
      //rect (-cell/2, -cell/2, cell, cell);
      textFont(H3, 18);
      text ("Updating the map\nin progress", 0, 0);
    }
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
    text(localNumberTodayCases, gf(TA, -cell*1.5 + padding), -cell/2+padding);
    //// number local deaths today
    String localNumberTodayDeaths = nfc(table.getRow(_now).getInt(4));
    text(localNumberTodayDeaths, gf(TA, -cell*1.5 + padding), padding);
    // label local cases today
    textFont(H2, 17);
    text("New Cases", gf(TA, -cell*1.5 + padding), -cell/2 + 42);
    // label local deaths today
    text("New Deaths", gf(TA, -cell*1.5 + padding), 42);
    //
    if (TA == 0) {
      textAlign(LEFT, BOTTOM);
    } else {
      textAlign(RIGHT, BOTTOM);
    }
    //// number local total cases
    textFont(H2, 32);
    String localNumberTotalCases = nfc(table.getRow(_now).getInt(1));
    text(localNumberTotalCases, gf(TA, -cell*1.5+padding), cell*0.75 + padding);
    //// number local total deaths
    textFont(H2, 25);
    String localNumberTotalDeaths = nfc(table.getRow(_now).getInt(3));
    text(localNumberTotalDeaths, gf(TA, -cell*0.5), cell*0.75 + padding);
    if (TA == 0) {
      textAlign(RIGHT, BOTTOM);
    } else {
      textAlign(LEFT, BOTTOM);
    }
    //// number local death rate
    fill(0, 100, 100, 100);
    // labelRecovered += str(float(round(toll[6]/toll[1]*10000)/100)) +"%";
    String localNumberDeathRate = str(float(round(table.getRow(_now).getFloat(3) / table.getRow(_now).getFloat(1) * 10000)/100)) + "%";
    text(localNumberDeathRate, gf(TA, cell*0.5), cell*0.75 + padding);
    // LABELS
    textFont(H3, 17);
    if (TA == 0) {
      textAlign(LEFT, BOTTOM);
    } else {
      textAlign(RIGHT, BOTTOM);
    }
    fill(0, 0, 100, 100);
    //// label local total cases
    text("Total Cases", gf(TA, -cell*1.5 + padding), cell-padding);
    //// label local total deaths
    text("Total Deaths", gf(TA, -cell*0.5), cell-padding);
    //// label local total rate
    if (TA == 0) {
      textAlign(RIGHT, BOTTOM);
    } else {
      textAlign(LEFT, BOTTOM);
    }
    fill(0, 100, 100, 100);
    text("Rate", gf(TA, cell*0.5), cell-padding);

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
  void drawOthers () {
    // title
    fill(0, 0, 100, 100);
    textAlign (LEFT, TOP);
    textFont(H1, 30);
    text("CORONAVIRUS NOW", 20, 10);
    // update information
    textAlign (RIGHT, TOP);
    textFont(H3, 18);
    text(getLastUpdateInfo(), width-padding, padding);
  }
  void updateView(int _cut) {
    // if iso is missing 
    if (isoMissing) {
      // set locaBoundingBox target coordinate
      bboxXT = cell*6.5;
      bboxYT = tollboxY + cell + getRectSide (toll.get("New Cases"), toll.get("Total Cases"), 2*cell);

      // set tollbox target coordinate
      tollboxXT = cell*2;
      tollboxYT = height - cell*2.5 - padding;
    } else {
      // set locaBoundingBox target coordinate
      bboxXT = getCountryCentFromDatarowNO(_cut).x;
      bboxYT = getCountryCentFromDatarowNO(_cut).y;

      // set tollbox target coordinate
      if (displayMode == '<') {
        tollboxXT = 20;
        tollboxYT = height - cell*2.5 - padding;
      } else {
        tollboxXT = width/2 + (2.5*cell) - padding*2;
        tollboxYT = height - cell*2.5 - padding;
      }
    }

    // init the animation 
    tollboxXAni = Ani.to (this, 2, "tollboxX", tollboxXT);
    tollboxYAni = Ani.to (this, 2, "tollboxY", tollboxYT);
    bboxXAni = Ani.to (this, 2, "bboxX", bboxXT);
    bboxYAni = Ani.to (this, 2, "bboxY", bboxYT);
  }
  // end of 3. Render
  PVector getCountryCentFromDatarowNO (int _rowNo) {
    PVector pos = new PVector ();
    String iso = table.getRow(_rowNo).getString("iso");
    //println("iso ", iso);
    if (iso.equals("**")) {
      //pos = new PVector (width/2, height/2);
    } else {
      for (int m = 0; m < shape.getChildCount(); m++) {
        if (iso.equals(shape.getChild(m).getName())) {
          pos = geo.getCentroid(shape.getChild(m));
        }
      }
    }
    return pos;
  }
  float getCountryDistanceFromDatarowNO (int _rowNo) {
    PVector pos = new PVector ();
    float d = 0.0;
    float X = 0.0;
    float Y = 0.0;
    String iso = table.getRow(_rowNo).getString("iso");
    //println("iso ", iso);
    for (int m = 0; m < shape.getChildCount(); m++) {
      if (iso.equals(shape.getChild(m).getName())) {
        pos = geo.getCentroid(shape.getChild(m));
        X = geo.getXmin(shape.getChild(m));
        Y = geo.getYmin(shape.getChild(m));
      }
    }
    //d = float(nf(int(X), 4) + nf(int(Y), 4));
    //d = float(nf(int(pos.x), 4) + nf(int(Y), 4));
    d = X;
    return d;
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
  processing.data.JSONObject loadISOList (String url) {
    processing.data.JSONObject _job;
    _job = loadJSONObject (url);
    return _job;
  }
  String getISOFromName (processing.data.JSONObject list, String name) {
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
  String getDoublelineString (String N) {
    String[] R;
    String result;
    String[] lines = split(N, ' ');
    int tally;
    float middle;
    int index;
    R = new String[2];
    R[0] = "";
    R[1] = "";
    if (lines.length > 2) {
      tally = 0;
      middle = N.length() / 2;
      //println("N.length; ", N.length(), " / ", N.length()/2); 
      index = floor(middle);
      //println("index; ", index);
      for (int i = 0; i < lines.length; i++) {
        tally += lines[i].length() + 1;
        int diff = abs (floor(middle) - tally);
        if (diff < index) {
          index = i;
        } else {
          //index = index;
          index = index-1;
        }
        //print(i);
      }
      tally = 0;
      for (int i = lines.length-1; i > -1; i--) {
        tally += lines[i].length()+1;
        int diff = abs (floor(middle) - tally);
        if (diff < index) {
          index = i;
        } else {
          //index = index;
          index = index+1;
        }
        //print(i);
      }
      for (int k = 0; k < index+1; k++) {
        R[0] += lines[k] + ' ';
      }
      for (int k = index+1; k < lines.length; k++) {
        R[1] += lines[k] + ' ';
      }
      R = trim(R);
      result = join(R, '\n');
    } else if (lines.length == 2) {
      R[0] = lines[0];
      R[1] = lines[1];
      R = trim(R);
      result = join(R, '\n');
    } else {
      result = N;
    }
    return result;
  }
  String getLastUpdateInfo () {
    int diff = passedMinuteThisMonth() - updatedOn;
    String updatedInfo = "update info unavailable";
    if (caseLoader.worldometerAccessible) { 
      if (diff < 60 && diff >= 0) {
        updatedInfo = "Data updated  " + diff + " min ago";
      } else if (diff >= 60 && diff < 1440) {
        updatedInfo = "Data updated " + float(round(float(diff*10) / float(60)))/10 + " hours ago";
      } else if (diff >= 1440) {
        updatedInfo = "Data updated " + float(round(float(diff*10) / float(1440)))/10 + " days ago";
      }
    } else {
      if (diff < 60 && diff >= 0) {
        updatedInfo = "Data accessed " + diff + " min ago";
      } else if (diff >= 60 && diff < 1440) {
        updatedInfo = "Data accessed  " + float(round(float(diff*10) / float(60)))/10 + " hours ago";
      } else if (diff >= 1440) {
        updatedInfo = "Data accessed  " + float(round(float(diff*10) / float(1440)))/10 + " days ago";
      }
    }
    return updatedInfo;
  }

  int passedMinuteThisMonth() {
    return  day()*24*60 +  hour() * 60 + minute();
  }
}
