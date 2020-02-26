class Geometry {
  Boolean xray;
  Geometry() {
    xray = false;
  }
  float getRight (PShape s) {
    float right = 0;
    int vc = s.getVertexCount();
    for (int i = 0; i < vc; i++) {
      // println(i);
      right = (s.getVertex(i).x > right) ? s.getVertex(i).x : right;
    }
    //println ("right", right);

    return right;
  }
  float getLeft (PShape s) {
    float left = 0;
    //int vc = s.getVertexCount();
    //for (int j = 0; j < vc; j++) {
    //  // println(i);
    //  left = (s.getVertex(j).x > left) ? left : s.getVertex(j).x;
    //}
    ////println ("left", left);
    left = getRight(s) - s.getWidth();
    return left;
  }
  float getTop (PShape s) {
    float top = 0;
    //int vc = s.getVertexCount();
    //for (int k = 0; k < vc; k++) {
    //  // println(i);
    //  top = (s.getVertex(k).y < top) ? s.getVertex(k).y : top;
    //}
    ////println ("left", left);
    top = getBottom(s) - s.getHeight();
    return top;
  }
  float getBottom (PShape s) {
    float bottom = 0;
    int vc = s.getVertexCount();
    for (int k = 0; k < vc; k++) {
      // println(i);
      bottom = (s.getVertex(k).y > bottom) ? s.getVertex(k).y : bottom;
    }
    //println ("left", left);
    return bottom;
  }
  PVector getCentroid (PShape s) {
    // for polygon
    PVector centroid;
    float[] xray = new float[s.getVertexCount()];
    float[] yray = new float[s.getVertexCount()];
    float xsum = 0.0;
    float ysum = 0.0;
    for (int k = 0; k < s.getVertexCount(); k++) {
      //println(s.getVertex(k).x, s.getVertex(k).y);
      xray[k] = s.getVertex(k).x;
      yray[k] = s.getVertex(k).y;
      xsum += s.getVertex(k).x;
      ysum += s.getVertex(k).y;
    }
    centroid = new PVector (xsum/xray.length, ysum/yray.length);
    float xmax = max(xray);
    float xmin = min(xray);
    float ymax = max(yray);
    float ymin = min(yray);
    float rectSide = min(xmax-xmin, ymax-ymin);

    //shape(firstCell);
    //println(firstCell.width);
    return centroid;
    //
  }
}
