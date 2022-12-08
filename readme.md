# Coronavirus World Map Live for Youtube Streaming

![screenshot](https://github.com/yonggeun/coronavirus-live-update/blob/master/screenshot/TEST-2020-3-16%2017-36%2000015934.PNG)

## 1. Introduction

The Project implements a dashboard to display the real-time information of 2019 novel coronavirus through youtube live streaming. [Watch the live stream first.](https://www.youtube.com/watch?v=oQbwgeEUL8k)

## 2. Purpose

1. To show the number of cases, deaths from repective countries from the source [website](https://www.worldometers.info/coronavirus/countries-where-coronavirus-has-spread/).
2. To display the geographical transmission of the virus.
3. (if possible) To accompany the real-time updates from World Health Organization twitter in alphanumerical format.

## 3. Installation

1. download processing IDE from [processing.org](https://processing.org/)
2. install the dependencies from [the contributed libraries](https://processing.org/reference/libraries/)
    - Ani.to library
    - HTTP Requests for Processing
3. install Twitter4j library following [the instruction](http://codigogenerativo.com/code/twitter-para-processing-2-0/)
4. You need to have google developer's key if you want to make this work online from google sheet data. Store this key as a single line key file. See Loader class for the detail.
5. You need to have twitter dev key to get notified over twitter direct message when any error or update is necessary. Store 4 keys from twitter dev account into a single line key file (semicolon-separated.) See Sentinel Class for the detail.

## 4. Data Source

1. This app reads data from my personal google sheet below. This google sheet fetches and  from [worldometer  corona virus real-time statastics](https://www.worldometers.info/coronavirus/). 
   1. [Google sheet file](https://docs.google.com/spreadsheets/d/17DPz5ivBsAl6_iL7qN2SupFj-LTi6h_oubMVkJrcDvA/edit?usp=sharing) : this is read-only file.
2. 

## 5. Related Data

 - Visualization
   - [Coronavirus 2019-nCoV Global Cases ](https://gisanddata.maps.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6) by [Johns Hopkins CSSE](https://systems.jhu.edu/research/public-health/ncov/)
   - [coronavirus-analysis@github](https://github.com/AaronWard/coronavirus-analysis)
   - mapbox
     - https://blog.mapbox.com/visualizing-the-progression-of-the-2019-ncov-outbreak-66763eb59e79
     - http://www.mapbox.cn/coronavirusmap

- World map
     - [Marked up SVG world map](https://github.com/benhodgson/markedup-svg-worldmap)@github
     - [wikipedia:blank maps](https://en.wikipedia.org/wiki/Wikipedia:Blank_maps#World)
     - [Free World SVG Map from Simplemaps](https://simplemaps.com/resources/svg-world) I use this version.
     - Due the the latest update in the names and borders of countries the attached SVG map file differs from the original version.

 - Live update data source
   - Primary sources
     - Coronavirus at [worldometers.info](https://www.worldometers.info/coronavirus/#countries)
     - [Novel Coronavirus (2019-nCoV) Cases (Summary of Confirmed, deaths, and recovered cases)](https://docs.google.com/spreadsheets/u/1/d/1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM/htmlview?usp=sharing&sle=true#), provided by JHU CSSE
     - Deprecated ~~[Time series data of 2019 nCov (Google spreadsheet)](https://docs.google.com/spreadsheets/u/1/d/1UF2pSkFTURko2OvfHWWlFpDFAr1UxCBA4JLwlSP6KFo/htmlview?usp=sharing&sle=true#)~~ from Johns Hopkins CSSE

## 5. Forthcoming

1. twitter trends
2. Progress graph for each territory

## 6. Credits

1. I appreciate the following sources and websites who enormously help to make this app possible. 
   1. for twitter dm source
      1. https://coderwall.com/p/yjim_a/sending-tweets-using-processing
   2. for git management
      1. https://gmlwjd9405.github.io/2018/05/17/git-delete-incorrect-files.html
   3. Computing a simple centroid of n-polygon
      1. https://neodreamer-dev.blogspot.com/2009/09/blog-post_0.html
   4. Fonts
      1. Thanks [Google fonts](https://fonts.google.com/). all is Roboto and its family. 
