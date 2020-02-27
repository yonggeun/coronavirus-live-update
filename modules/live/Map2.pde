class Map2 { //<>// //<>// //<>// //<>//
  PShape shape;
  float scale;
  PVector pos;
  JSONObject isoList;
  IntDict stat;
  Geometry geo;
  Map2 () {
    stat = new IntDict();
    geo = new Geometry();
  }
  void attachMap (String L) {
    shape = loadShape (L);
    shape.disableStyle();
    scale = width / shape.width;
    print ("width", shape.getWidth());
    print (" / scale : ", scale);
    //println ("(width-shape.getWidth())/2", (width-shape.getWidth())/2);
    //shape.translate((width-shape.getWidth())/2, (height - shape.getHeight())/8);
    //shape.scale(scale);
    println(" / width", shape.getWidth());

    pos = new PVector ((width-shape.getWidth())/2, (height - shape.getHeight())/8);
    //translate(pos.x, pos.y);
    isoList = loadISOList ("data/iso3166-1.json");
  }
  void render (Table T, int _now) {
    colorMode (HSB, 360, 100, 100, 100);
    int c = 0;
    int d = 0;
    int r = 0;
    int t = 0;
    // render the world map first
    for (int i = 0; i < shape.getChildCount(); ++i) {
      PShape ps = shape.getChild(i);
      String currentISO = ps.getName();
      String currentName = getNameFromISO(currentISO);
      Boolean hasCase = false;
      for (int k = 0; k < T.getRowCount(); k++) {
        //println(currentName," ",T.getRow(k).getString(1));
        if (T.getRow(k).getString(8).equals(currentISO)) {
          hasCase = true;
          //println(T.getRow(k).getString(6), " marked");
          c = T.getRow(k).getInt(1);
          d = T.getRow(k).getInt(3);
          r = T.getRow(k).getInt(5);
        }
      }
      // Disable the colors found in the SVG file
      ps.disableStyle();
      strokeWeight(0.5);
      stroke(0);
      fill(42);
      if (hasCase == true) {
        fill(0, // Hue 0 is red
          map(log(c)/log(2), 0, log(stat.get("case_total"))/log(2), 80, 100), // Saturation
          map(log(c)/log(2), 0, log(stat.get("case_total"))/log(2), 20, 80), // Brightness
          map(log(c)/log(2), 0, log(stat.get("case_total"))/log(2), 80, 100) // Alpha
          );
        if (T.getRow(_now).getString(0).equals(getNameFromISO(ps.getName()))) {
          drawCurrentCountry(ps, _now);
        }
      } else {
        strokeWeight(0.5);
        stroke(0);
        fill(42);
      }
      // Draw a single state
      shape(ps, 0, 0);
    }
  }
  void drawCurrentCountry(PShape cc, int _now) {
    float left = geo.getLeft(cc);
    float right = geo.getRight(cc);
    float top = geo.getTop(cc);
    float bottom = geo.getBottom(cc);
    PVector cent;
    if (cc.getWidth() < 142) {
      cent = geo.getCentroid(cc);
      rectMode (CENTER);
      noFill();
      strokeWeight(2);
      stroke(255);
      rect(cent.x, cent.y, 142, 142);
    } else {
    }
    strokeWeight (1.5);
    stroke (255);
    shape(cc, 0, 0);
  }
  void updateView() {
  }
  void renderCountry (PShape cs, Boolean _case, TableRow data) {
    // cs is PShape of the coutnry
    // case is a Boolean value. True if has case, false if no case
    // data is a dataRow which has the information
    // default style
    String currentISO = cs.getName();

    strokeWeight(1);
    fill(46);
    if (_case) {
    } else {
    }
  }
  void attachTable(Table T) {
    int case_total = 0;
    int case_new = 0;
    int death_total = 0;
    int death_new = 0;
    int case_recovered = 0;
    int case_critical = 0;
    T.addColumn("iso");
    for (int k = 0; k < T.getRowCount(); k++) {
      //println(currentName," ",T.getRow(k).getString(1));
      TableRow r = T.getRow(k);
      // get iso code for each row
      r.setString("iso", getISOFromName(isoList, r.getString(0)));
      // push confirmed
      case_total      += r.getInt(1);
      case_new        += r.getInt(2);
      death_total     += r.getInt(3);
      death_new       += r.getInt(4);
      case_recovered  += r.getInt(5);
      case_critical   += r.getInt(6);
    }
    stat.set("case_total", case_total);
    stat.set("case_new", case_new);
    stat.set("death_total", death_total);
    stat.set("death_new", death_new);
    stat.set("case_recovered", case_total);
    stat.set("case_critical", case_critical);

    println(stat.get("case_total"));
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
      //for (int k = 0; k < r.length; k++) {
      //  println(r[k]);
      //}
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
}
