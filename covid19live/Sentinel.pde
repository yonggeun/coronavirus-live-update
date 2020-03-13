class Sentinel {
  //https://coderwall.com/p/yjim_a/sending-tweets-using-processing
  Twitter twitter;
  String receiver;
  String[] keys;
  Boolean inTraining;
  Sentinel () {
    //inTraining = true;
    setMode (false);
    loadKeys();
    if (keys != null) {
      twitterConfiguration(keys);
    }
    receiver = "vizualizer1";
  }
  void setMode (Boolean _m) {
    inTraining = _m;
  }
  void loadKeys () {
    BufferedReader reader;
    String line;
    reader = createReader("twitter.key");
    String[] _keys;
    try {
      line = reader.readLine();
    } 
    catch (Throwable e) {
      line = null;
    }
    if (line == null ) {
      println ("> Twitter key unavailable.");
      keys = null;
    } else {
      println ("> Twitter key obtained.");
      _keys = split(line, ';');
      keys = _keys;
    }
  }
  int verifyInt (int _value, int _altValue) {
    int __v = 0;
    try {
      __v = _value;
    }
    catch (Throwable e) {
      //println(e.toString(), "?? ", frameCount);
      report (e, frameCount);
      //cabinet
      __v = _altValue;
    }
    //}
    return __v;
  }
  void report (Throwable _what, int _when) {
    String _message = "";
    String when = nowInString() + " @ Frame number : " + Integer.toString( _when, 10) + '\n';
    _message += when;
    _message += throwableToString (_what);
    int chars = _message.length();
    _message += "\n> End of Report with " + chars + " chars."; 
    println(_message);
    directMessage(receiver, _message);
  }
  void inform (String _message) {
    directMessage(receiver, _message);
  }
  void directMessage(String _reveiver, String _directMessage) {
    if (inTraining) {
      System.out.println("> EOF - in training mode ");
    } else {
      try {
        twitter.sendDirectMessage(_reveiver, _directMessage);
        System.out.println("> Direct message sent " + nowInString());
      }
      catch (TwitterException te) {
        System.out.println("Error: "+ te.getMessage());
      }
    }
  }

  void twitterConfiguration(String[] _key) {
    ConfigurationBuilder cb = new ConfigurationBuilder();
    cb.setOAuthConsumerKey(_key[0]);
    cb.setOAuthConsumerSecret(_key[1]);
    cb.setOAuthAccessToken(_key[2]);
    cb.setOAuthAccessTokenSecret(_key[3]);
    TwitterFactory tf = new TwitterFactory(cb.build());
    twitter = tf.getInstance();
  }
  String throwableToString (Throwable _t) {
    String _string = "";
    _string = _t.toString() + '\n';
    for (int k = 0; k < _t.getStackTrace().length; k++) {
      //println(_t.getStackTrace()[k]);
      _string += trim(_t.getStackTrace()[k].toString());
      if (k != _t.getStackTrace().length-1) {
        _string += '\n';
      }
    }
    return _string;
  }
  String nowInString() {
    return year() + " " + nf(month(), 2) + "-" + nf(day(), 2) + " " + nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
  }
}
