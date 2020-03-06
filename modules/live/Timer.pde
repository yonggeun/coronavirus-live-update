class Timer {
  int cycle;
  int cycleDurationMS;
  int cycleDuration;
  float intervalDuration;
  int intervalDurationMS;
  int currentCut;
  int totalCuts;

  Boolean changed;
  // -------------------------  frames
  int startMS;
  float currentMS;
  float totalMS = 0;
  int fps;
  Timer (float _duration, int _cuts) {
    intervalDuration = 0;
    currentCut = 0;
    cycleDuration = 0;
    cycleDurationMS = 0;
    changed = false;
    totalCuts = _cuts;
    intervalDuration = _duration;
    //String[] __duration = split(_duration, ':');
    //for (int i = 0; i < __duration.length; i++) {
    //  intervalDuration += int(int(__duration[__duration.length-1-i])*pow(60, i));
    //}
    //println(cycleDuration);
    intervalDurationMS = int(intervalDuration * 1000);
    //cycleDurationMS = cycleDuration*1000;
    cycleDurationMS = intervalDurationMS * totalCuts;
    //intervalDurationMS = cycleDurationMS / totalCuts;
    startMS = millis();
  }
  void getCutNow() {
    int ex_currentCut = currentCut;
    //println("cycleDurationMS : ",cycleDurationMS);
    cycle = floor(millis() / cycleDurationMS);
    currentCut = floor ((millis() % cycleDurationMS) / intervalDurationMS);
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
