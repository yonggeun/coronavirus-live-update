class Timer {
  // cut is an ID for single sequence out of whole length cycle.
  // cut corresponds to a table row 
  int currentCut;
  int totalCuts;
  boolean changed;

  // cycle is a counter to show how many cycle has been played
  // cut corresponds to a whole data table
  int cycle;
  int cycleDurationMS;
  int cycleDuration;

  // interval is the duration of one single cut.
  float intervalDuration;
  int intervalDurationMS;

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
    if (millis() > 0) {
      // millis() returns negative when it exeeds interger boundry
      // Integers can be as large as 2,147,483,647 and as low as -2,147,483,648.
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

  void update() {
    getCutNow();
  }

  void onChanged() {
  }
}
