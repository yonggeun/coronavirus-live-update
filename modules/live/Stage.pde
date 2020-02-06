class Stage {
  int width;
  int height;
  float margin;
  int fps;
  int moduleW;
  int moduleH;
  StringDict system;
  StringDict path;
  String playMode;
  Boolean isRecording;
  Boolean isLogging;
  StringList log;
  Stage (int _w, int _fps, Boolean _ir, String _vault) {
    width  = _w;
    height = _w/16*9;
    fps = _fps;
    margin = height / 30;
    playMode = getPlayModeFrom (_w);
    isRecording = _ir;
    isLogging = false;
    log = new StringList();
    //
    system = new StringDict();
    system.set("name", System.getProperty("os.name"));
    system.set("arch", System.getProperty("os.arch"));
    system.set("version", System.getProperty("os.version"));
    system.set("username", System.getProperty("user.name"));
    system.set("started", getTimestamp());
    path = new StringDict();
    path.set("user", System.getProperty("user.dir"));
    path.set("home", System.getProperty("user.home"));
    path.set("file", getClass().getEnclosingClass().getName());
    path.set("sequence", path.get("home")+
      _vault + path.get("file")+
      "/"+playMode+"-"+system.get("started")+"/");
    path.set("screenshot", path.get("home")+
      _vault + path.get("file") +
      "/screenshot/");
    trace("00", path.get("file") + " Stage manger initiated.");
    trace("00", "capture path :\t" + path.get("sequence"));
    trace("00", "screenshot path :\t" + path.get("screenshot"));
  }
  void screenshot (KeyEvent _e, String _ext) {
    String _path;
    if (_e.getKeyCode() == 32 && !isRecording) {
      _path = path.get("screenshot")+playMode+"-"+getTimestamp()+" " +"########."+_ext;
      trace ("01", "Screenshot saved at " + path.get("screenshot")+playMode+"-"+getTimestamp()+" " +nf(frameCount, 8)+"."+_ext);
      saveFrame(_path);
    } else if (_e.getKeyCode() == 32 && isRecording) {
      trace("01", "Screenshot is unable to save since capturing is on gonig.");
    }
  }
  void capture (String _ext) {
    if (isRecording) {
      String _path = path.get("sequence")+"########."+_ext;
      saveFrame(_path);
      trace("01", "Recorder saved this frame at " + path.get("sequence") +nf(frameCount, 8)+"."+_ext);
    }
  }
  void trace(String _pNumber, String msg) {
    println(msg + " " + _pNumber + ". [" + nf(frameCount, 6) + "]");
    log.append(msg + " " + _pNumber + ". [" + nf(frameCount, 6) + "]");
  }
  void turnLog (Boolean _b) {
    if (_b) {
      isLogging = true;
    } else {
      isLogging = false;
    }
  }
  void render() {
    showLog ();
  }
  void showLog () {
    if (isLogging) {
      //println(log);
      String _output = "";
      ;
      for (int j = 0; j < log.size(); j++) {
        StringList _copied = log.copy();
        _copied.reverse();
        _output += "\n" + _copied.get(j);
      }
      //trim(_output);
      //colorMode(HSB, 360, 100, 100, 100); 
      
      textSize(10);
      fill(200);
      textAlign(RIGHT, BOTTOM);
      text(_output, -10, height/3*2 - 10, width, height/3);
    } else {
      // do nothing
    }
  }
  String getTimestamp() {
    String _return;
    _return = str(year())+"-" +str(month())+"-"+str(day())+ " " + nf(hour(), 2)+"-"+nf(minute(), 2);
    return _return;
  }
  String getPlayModeFrom (int _screenWidth) {
    String _playMode;
    switch (_screenWidth) {
      // 1280(test) 1920 (FHD) 3840(4k) 5120(5k)
    case 1280:
      _playMode = "TEST";
      break;
    case 1920:
      _playMode = "FHD";
      break;
    case 3840:
      _playMode = "4K";
      break;
    case 5120:
      _playMode = "5K";
      break;
    default:
      _playMode = "TEST";
      break;
    }
    return _playMode;
  }
}
