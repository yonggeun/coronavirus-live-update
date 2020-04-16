class Loader {
  String url;
  String isourl;
  String status;
  String type;

  FloatDict toll;
  Table table;

  processing.data.JSONObject isoList;
  Boolean loaded;

  //
  int updatedOn;
  String jsonDate;
  Boolean worldometerAccessible;


  //Sentinel sentinel;
  StringDict meta;
  Loader (String _dataType) {
    switch (_dataType) {
    case "data":
      type = "data";
      break;
    case "meta":
      type = "meta";
      break;
    }
    //sentinel = new Sentinel();
  }

  void load (String Link, String ISOURL) {
    worldometerAccessible = false;
    switch (type) {
    case "data":
      isoList = loadISOList (ISOURL);
      loadSheetData (Link);
      break;
    case "meta":
      loadMetaData (Link);
      break;
    }
    updatedOn = getUpdatedOn();
  }

  void refresh () {
    isoList = loadISOList (isourl);
    loadSheetData (url);
    updatedOn = getUpdatedOn();
  }

  //void refresh2 (Table T, float[] array) {
  //  isoList = loadISOList (isourl);
  //  loadSheetData (url);
  //  T = table;
  //  array = toll;
  //}

  void loadMetaData (String Link) {
  }
  void loadSheetData (String Link) {
    loaded = false;
    processing.data.JSONObject _job;
    //Table _table;
    url = Link;
    // check the link
    if (Link.substring(0, 4).equals("http") == true) {
      // if the link is internet url
      // then use getJsonFrom
      GetRequest _get = new GetRequest(Link);
      try {
        _get.send();
        _job = parseJSONObject (_get.getContent());
        jsonDate = _get.getHeader("date");
        status = "online";
        sentinel.inform("> Success loading datasheet from google");
        saveJSONObject (_job, "data/LOG-JSON/latest.json");
      } 
      catch (Throwable t) {
        status = "offline";
        sentinel.report(t, frameCount);
        _job = loadJSONObject ("data/LOG-JSON/latest.json");
        //jsonDate = _get.getHeader("date");
      }
      //saveJSONObject (_job, "data/LOG-JSON/"+str(year())+nf(month(), 2)+nf(day(), 2)+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2)+".json");
    } else {
      // the link is local file
      _job = loadJSONObject (Link);
      status = "offline";
    }
    // parse the object to array
    processing.data.JSONArray _jarray = _job.getJSONArray("values");
    //
    table = getTable (_jarray);
    loaded = true;
  }

  // Convert JSONArray into 
  // a table     for local bbox rendering
  // and IntDict for tollbox rendering
  Table getTable (processing.data.JSONArray J) {

    // | 0               | 1            | 2          | 3            | 4           | 5               | 6               | 7                  | 8                | 9
    // | Country, Other  | Total Cases  | New Cases  | Total Deaths | New Deaths  | Total Recovered | Active Cases    | Serious, Critical  | Tot Cases/M pop  | ISO

    String isoError = null;
    Boolean isoMismatch = false;  

    Table T = new Table();
    toll = new FloatDict();

    for (int k = 0; k < J.getJSONArray(0).size(); k++) { // total 9
      String columnName  = join (split(J.getJSONArray(0).getString(k), '\n'), ' ');
      //print(columnName, '\t');
      T.addColumn(columnName);
      toll.set(columnName, 0.0);
    }
    //toll = new float[T.getColumnCount()]; // total 10
    //J.getJSONArray(0) is column titles.
    //J.getJSONArray(0) is tool for each column. 
    // PARSE COLUMNS FOR EACH ROW
    for (int i = 1; i < J.size(); i++) {
      TableRow TR = T.addRow();
      //0 country
      TR.setString(0, J.getJSONArray(i).getString(0));
      //print("J.getJSONArray(i).getString(0) : ", J.getJSONArray(i).getString(0));
      for (int j = 1; j < T.getColumnCount()-1; j++) {
        float localValue = 0;
        float _sum = toll.get(TR.getColumnTitle(j));
        if (J.getJSONArray(i).isNull(j) == false) {
          localValue = parseNumber (J.getJSONArray(i).getString(j));
          TR.setFloat(j, localValue);
          //toll[j] += TR.getFloat(j);
          toll.set(TR.getColumnTitle(j), _sum + localValue);
        } else {
          //localValue = -1;
          TR.setFloat(j, localValue);
          //toll[j] += 0;
          toll.set(TR.getColumnTitle(j), _sum + localValue);
        }
      }
    }
    // ADD ISO COLUMN FOR EACH ROW
    //8 iso
    //println(J.getJSONArray(i).getString(0), "\t\t\t\t", getISOFromName(isoList, J.getJSONArray(i).getString(0)));
    T.addColumn("iso");
    for (int i = 1; i < J.size(); i++) {
      if (getISOFromName(isoList, J.getJSONArray(i).getString(0)).equals("") 
        || getISOFromName(isoList, J.getJSONArray(i).getString(0)) == null) {
        //println(J.getJSONArray(i).getString(0), "has no name");
        // if there is no lable for the name give ID "**"
        isoMismatch = true;
        T.setString(i-1, "iso", "**");
        if (isoError == null) {
          isoError = J.getJSONArray(i).getString(0) + " is not on ISO list.\n";
        } else {
          isoError += J.getJSONArray(i).getString(0) + " is not on ISO list.\n";
        }
      } else {
        isoMismatch = false;
        //TR.setString(T.getColumnCount()-1, getISOFromName(isoList, J.getJSONArray(i).getString(0)));
        T.setString(i-1, "iso", getISOFromName(isoList, J.getJSONArray(i).getString(0)));
      }
    }
    if (isoError != null) {
      println ("> ISO mismatch occurred.\n" + sentinel.nowInString() + "\n" + trim(isoError));
      sentinel.inform ("> ISO mismatch occurred.\n" + sentinel.nowInString() + "\n" + trim(isoError));
    }
    toll.set(T.getColumnTitle(0), T.getRowCount());
    toll.set(T.getColumnTitle(T.getColumnCount()-1), T.getRowCount());
    //println(toll);
    //saveTable(T, "data/LOG-CSV/"+str(year())+nf(month(), 2)+nf(day(), 2)+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2)+".csv");
    return T;
  }
  processing.data.JSONObject loadISOList (String URL) {
    isourl = URL;
    processing.data.JSONObject _job;
    _job = loadJSONObject (URL);
    return _job;
  }
  int parseDate (String D) {
    String R;
    String[] P = splitTokens (D, "- :");
    //R = P[2]+nf(int(P[0]), 2) + nf(int(P[1]), 2)+nf(int(P[3]), 2) + nf(int(P[4]), 2) + "L";
    R = nf(int(P[0]), 2) +nf(int(P[1]), 2)+nf(int(P[3]), 2) + nf(int(P[4]), 2);
    return int (R);
  }
  float parseNumber (String N) {
    float number;
    if (N != null) {
      String[] numbers = splitTokens(N, ",+");
      number = int(join(numbers, ""));
    } else {
      number = 0;
    }
    return number;
  }
  String getISOFromName (processing.data.JSONObject list, String name) {
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
  //int getUpdatedOn1 () {
  //  int a = 02101230; 
  //  return a;
  //}
  int getUpdatedOn () {
    String url = "http://www.worldometers.info/coronavirus/";
    String _lastUpdated;
    //String[] month = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
    String[] updated;
    int updatedInMinute;
    // March 11, 2020, 05:10 GMT
    // Get the raw HTML source into an array of strings (each line is one element in the array).
    // The next step is to turn array into one long string with join().
    try {
      String[] lines = loadStrings(url);
      String html = join(lines, "");
      String start = "id=\"page-top\">COVID-19 Coronavirus Outbreak</div><div style=\"font-size:13px; color:#999; text-align:center\">Last updated: ";
      String end = "</div><div style=\"margin-top:20px; text-align:center; font-size:14px\"><a href=\"/coronavirus/coronavirus-cases/\">";
      _lastUpdated = giveMeTextBetween(html, start, end);
      //March 13, 2020, 05:35 GMT
      updated = splitTokens(_lastUpdated, ", :");
      updatedInMinute = int(updated[4]) + int(updated[3]) * 60 + int(updated[1]) * 24*60 + 480;
      worldometerAccessible = true;
    } 
    catch (Throwable t) {
      //Fri, 13 Mar 2020 05:34:29 GMT
      //println("JSON response header -> date : ", _get.getHeader("date"));
      println("> http://www.worldometers.info/coronavirus/ is missing or inaccessible " + sentinel.nowInString());
      sentinel.inform ("> http://www.worldometers.info/coronavirus/ is missing or inaccessible");
      _lastUpdated = jsonDate;
      updated = splitTokens(_lastUpdated, ", :");
      updatedInMinute = int(updated[5]) + int(updated[4]) * 60 + int(updated[1]) * 24*60 + 480;
      worldometerAccessible = false;
    }
    // calculate local update time in minute
    return updatedInMinute;
  }
  String giveMeTextBetween(String s, String before, String after) {
    // This function returns a substring between two substrings (before and after).
    //  If it can’t find anything it returns an empty string.
    String found = "";

    // Find the index of before
    int start = s.indexOf(before);     
    if (start == -1) {
      return "";
    }    

    // Move to the end of the beginning tag
    // and find the index of the "after" String      
    start += before.length();    
    int end = s.indexOf(after, start); 
    if (end == -1) {
      return "";
    }

    // Return the text in between
    return s.substring(start, end);
  }
}
