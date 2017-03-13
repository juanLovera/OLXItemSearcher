# OLX Item Searcher
This iPhone app shows publications and items from OLX's public API. It's highly customizable, so it can be configured to consume another API in just a few steps.

# Features
* Favorites list: users can add items to its Favorites list and check them out later.

* Offline mode: all items added to user's Favorites list will be persisted, so they will be available to check even if there's no internet connection.

* Infinite scrolling: search has infinite scrolling pagination.

* Pull to refresh: search has pull to refresh.

* Portrait & Landscape: screens in app were designed to work in all sizes and orientations.

* Items details: tapping in an item or publication will show more details about it.

* Highly customizable and maintainable code.

# Requirements
Swift 3  
XCode 8  
iOS 9+  
NOTE: Open .xcworkspace instead of the .xcodeproj file, so dependencies can be fully accessible.

# Some technical details

* CoreData is used for persistent data.

* Code style and conventions follows Ray Wenderlich Swift Style Guide: https://github.com/raywenderlich/swift-style-guide

* Cocoapods is used for dependencies.

* API consumption is in charge of Service class, which has all default behaviors and functions to do requests, handle responses and control UI flows. Each child of this class represents one service endpoint and can override super methods to customize any behavior related to networking. Please see Class/Service.swift for more information.
