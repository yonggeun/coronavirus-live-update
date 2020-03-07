class Loader2 { //<>//
  String url;
  String status;
  String type;
  float[] toll;
  Table table;
  JSONObject isoList;
  Timer timer;
  Boolean loaded;
  //
  StringDict meta;
  Loader2 (String _dataType) {
    switch (_dataType) {
    case "data":
      type = "data";
      break;
    case "meta":
      type = "meta";
      break;
    }
  }
  void refresh(Table T, float[] array) {
    isoList = loadISOList ("data/iso3166-1.json");
    loadSheetData (url);
    T = table;
    array = toll;
  }
  void load (String Link) {
    switch (type) {
    case "data":
      isoList = loadISOList ("data/iso3166-1.json");
      loadSheetData (Link);
      break;
    case "meta":
      loadMetaData (Link);
      break;
    }
  }
  void loadMetaData (String Link) {
  }
  void loadSheetData (String Link) {
    loaded = false;
    JSONObject _job;
    //Table _table;
    url = Link;
    // check the link
    if (Link.substring(0, 4).equals("http") == true) {
      // if the link is internet url
      // then use getJsonFrom
      GetRequest _get = new GetRequest(Link);
      _get.send();
      _job = parseJSONObject (_get.getContent());
      status = "online";
      saveJSONObject (_job, "data/latest.json");
    } else {
      // the link is local file
      _job = loadJSONObject (Link);
      status = "offline";
    }
    // parse the object to array
    JSONArray _jarray = _job.getJSONArray("values");
    //
    table = getTable (_jarray);
    loaded = true;
  }
  Table getTable (JSONArray J) {
    // | 0               | 1            | 2          | 3            | 4           | 5            | 6               | 7                  | 8
    // | Country, Other  | Total Cases  | Total New  | Total Deaths | New Deaths  | Active cases |Total Recovered  | Serious, Critical  | iso  |
    Table T = new Table();
    //Table TF  = new Table();
    for (int k = 0; k < J.getJSONArray(0).size(); k++) { // total 8
      T.addColumn(J.getJSONArray(0).getString(k));
      //println("T.addColumn(J.getJSONArray(0).getString(k)) : ", J.getJSONArray(0).getString(k));
    }
    T.addColumn("iso");
    toll = new float[T.getColumnCount()]; // total 9
    for (int i = 1; i < J.size()-1; i++) {
      TableRow TR = T.addRow();
      //0 country
      TR.setString(0, J.getJSONArray(i).getString(0));
      //print("J.getJSONArray(i).getString(0) : ", J.getJSONArray(i).getString(0));
      for (int j = 1; j < T.getColumnCount()-1; j++) {
        int result;
        if (J.getJSONArray(i).isNull(j) == false) {
          result = parseNumber (J.getJSONArray(i).getString(j));
          TR.setInt(j, result);
          toll[j] += TR.getFloat(j);
        } else {
          result = -1;
          toll[j] += 0;
        }
      }
      //8 iso
      TR.setString(T.getColumnCount()-1, getISOFromName(isoList, J.getJSONArray(i).getString(0)));
      //println(J.getJSONArray(i).getString(0), "\t\t\t\t", getISOFromName(isoList, J.getJSONArray(i).getString(0)));
      if (getISOFromName(isoList, J.getJSONArray(i).getString(0)).equals("") 
        || getISOFromName(isoList, J.getJSONArray(i).getString(0)) == null) {
        println(J.getJSONArray(i).getString(0), "has no name");
      }
    }
    toll[0] = T.getRowCount();
    //println(toll);
    saveTable(T, "data/"+str(year())+nf(month(), 2)+nf(day(), 2)+nf(hour(), 2)+nf(minute(), 2)+".csv");
    return T;
  }
  void setTimer (float _duration) {
    timer = new Timer (_duration, table.getRowCount()-1);
  }
  int parseDate (String D) {
    String R;
    String[] P = splitTokens (D, "- :");
    //R = P[2]+nf(int(P[0]), 2) + nf(int(P[1]), 2)+nf(int(P[3]), 2) + nf(int(P[4]), 2) + "L";
    R = nf(int(P[0]), 2) +nf(int(P[1]), 2)+nf(int(P[3]), 2) + nf(int(P[4]), 2);
    return int (R);
  }
  int parseNumber (String N) {
    int number;
    if (N != null) {
      String[] numbers = splitTokens(N, ",+");
      number = int(join(numbers, ""));
    } else {
      number = 0;
    }
    return number;
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
