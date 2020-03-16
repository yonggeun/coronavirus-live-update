class Settings {
  processing.data.JSONObject list;
  boolean loaded = false;
  String url;
  Settings (String Link) {
    url = Link;
    loaded = load (url);
  }
  
  boolean load (String Link) {
    Boolean _loaded = false;
    list = loadJSONObject (Link);
    if (list == null) {
      _loaded = false;
    } else {
      _loaded = true;
    }
    return _loaded;
  }
  
  void reload() {
    loaded = load (url);
  }
  
  float getFloat(String S, float value) {
    float _result;
    if (list.isNull(S) == true) {
      _result = value;
    } else {
      _result = list.getFloat(S);
    }
    return _result;
  }
  
  String getString(String S, String value) {
    String _result;
    if (list.isNull(S) == true) {
      _result = value;
    } else {
      _result = list.getString(S);
    }
    return _result;
  }
  
  boolean getBoolean (String S, boolean value) {
    boolean _result;
    if (list.isNull(S) == true) {
      _result = value;
    } else {
      _result = boolean (list.getString(S));
    }
    return _result;
  }
}
