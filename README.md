# xkcd-viewer
This is a simple app to read and browse through xkcd comics

## Getting Started

*All dependencies are already include in the source code, so if you only want to run the application you can just open `xkcd-viewer.xcworkspace`.*

Supported iOS ver. >= 12.0

### Installation

App dependencies can be installed by updating the `Podfile` and running:

```
pod install
```

## Tooling

### TinyConstraints

TinyConstraints is the syntactic sugar that makes Auto Layout sweeter for human use.. Installed using CocoaPods.

https://github.com/roberthein/TinyConstraints


## Completed Features

### User

A user is anyone who is using the phone and could open the application - there is no authentication and authorization to open and read the application. This also means that anyone with access to the phone could also see the user's favorite comics stored in the application


### Browse comics

User always sees the most recent comic when opening the app
User can navigate through comics using the buttons previous and next
User can jump to first/last comic using the corresponding buttons


### Search Comic

User can search for a text/comic number
If a number less than the number of the most recent comic is detected in the search keyword, the corresponding comic is loaded, otherwise the most relevant comic is loaded for the user depending on the searched keywords.

### Favorite Comic
User can favorite any comic by tapping on the star-icon on the top-right corner, and the id of the comic is stored on device till the user deletes the application.

### See Explanation
User can tap on the info-icon in front of the comic-title to read comic's explanation which opens in safari-controller
