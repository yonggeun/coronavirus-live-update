class Map {
  PShape shape;
  Float scale;
  PVector pos;
  JSONObject isoList;
  IntDict stat;
  Map () {
    stat = new IntDict();
    stat.set("totalConfirmed", 0);
    stat.set("totalDeath", 0);
    stat.set("totalRecovered", 0);
  }
  void attachMap (String L) {
    shape = loadShape (L);
    shape.disableStyle();
    scale = width/shape.width*1.1;
    shape.scale(scale);
    // println (shape.getWidth());
    // println (shape.getHeight());
    shape.translate((width-shape.getWidth())/2, (height - shape.getHeight())/8);
    pos = new PVector ((width-shape.getWidth())/2, (height - shape.getHeight())/8);
    // shape.translate((width-shape.getWidth())/2, 0);
    isoList = loadISOList ("data/iso3166-1.json");
  }
  void attachTable(Table T) {
    int confirmedSum = 0;
    int deathSum = 0;
    int recoveredSum = 0;
    T.addColumn("iso");
    for (int k = 0; k < T.getRowCount(); k++) {
      //println(currentName," ",T.getRow(k).getString(1));
      TableRow r = T.getRow(k);
      // get iso code for each row
      r.setString("iso", getISO(isoList, r.getString(1)));
      // push confirmed
      confirmedSum += r.getInt(3);
      deathSum += r.getInt(4);
      recoveredSum += r.getInt(5);
    }
    stat.set("totalConfirmed", confirmedSum);
    stat.set("totalDeath", deathSum);
    stat.set("totalRecovered", recoveredSum);
  }
  void render (Table T) {
    colorMode (HSB, 360, 100, 100, 100);
    int c = 0;
    int d = 0;
    int r = 0;
    int t = 0;
    for (int i = 0; i < shape.getChildCount(); ++i) {
      PShape ps = shape.getChild(i);
      String currentISO = ps.getName();
      String currentName = getNameFromISO(currentISO);

      Boolean hasCase = false;
      // Disable the colors found in the SVG file
      ps.disableStyle();
      // styling 
      //noStroke();
      stroke(0, 0, 0, 100);
      strokeWeight(1);
      for (int k = 0; k < T.getRowCount(); k++) {
        //println(currentName," ",T.getRow(k).getString(1));
        if (T.getRow(k).getString("iso").equals(currentISO)) {
          hasCase = true;
          //println(T.getRow(k).getString(6), " marked");
          c = T.getRow(k).getInt(3);
          d = T.getRow(k).getInt(4);
          r = T.getRow(k).getInt(5);
        }
      }
      if (hasCase == true) {
        //fill(360, map(, 0, ), 100, map());
        //println (ps.width," ", ps.height);
        //noFill();
        fill(360, map(c, 0, stat.get("totalConfirmed"), 10, 70), map(c, 0, stat.get("totalConfirmed"), 80, 90), map(c, 0, stat.get("totalConfirmed"), 70, 100));
        strokeWeight(1);
        ellipseMode(CENTER);
        ellipse (ps.getVertexX(1)*scale + pos.x, ps.getVertexY(1)*scale + pos.y, 50, 50);
        //println("ps.getVertexX(1), ps.getVertexY(1) : ",ps.getVertexX(1), ps.getVertexY(1));
        //fill(60, 100, 100, 50);
      } else {
        fill(64);
      }
      // Draw a single state
      shape(ps, 0, 0);
    }
  }
  JSONObject loadISOList (String url) {
    JSONObject _job;
    _job = loadJSONObject (url);
    return _job;
  }
  String getISO (JSONObject list, String name) {
    String code;
    String m = list.toString();
    String q = "([A-Z]{2})\\W+\""+name;
    String[] r = match(m, q);
    if (r == null) {
      println("no result");
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
