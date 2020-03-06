//String spreadsheetId = "1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM";
//String spreadsheetId = "1qa-nSAq4Y_yn_MN3-cjMIs8qxtwnUNtg-xIvtMB-gtU";
//testing url
//https://sheets.googleapis.com/v4/spreadsheets/1qa-nSAq4Y_yn_MN3-cjMIs8qxtwnUNtg-xIvtMB-gtU/values/A1:H1000?key=AIzaSyASvrZTZGWJY73zXxSU98v6eAvcsFjaRBw
class Zote {
  Zote () {
  }
  //timerOld () {
  //  class Timer {
  //    // -------------------------  
  //    int currentCut;
  //    int interval;
  //    int totalSeconds = 0;  // second
  //    int totalCuts;
  //    int delay;
  //    int cycle;
  //    boolean changed = false;
  //    boolean repetition = false;
  //    // -------------------------  frames
  //    int startFrame;
  //    float currentFrame;
  //    float totalFrames = 0;
  //    int timelineThickness = 30;
  //    float cutDurationInFrames;
  //    int fps;
  //    // -------------------------  
  //    int[][] cuesheet;
  //    // -------------------------  
  //    Timer  (String _duration, int _cuts, int _fps) {
  //      // _duration e.g. 3:50
  //      String[] __duration = split(_duration, ':');
  //      totalCuts = _cuts;
  //      //println("totalCuts : "+totalCuts);
  //      for (int i = 0; i<__duration.length; i++) {
  //        totalSeconds += int(int(__duration[__duration.length-1-i])*pow(60, i));
  //      }
  //      totalSeconds += delay;
  //      fps = _fps;
  //      interval = (totalSeconds) / totalCuts;
  //      totalFrames = totalSeconds * fps;
  //      cutDurationInFrames = ceil (totalFrames / totalCuts);
  //      startFrame = frameCount;
  //      cycle = 0;
  //    }
  //    void getFramesNow () {
  //      float _r = 0;
  //      if (frameCount - startFrame < totalFrames) {
  //        _r = frameCount - startFrame;
  //      } else {
  //        if (repetition == false) {
  //          println("done");
  //          _r = totalFrames;
  //        } else if (repetition == true) {
  //          println("repeat");
  //          _r = totalFrames;
  //        }
  //      } 
  //      currentFrame = _r;
  //    }
  //    void getCutNow () {
  //      int _currentCut = currentCut;
  //      int _r = 0;
  //      if (frameCount - startFrame < totalFrames) {
  //        _r = frameCount - startFrame;
  //        currentCut = floor(_r/(cutDurationInFrames));
  //        //} else if (frameCount - startFrame >= totalFrames-1) {
  //      } else { 
  //        //println("done");
  //        currentCut = totalCuts-1;
  //      }
  //      if (_currentCut != currentCut) {
  //        changed = true;
  //        onChanged();
  //      } else {
  //        changed = false;
  //      }
  //      //println("currentCut : "+currentCut);
  //    }
  //    void update() {
  //      getCutNow();
  //      getFramesNow();
  //    }
  //    void onChanged() {
  //      println("changed", changed);
  //      println("currerntCut : " + currentCut);
  //    }
  //  }
  //}
  // county bounding box based on the size of today's new case
  //fill(0, 0, 100, 100);
  //    strokeWeight(0);
  //    stroke(0, 0, 100, 100);
  //    float side = map(table.getRow(_now).getInt(2), 0, toll[2], 0, cell);
  //    rect(bboxX-cell/2, bboxY-cell/2, -side, side);
  
}
