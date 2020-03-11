class Timer {
  int cycle;
  int cycleDurationMS;
  int cycleDuration;
  float intervalDuration;
  int intervalDurationMS;
  int currentCut;
  int totalCuts;
  Boolean changed;
  Timer (float _duration, int _cuts) {
    intervalDuration = 0;
    currentCut = 0;
    cycleDuration = 0;
    cycleDurationMS = 0;
    changed = false;
    totalCuts = _cuts;
    intervalDuration = _duration;
    intervalDurationMS = int(intervalDuration * 1000);
    cycleDurationMS = intervalDurationMS * totalCuts;
  }
  void getCutNow() {
    int ex_currentCut = currentCut;
    //println("cycleDurationMS : ",cycleDurationMS);
    if (millis() > 0) {
      cycle = floor(millis() / cycleDurationMS);
      currentCut = floor ((millis() % cycleDurationMS) / intervalDurationMS);
    } else {
      // in case that millis returns negative after the huge amount of the time.  
      int ms = millis() - 2147483647;
      cycle = floor(ms / cycleDurationMS);
      currentCut = floor ((ms % cycleDurationMS) / intervalDurationMS);
    }
    if (ex_currentCut != currentCut) {
      changed = true;
      onChanged();
    } else {
      changed = false;
    }
  }
  //println("currentCut : "+currentCut);  }
  void update() {
    getCutNow();
  }
  void onChanged() {
  }
}
