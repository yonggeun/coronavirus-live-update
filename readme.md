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
     - [wikipedia:blank maps](https://en.wikipedia.org/wiki/Wikipedia:Blank_maps#World)
     - [Free World SVG Map from Simplemaps](https://simplemaps.com/resources/svg-world)
     - Exceptions
       - [Macau](https://en.wikipedia.org/wiki/Macau) : ISO 3166 code MO, (CN-MO)
       - [Hong Kong](https://lh3.googleusercontent.com/proxy/RWPRTF706iC6IwaIQDKudz1XD1AGF1hpR-p8rauRjqqIhNt18gcPCF7G5i0BhSRD8DvLvovJABfCSoYncq-TFBkBNqk36d1IAJNJ7qpKnL4YBL7I1R3UPM8_550OsHRSCuQ)
       - 

 - Live update data source
   - [Novel Coronavirus (2019-nCoV) Cases (Summary of Confirmed, deaths, and recovered cases)](https://docs.google.com/spreadsheets/u/1/d/1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM/htmlview?usp=sharing&sle=true#), provided by JHU CSSE
   - [Time series data of 2019 nCov (Google spreadsheet)](https://docs.google.com/spreadsheets/u/1/d/1UF2pSkFTURko2OvfHWWlFpDFAr1UxCBA4JLwlSP6KFo/htmlview?usp=sharing&sle=true#) from Johns Hopkins CSSE

## 2. Reference

### 2.1 [Twitter developer platform](https://developer.twitter.com/en/docs/basics/getting-started)


### 2.2 Temboo twitter timeline
Temboo provides processing library to establish a communication between processing application and API from various sources on the web.

- [twitter timelines](https://temboo.com/library/Library/Twitter/Timelines/)
- [UserTimelineLatestTweet](https://temboo.com/library/Library/Twitter/Timelines/UserTimelineLatestTweet/)
- [UserTimeline](https://temboo.com/library/Library/Twitter/Timelines/UserTimeline/)