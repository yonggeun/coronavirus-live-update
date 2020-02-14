StringDict tags;

void setup () {
  String[] lines = loadStrings("https://www.worldometers.info/coronavirus/");
  String html = join(lines, "");
  //saveStrings ("downloaded.txt", html);
  //String[] updated = match(html, "Last updated:(.+ GMT)<\\/div>");
  //println (updated[1]);
  //last update
  
  tags

  println (giveMeTextBetween(html, "Last updated: ", "GMT</div><div" ));

  println (giveMeTextBetween(html, "<h1>Coronavirus Cases:</h1> <div class=\"maincounter-number\"> <span style=\"color:#aaa\">", "</span></div></div>" ));

  println (giveMeTextBetween(html, "Deaths:</h1> <div class=\"maincounter-number\"> <span>", "</span> </div></div> <div ");




  println (giveMeTextBetween(html, "", "");
}



String giveMeTextBetween(String s, String before, String after) {

  // This function returns a substring between two substrings (before and after).
  //  If it can’t find anything it returns an empty string.
  String found = "";

  // Find the index of before
  int start = s.indexOf(before);     
  if (start == -1) {
    return "";
  }    

  // Move to the end of the beginning tag
  // and find the index of the "after" String      
  start += before.length();    
  int end = s.indexOf(after, start); 
  if (end == -1) {
    return "";
  }

  // Return the text in between
  return s.substring(start, end);
}
