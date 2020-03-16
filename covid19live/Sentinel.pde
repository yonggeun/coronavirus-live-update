class Sentinel {
  //https://coderwall.com/p/yjim_a/sending-tweets-using-processing
  // This class sends twitter DM reporting app status. 
  Twitter twitter;
  String receiver;
  String[] keys;
  Boolean inTraining;
  
  Sentinel () {
    setMode (false);
    loadKeys();
    if (keys != null) {
      twitterConfiguration(keys);
    }
    // vizualizer1 is my own supporting accoujnt.
    // change to your oww recipient.
    receiver = "vizualizer1";
  }
  
  void setMode (Boolean _m) {
    inTraining = _m;
  }

  // loads twitter dev key
  void loadKeys () {
    BufferedReader reader;
    String line;
    // get your own key from https://developer.twitter.com/en/docs/basics/developer-portal/overview
    // twitter key file is with semicolon(;) seperated single line text file.
    // the sequence of the keys are as shown in twitterConfiguration method
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

      // set this twitter into inTraining mode which never send twitter DM.
      setMode(true);
    } else {
      println ("> Twitter key obtained.");
      _keys = split(line, ';');
      keys = _keys;
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

  // In case of serious error
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

  // just for ordinary update
  void inform (String _message) {
    directMessage(receiver, _message);
  }

  // send DM
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

  // converts error of exception into string to send it over twitter DM
  // twitter DM limit the chars under 10,000
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

  // returns current time in String.
  String nowInString() {
    return year() + " " + nf(month(), 2) + "-" + nf(day(), 2) + " " + nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
  }

  // only for testing. Currently not in use.
  int verifyInt (int _value, int _altValue) {
    int __v = 0;
    try {
      __v = _value;
    }
    catch (Throwable e) {
      report (e, frameCount);
      //cabinet
      __v = _altValue;
    }
    //}
    return __v;
  }
}
