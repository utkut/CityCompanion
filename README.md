# MapKitTest

[![CodeFactor](https://www.codefactor.io/repository/github/utkut/mapkittest/badge)](https://www.codefactor.io/repository/github/utkut/mapkittest)

<img src="https://github.com/utkut/MapKitTest/blob/master/Images/ss1.png?raw=true" width="120" height="250" title="Main Screen"><img src="https://github.com/utkut/MapKitTest/blob/master/Images/ss2.png?raw=true" width="120" height="250" title="Main Screen"><img src="https://github.com/utkut/MapKitTest/blob/master/Images/ss3.png?raw=true" width="120" height="250" title="Main Screen"><img src="https://github.com/utkut/MapKitTest/blob/master/Images/ss4.png?raw=true" width="120" height="250" title="Main Screen">

This is an example app for iOS MapKit that practices annotations, routes, and other map capabilities. It is built for the city of Izmir, Turkey to mark several Tram stations and Bike Stations.

The app fetches the data from https://http://api.citybik.es/v2/ and decodes from JSON format. Shows available bikes, bike slots and status data.

This app is not affiliated with any governmental institution, or company. 

The code was written for personal/educational purposes on San Francisco State University
Does not infringe any conflict of interest with Apple Business Conduct 2020.


Changelog:
Initial Commit V.1.0.0

V1.0.1
Initialized Izmir Tram Stop Locations and Coordinates.

V.1.0.2
Added Lines between Stations for IZBAN Tram lines.
Added showRouteOnMap function to draw walking directions from one stop to another.

V.1.0.3
+ Added myLocation Clicked Button
+ Added moreDetail ViewController to provide depth and details to user when clicked on annotations.
+ Created UI for moreDetail
* Changed Names and subtitles
* Created a method to transfer "annotation.title" to moreDetail.
+ Initialized the data passing mechanism between moreDetail and ViewController to pass the data of the Station Name
* Optimized the code for bugfixes.

V.1.0.4

+ Added Support for a Search Bar
+ Added missing Apple Business Conduct notice.
+ Embedded in a NavigationController and TableViewController for future Search Bar implementation.
* Changed the NSLocationWhenInUseUsageDescription prompt String.

V.1.0.5

+ Added Live Refreshing BISIM Coverage with empty bike slots, free bikes, and status of the station.
* Changed the moreDetail UI

V.1.0.6

+ Added 3 BISIM Stations.
+ Added UI to show available bike data with status icons of the status and availability.
+ Bugfixed for JSONDecode.

V.1.0.7

+ Added Search Feature to find locations and places.
* Removed search bar and embedded it to the title for NavigationController.
* Implemented to drop a pin when an item selected from TableView.

V.1.0.8

+ Added SettingsViewController to optimize settings for scaling up data for different cities in the future.
+ Added cityPicker UIPicker to support multiple cities.
* Changed infoViewController button to SettingsViewController.
* Changed infoViewControlle segue to SettingsViewControllerSegue
* Changed info.plist to describe why location is needed more precisely.
