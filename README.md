Simple Objective-C-App as part of Westpac interview
===============================================================

This is a *simple objective-c app* that demonstrates going back into the pre-arc (or archaic) days of manual memory management.

It does the following:
 - The app will fetch a JSON feed from server
 - Present a table view for news titles, and will switch to a web view for the news content when a cell row is selected.
 
 ##Additionally the app needs to:
  - Have a **Refresh** button on top left, and will refresh the news when pressed.
  - Should show/dismiss proper UI elements when loading contents from web.
  - Show the headLine from JSON feed as title, slugLine from JSON feed as subtitle in cell. 
    - The JSON feed may or may not have an image URL. If it does, download and display the image in cell; otherwise, text should take the empty space.
  - When a cell is tapped, switch to a web view that shows the HTML page of the desinated URL (the tinyUrl field in JSON).  
  - The news items are to be sorted by date, newest on top (check the dateLine field in JSON)

##The specification requirements also detail:
=====================


  - Deployment Target is iOS6
  - The app should run on iOS6.

  - App is Universal
    - The app is a Universal app that runs on iPhone and iPad (which means it is NOT 2x compatible mode for iPad). iPad version is a simple "streched out" version of iPhone version and no extra UI design is needed.

  - Lazy Load the Thumbnail Image
    - Thumbnail image (if any) should be lazy loaded, which means it is only loaded when it needs to be displayed.
  - App Should Support Landscape and Portrait

    - The app should support landscape and portrait orientations both on iPhone and iPad, and views should re- size accoardingly.

  - Only iOS6 or iOS7 SDK Should be Used

  - Please do NOT use third party libraries. Only iOS SDK lib should be used.

  - Do Not Use Automatic Reference Counting (ARC)

    - All memory management operations are manual.

  - Do Not Use XIB or Storyboard for Interface
    - All UI components are to be assembled in source code.



