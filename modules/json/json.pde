import http.requests.*;
JSONObject cases;
Table caseTable;

void setup () {
  cases = loadJSONObject ("cases___.json");
  JSONArray _case = cases.getJSONArray ("values");
  caseTable = parseCase (_case);
  println(caseTable.toString());
}

void draw() {
}

Table parseCase (JSONArray J) {
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
    TR.setString(2, J.getJSONArray(i).getString(2));
    //TR.setInt(2, parseDate(J.getJSONArray(i).getString(2)));
    //println(parseDate(J.getJSONArray(i).getString(2)));
    TR.setInt(3, J.getJSONArray(i).getInt(3));
    TR.setInt(4, J.getJSONArray(i).getInt(4));
    TR.setInt(5, J.getJSONArray(i).getInt(5));
  }
  T.sort(2);
  T.sort(1);
  saveTable(T, "data/T.csv");
  println("T.getRowCount() : "+T.getRowCount());
  //println(T.getRow(0).getString(1));
  //println(T.getRow(1).getString(1));
  //
  int c3 = 0;
  int c4 = 0;
  int c5 = 0;
  for (int m = 1; m < T.getRowCount(); m++) {
    String c1 = T.getRow(m).getString(1);
    String c2 = T.getRow(m-1).getString(1);
    println ("country : ", c1);
    c3 += T.getRow(m-1).getInt(3);
    c4 += T.getRow(m-1).getInt(4);
    c5 += T.getRow(m-1).getInt(5);
    if (m != T.getRowCount()-1) {
      if (c1.equals(c2)) {
        c3 += T.getRow(m).getInt(3);
        c4 += T.getRow(m).getInt(4);
        c5 += T.getRow(m).getInt(5);
      } else {
        TableRow TR = TF.addRow();
        TR.setString(1, T.getRow(m-1).getString(1));
        //println("counrty : " + T.getRow(m-1).getString(1));
        TR.setString(2, T.getRow(m-1).getString(2));
        TR.setInt(3, c3);
        TR.setInt(4, c4);
        TR.setInt(5, c5);
        c3 = T.getRow(m).getInt(3);
        c4 = T.getRow(m).getInt(3);
        c5 = T.getRow(m).getInt(3);
      }
    } else { // the last raw
      if (c1.equals(c2)) {
        c3 += T.getRow(m).getInt(3);
        c4 += T.getRow(m).getInt(4);
        c5 += T.getRow(m).getInt(5);
        TableRow TR = TF.addRow();
        TR.setString(1, T.getRow(m).getString(1));
        //println("counrty : " + T.getRow(m-1).getString(1));
        TR.setString(2, T.getRow(m).getString(2));
        TR.setInt(3, c3);
        TR.setInt(4, c4);
        TR.setInt(5, c5);
      } else {
        TableRow TR = TF.addRow();
        TR.setString(1, T.getRow(m-1).getString(1));
        //println("counrty : " + T.getRow(m-1).getString(1));
        TR.setString(2, T.getRow(m-1).getString(2));
        TR.setInt(3, c3);
        TR.setInt(4, c4);
        TR.setInt(5, c5);
        //
        TableRow TRL = TF.addRow();
        c3 = T.getRow(m).getInt(3);
        c4 = T.getRow(m).getInt(3);
        c5 = T.getRow(m).getInt(3);
        TRL.setString(1, T.getRow(m).getString(1));
        //println("counrty : " + T.getRow(m-1).getString(1));
        TRL.setString(2, T.getRow(m).getString(2));
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

JSONObject getJsonFrom (String _url) {
  JSONObject _jsonObject; 
  GetRequest _get = new GetRequest (_url);
  _get.send();
  _jsonObject = parseJSONObject (_get.getContent());
  return _jsonObject;
}
