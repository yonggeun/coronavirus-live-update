class Loader {
  String url;
  String status;
  Loader () {
  }
  Table load (String Link) {
    JSONObject _job;
    Table _table;
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
    _table = getTable (_jarray);
    return _table;
  }
  Table getTable (JSONArray J) {
    Table T = new Table();
    Table TF  = new Table();
    for (int k = 0; k < J.getJSONArray(0).size(); k++) {
      T.addColumn(J.getJSONArray(0).getString(k));
      TF.addColumn(J.getJSONArray(0).getString(k));
    }
    for (int i = 1; i < J.size(); i++) {
      TableRow TR = T.addRow();
      TR.setString(0, J.getJSONArray(i).getString(0));
      TR.setString(1, J.getJSONArray(i).getString(1));
      //TR.setString(2, J.getJSONArray(i).getString(2));
      TR.setInt(2, parseDate(J.getJSONArray(i).getString(2)));
      //println(parseDate(J.getJSONArray(i).getString(2)));
      TR.setInt(3, J.getJSONArray(i).getInt(3));
      TR.setInt(4, J.getJSONArray(i).getInt(4));
      TR.setInt(5, J.getJSONArray(i).getInt(5));
    }
    T.sort(2);
    T.sort(1);
    saveTable(T, "data/T.csv");
    println("T.getRowCount() : "+T.getRowCount());
    // Rmove the repetitous rows after summing up the tolls. 
    int c3 = T.getRow(0).getInt(3);
    int c4 = T.getRow(0).getInt(4);
    int c5 = T.getRow(0).getInt(5);
    for (int m = 1; m < T.getRowCount(); m++) {
      String c1 = T.getRow(m).getString(1);
      String c2 = T.getRow(m-1).getString(1);
      //println ("country : ", c1);
      if (c1.equals(c2)) { 
        // if the current row is continuous from the above row.
        // sum up the current row values to the previous
        c3 += T.getRow(m).getInt(3); 
        c4 += T.getRow(m).getInt(4);
        c5 += T.getRow(m).getInt(5);

        // if this is the last line
        if (m == T.getRowCount()-1) {
          // then flush the current row to the table
          TableRow TR = TF.addRow();
          TR.setString(1, T.getRow(m).getString(1));
          //println("counrty : " + T.getRow(m-1).getString(1));
          TR.setInt(2, T.getRow(m).getInt(2));
          //TR.setInt(2, parseDate(T.getRow(m).getString(2)));
          TR.setInt(3, c3);
          TR.setInt(4, c4);
          TR.setInt(5, c5);
        }
      } else {
        // if the current row is the beginning of the new row
        // then make a new row from the previous rows
        TableRow TR = TF.addRow();
        TR.setString(1, T.getRow(m-1).getString(1));
        //println("counrty : " + T.getRow(m-1).getString(1));
        TR.setInt(2, T.getRow(m-1).getInt(2));
        //TR.setInt(2, parseDate(T.getRow(m-1).getString(2)));
        TR.setInt(3, c3);
        TR.setInt(4, c4);
        TR.setInt(5, c5);
        c3 = T.getRow(m).getInt(3);
        c4 = T.getRow(m).getInt(4);
        c5 = T.getRow(m).getInt(5);

        // if this is the last line
        if (m == T.getRowCount()-1) {
          // second, add the current row information to the table. 
          TableRow TRL = TF.addRow();
          TRL.setString(1, T.getRow(m).getString(1));
          //println("counrty : " + T.getRow(m-1).getString(1));
          TRL.setInt(2, T.getRow(m).getInt(2));
          //TRL.setInt(2, parseDate(T.getRow(m).getString(2)));
          TRL.setInt(3, c3);
          TRL.setInt(4, c4);
          TRL.setInt(5, c5);
        }
      }
    }
    saveTable(TF, "data/TF.csv");
    return TF;
  }
  int parseDate (String D) {
    String R;
    String[] P = splitTokens (D, "/ :");
    //R = P[2]+nf(int(P[0]), 2) + nf(int(P[1]), 2)+nf(int(P[3]), 2) + nf(int(P[4]), 2) + "L";
    R = nf(int(P[0]), 2) +nf(int(P[1]), 2)+nf(int(P[3]), 2) + nf(int(P[4]), 2);
    return int (R);
  }
}
