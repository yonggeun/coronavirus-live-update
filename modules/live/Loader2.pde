class Loader2 {
  Table table;
  String url;
  String status;
  String type;
  StringDict meta;
  Timer timer;
  Loader2 (String _dataType) {
    switch (_dataType) {
    case "sheet":
      type = "sheet";
      break;
    case "meta":
      type = "meta";
      break;
    }
  }
  void load (String Link) {
    switch (type) {
    case "sheet":
      loadSheetData (Link);
      break;
    case "meta":
      loadMetaData (Link);
      break;
    }
  }
  void loadMetaData (String Link) {
  }
  Table loadSheetData (String Link) {
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
    table = getTable (_jarray);
    return table;
  }
  Table getTable (JSONArray J) {
    Table T = new Table();
    //Table TF  = new Table();
    for (int k = 0; k < J.getJSONArray(0).size(); k++) {
      T.addColumn(J.getJSONArray(0).getString(k));
      //TF.addColumn(J.getJSONArray(0).getString(k));
    }
    for (int i = 1; i < J.size(); i++) {
      TableRow TR = T.addRow();
      //country
      TR.setString(0, J.getJSONArray(i).getString(0));
      //println("J.getJSONArray(i).getString(0) : ", J.getJSONArray(i).getString(0)); 
      //total cases
      TR.setInt(1, parseNumber (J.getJSONArray(i).getString(1)));
      //println("int(J.getJSONArray(i).getString(1)) : ", J.getJSONArray(i).getString(1));
      //new cases
      TR.setInt(2, parseNumber (J.getJSONArray(i).getString(2)));
      //total death
      TR.setInt(3, parseNumber (J.getJSONArray(i).getString(3)));
      //new death
      TR.setInt(4, parseNumber (J.getJSONArray(i).getString(4)));
      //total recovered
      TR.setInt(5, parseNumber (J.getJSONArray(i).getString(5)));
      //serious, critical
      TR.setInt(6, parseNumber (J.getJSONArray(i).getString(6)));
      //region
      //TR.setString(7, J.getJSONArray(i).getString(7));
    }
    saveTable(T, "data/T.csv");
    return T;
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
    String[] numbers = splitTokens(N, ",+");
    number = int(join(numbers, ""));
    return number;
  }
  void setTimer (String _duration, int _frameRate) {
    timer = new Timer (_duration, table.getRowCount(), _frameRate);
  }
}
