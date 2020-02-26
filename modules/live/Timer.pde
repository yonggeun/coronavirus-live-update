class Timer {
  // -------------------------  
  int currentCut;
  int interval;
  int totalSeconds = 0;  // second
  int totalCuts;
  int delay;
  boolean changed = false;
  boolean repetition = false;
  // -------------------------  frames
  int startFrame;
  float currentFrame;
  float totalFrames = 0;
  int timelineThickness = 30;
  float cutDurationInFrames;
  int fps;
  // -------------------------  
  int[][] cuesheet;
  // -------------------------  
  Timer  (String _duration, int _cuts, int _fps) {
    // _duration e.g. 3:50
    String[] __duration = split(_duration, ':');
    totalCuts = _cuts;
    //println("totalCuts : "+totalCuts);
    for (int i = 0; i<__duration.length; i++) {
      totalSeconds += int(int(__duration[__duration.length-1-i])*pow(60, i));
    }
    totalSeconds += delay;
    fps = _fps;
    interval = (totalSeconds) / totalCuts;
    totalFrames = totalSeconds * fps;
    cutDurationInFrames = ceil (totalFrames / totalCuts);
    startFrame = frameCount;
  }
  void getFramesNow () {
    float _r = 0;
    if (frameCount - startFrame < totalFrames) {
      _r = frameCount - startFrame;
    } else if (!repetition) {
      //println("done");
      _r = totalFrames;
    } else if (repetition) {
      _r = 0;
    }
    currentFrame = _r;
  }
  void getCutNow () {
    int _currentCut = currentCut;
    int _r = 0;
    if (frameCount - startFrame < totalFrames) {
      _r = frameCount - startFrame;
      currentCut = floor(_r/(cutDurationInFrames));
      //} else if (frameCount - startFrame >= totalFrames-1) {
    } else { 
      //println("done");
      currentCut = totalCuts-1;
    }
    if (_currentCut != currentCut) {
      changed = true;
      onChanged();
    } else {
      changed = false;
    }
    //println("currentCut : "+currentCut);
  }
  void update() {
    getCutNow();
    getFramesNow();
  }
  void onChanged() {
    println("changed", changed);
    println("currerntCut : " + currentCut);
  }

}
