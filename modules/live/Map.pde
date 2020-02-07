class Map {
  PShape map;
  Map () {
  }
  void load (String L) {
    map = loadShape (L);
  }
  void render () {
    for (int i = 0; i < map.getChildCount(); ++i) {
      PShape ps = map.getChild(i);
      // Disable the colors found in the SVG file
      ps.disableStyle();
      s.trace("name ",ps.getName());
      // Set our own coloring
      fill(125);
      noStroke();
      // Draw a single state
      shape(ps, 0, 0, s.width, s.height);
    }
  }
}
