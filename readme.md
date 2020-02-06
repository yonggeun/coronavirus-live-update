## 1. Introduction

The Project implements a dashboard to display the real-time information of 2019 novel coronavirus through youtube live streaming.

### 1.1 Requirement
1. shows the number of cases, deaths from repective countries from the source [website](https://www.worldometers.info/coronavirus/countries-where-coronavirus-has-spread/).
2. displays the geographical transmission of the virus.
3. (if possible) accompanies the real-time updates from World Health Organization twitter in alphanumerical format.

### 1.2 Data source

 - Visualization

   - [Coronavirus 2019-nCoV Global Cases ](https://gisanddata.maps.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6) by [Johns Hopkins CSSE](https://systems.jhu.edu/research/public-health/ncov/)
   - [coronavirus-analysis@github](https://github.com/AaronWard/coronavirus-analysis)
   - World map
     - [Marked up SVG world map](https://github.com/benhodgson/markedup-svg-worldmap)@github

 - Live update data source
   - [Novel Coronavirus (2019-nCoV) Cases (Summary of Confirmed, deaths, and recovered cases)](https://docs.google.com/spreadsheets/u/1/d/1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM/htmlview?usp=sharing&sle=true#), provided by JHU CSSE
   - [Time series data of 2019 nCov (Google spreadsheet)](https://docs.google.com/spreadsheets/u/1/d/1UF2pSkFTURko2OvfHWWlFpDFAr1UxCBA4JLwlSP6KFo/htmlview?usp=sharing&sle=true#) from Johns Hopkins CSSE


## 2. Reference 

### 2.1 Basic dataflow and code
 - [Data@processing.org](https://processing.org/tutorials/data/) by Daniel Shiffman
    ```processing

    String runningtime;
    PImage poster;

    void setup() {
    size(300, 350);
    loadData();
    }

    void draw() {
    // Display all the stuff I want to display
    background(255);
    image(poster, 10, 10, 164, 250);
    fill(0);
    text("Shaun the Sheep", 10, 300);
    text(runningtime, 10, 320);
    }

    void loadData() {
    String url = "http://www.imdb.com/title/tt2872750/";

    // Get the raw HTML source into an array of strings (each line is one element in the array).
    // The next step is to turn array into one long string with join().
    String[] lines = loadStrings(url);
    String html = join(lines, "");

    String start = "";
    String end = "";
    runningtime = giveMeTextBetween(html, start, end); //Searching for running time.

    start = "";
    // Search for the URL of the poster image.
    String imgUrl = giveMeTextBetween(html, start, end);
    // Now, load that image!
    poster = loadImage(imgUrl);
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

    ```
- [Get JSON data using HTTP-Requests-for-Processing](https://github.com/runemadsen/HTTP-Requests-for-Processing/blob/master/examples/jsonget/jsonget.pde)
    ```processing

    import http.requests.*;

    public void setup() 
    {
        size(400,400);
        smooth();
        
    GetRequest get = new GetRequest("http://connect.doodle3d.com/api/list.example");
    get.send(); // program will wait untill the request is completed
    println("response: " + get.getContent());

    JSONObject response = parseJSONObject(get.getContent());
    println("status: " + response.getString("status"));
    JSONArray boxes = response.getJSONArray("data");
    println("boxes: ");
    for(int i=0;i<boxes.size();i++) {
        JSONObject box = boxes.getJSONObject(i);
        println("  wifiboxid: " + box.getString("wifiboxid"));
    }
    }

    ```
### 2.1 [Twitter developer platform](https://developer.twitter.com/en/docs/basics/getting-started)


### 2.2 Temboo twitter timeline
Temboo provides processing library to establish a communication between processing application and API from various sources on the web.

- [twitter timelines](https://temboo.com/library/Library/Twitter/Timelines/)
- [UserTimelineLatestTweet](https://temboo.com/library/Library/Twitter/Timelines/UserTimelineLatestTweet/)
- [UserTimeline](https://temboo.com/library/Library/Twitter/Timelines/UserTimeline/)