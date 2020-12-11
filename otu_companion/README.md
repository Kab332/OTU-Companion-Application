# OTU Companion App

A companion app for OTU students.

### Notes:

This app uses [Firebase](https://firebase.google.com/) for user authentication,

> * [Event Finder](https://github.com/CSCI4100U/major-group-project-studio-wewanttopass/tree/master/otu_companion#event-finder)
> * [Empty Room Finder](https://github.com/CSCI4100U/major-group-project-studio-wewanttopass/tree/master/otu_companion#empty-room-finder)

For the Room Finder, Minh Huynh did a lot of pair programming with Aron-Seth Cohen.

# How to setup the project

### Requirements:

- Android SDK 29 or higher
- Use Android 10 (Q), Pixel 3a XL (Recommended)

### Steps:

1. Clone this repository to a location on your desktop.
2. Setup Flutter SDK.
3. Build the project using either Android Studios or VSCode.
    - Dependency Error: Go to `*/otu_companion/pubspec.yaml` and run the Pub get command.
4. Run the build in __non-debug mode__.

# Features

## Login Feature 

The __Login__ page will be the first page that greets the user who is new or have signed out. Its purpose is to help the system identify the different users and store their data. After registering or signing in, the user will move into the __Dash Board__. 

__Notes:__ Any invalid inputs will return an error message back to the user in the form of a snackbar.

### Login:

The login page allows pre-existing users to sign into their accounts, by inputting their email and password.

### Sign Up:

The sign up page allows the user to register a new account into the system. The user may access this page by clicking the __Create Account__ button in the __Login__ page.

## Navigation Drawer:

This drawer may be accessed in the majority of the feature’s AppBar as well as signing out of their accounts. It grants the user access to their __Profile__, __Event Finder__, __Classroom Finder__, and  __Guides__ features. The user will also be able to access the __Settings__ menu.

## Dashboard

The __Dash Board__ acts as the central hub. Here the user will be able to access the many features the app will offer. Users will be shown recent news of registered events.

## Profile

The profile page will allow the user to view different actions to change their account information.

### Change Profile Info:

This page allows users to change and update their name and profile picture.

### Change Password:

This button will inform the user that the system will send an email to confirm a password reset, before sending an email.

## Settings

The settings page allows the user to access the feedback option.

### Feedback

Users are able to write and send feedback for the app.

# Event Finder

![](https://github.com/CSCI4100U/major-group-project-studio-wewanttopass/blob/master/sample_images/event_finder_calendar_view_sample.png)
![](https://github.com/CSCI4100U/major-group-project-studio-wewanttopass/blob/master/sample_images/event_form_sample.png)
![](https://github.com/CSCI4100U/major-group-project-studio-wewanttopass/blob/master/sample_images/event_stats_sample.png)

## Description
The purpose of the Event Finder is to help users find club events happening around the university. Users can add, edit, delete, and find events created by other users. These events will be presented to the user, and they will be able to manage and view events at their leisure. These events also have push notifications to let the user know when the event is approaching. 

## How to get to Event Finder
1. Sign in to your account.
2. Click the drawers on the top left and select Event Finder.

## How to interact with the Event Finder
Upon navigating to the event finder, a list of events will be displayed from the Firestore in the event box. If there are no events, then the database is empty, and it is up to the user to populate it with events. Our event finder supports the following main functions
  1. Add an event
  2. Join an event
  3. Leave an event
  4. View event details
  5. Select an event
  6. Edit an event
  7. Delete an event
  8. Switch views
  9. Form buttons
  10. View chart for joined events
  11. View chart for all events

## Features

### Add an event
To add an event, tap on the "All Events" button and click on the “+” icon on the app bar in the top right corner. You will be taken to the “Event Form” page and will need to fill in the required information, then press the save icon in the bottom right. Tapping the save icon should bring the user back to the main list view, with the added event **NOTE: When joining an event, "+" means that you can join the event, one person icon means that you created the event, two person icon means that you are already in that event.**

### Join an event
To join an event, tap on the "All Events" button and click on the "+" icon next to the event. For the calendar view, you will need to select a day first. Then, you can select the "+" icon for the events you want to join, from the scrollable list of events for that day. **NOTE: You can only join events that you did not create. If you are the creator of the event, you are automatically joined.

### Leave an event
To leave an event, tap on the "Joined Events" button and click on the red "-" icon next to the event. For calendar view, you will need to select a day first. Then, you can select the "-" icon for the events you want to leave, from the scrollable list of events for that day **NOTE: You can only leave events that you did not create. If you are the creator of the event, you cannot leave the event.

### View event details
To view event details click on the “eye” icon to quickly have the details pop up in a dialog for the user to see.

### Select an event 
To select an event, simply click the event in the list, table or calendar. A blue border will appear around the event you have selected.

### Edit an event
To edit an event, tap on the "All Events" button and then you will need to select the event, otherwise an alert dialog will pop up asking for you to select an event first. Upon selecting an event, the user can tap the “edit” icon on the top right to edit the event. The button will take the user to the event form page, and allow them to edit the fields and save, which will bring them back to the main Event Finder view. If the option is greyed out, it's because only the user who created that event can edit it, every other user can only view or join the event. 

### Delete an event
To delete an event, tap on the "All Events" button, select the event and then click the trash can icon on the top right. If an event is not selected when the icon is clicked then an alert will pop up warning you of your mistake. If the option is greyed out, it's because only the user who created that event can delete it, every other user can only view or join the event. 

### Switch views
To switch views, tap the corresponding buttons for the view you would like. Calendar, list or table view to switch to the corresponding view. The current view is stored locally and will be retrieved when the program is reopened. In calendar view, you are able to switch the view to show only one week, two weeks or one month. In table view, the table is draggable so that you can view all the details.

To switch views between joined events and all events, tap the corresponding buttons. 

### Form buttons
The event form has 4 special buttons that affect the map inside it.

#### Check Location
This button gets the latitude and longitude for the address in the location field and uses it to display a marker on a map. If a new location is entered then this button must be pressed to check the location. 
#### Zoom in 
This button has a magnifying glass with a plus icon. It zooms into the map.

#### Zoom out 
This button has a magnifying glass with a minus icon. It zooms out of the map.

#### Get my location 
This is the button with the crosshairs like icon, it is below zoom out. This button gets your current location, automatically enters its postal code into the location form field, and shows the location on the map. This may take a few seconds to load, and it requires the user to have allowed locations on the device to function.

### View chart for joined events 
To view joined event chart statistics, tap the "Joined Events'' icon, then tap the chart icon in the top right corner. From there, you can analyze the chart based on the number of participants in the event to the corresponding event.

### View chart for all events
To view chart statistics for all events, tap the "All Events'' icon, then tap the chart icon in the top right corner. From there, you can analyze the chart based on the number of participants in the event to the corresponding event.

## Note: 
Notifications will show up based on the start date of the event. If the start date is within 24 hours then the notification will be sent instantly. If it is greater than 24 hours then the notification will be sent later on when there is 24 hours left until the start date. 

In calendar view, when you click on a specific date, you can click on the buttons created from selecting that day.

In form end DateTime can be lower than start DateTime even if the form shows that they have the same values. This is because DateTime’s compareTo function considers milliseconds (and micro) and when we initialize with DateTime.now() we have milliseconds but when we select a time it is set to 0. 

# Empty Room Finder
A campus empty classroom finder 

## Purpose:
To help students find empty classrooms for studying, club events, etc.

## How to use:
To find a list of rooms at a specified time:
Select a day, the start time, and the end time.
Optionally select a building to limit the list of rooms to a specific building (To switch, press the x beside the buildings dropdown to clear the previous selection before selecting a new building)
Click confirm
To find a list of times at a specified room:
Simply just select a room from the rooms dropdown list

## How it works:
A python webscraper was made to crawl through the Available Courses preview collecting the occupied class time schedules and then the data was parsed to find the empty class time schedules. That db is then saved locally as a pre-made asset for the app so the user can use the room finder tool offline. After that, its simply a matter of getting the users input to query through the db and return the right query. For the list of free times, the return is every 10 minute interval from 8am to 9:30pm, times between 9:30pm to 8am are not included as those time slots are inherently free as classes are not allowed to scheduled at those times.

# Guides

![](https://github.com/CSCI4100U/major-group-project-studio-wewanttopass/blob/master/sample_images/guides_view_sample.png)
![](https://github.com/CSCI4100U/major-group-project-studio-wewanttopass/blob/master/sample_images/guides_form_sample.png)
![](https://github.com/CSCI4100U/major-group-project-studio-wewanttopass/blob/master/sample_images/guides_chart_sample.png)


## Description
The purpose of Guides is to allow users to post useful guides and tips about things happening around the university. Users can add, edit and delete guides and vote on guides created by other users. These guides will be presented to the user, and they will be able to manage and view guides at their leisure. Guides is mostly a lesser version of the event finder, with the only new functionality being votes, but we included it because it was in our original design. 

## How to get to Guides
1. Sign in to your account.
2. Click the drawers on the top left and select Guides.

## How to interact with Guides
Upon navigating to the guides, a list of guides will be displayed from the Firestore in the guide box. If there are no guides, then the database is empty, and it is up to the user to populate it with guides. Our guides supports the following main functions

  1. Submit a guide
  2. Select a guide
  3. Edit a guide
  4. Delete a guide
  5. Vote on a guide
  6. View guide details
  7. View chart for all guides 

## Submit a guide
To add a guide click on the “+” icon on the app bar in the top right corner. You will be taken to the “Guides Form” page and will need to fill in the required information, then press the save icon in the bottom right. Tapping the save icon should bring the user back to the main list view, with the added guide. 

## Select a guide
To select a guide, simply click the guide in the list. A blue border will appear around the guide you have selected.

## Edit a guide
To edit a guide, the user needs to select a guide first. Then, the user can tap the “edit” icon on the top app bar to edit the guide. The button will take the user to the guides form page, and allow them to edit the fields and save, which will bring them back to the main Guides view. **NOTE: If the option is greyed out, it's because only the user who created that guide can edit it. **

## Delete a guide
To delete a guide, select the guide that you created and then click the trash can icon on the top app bar. If a guide is not selected when the icon is clicked then an alert will pop up warning you of your mistake. **NOTE: If the option is greyed out, it's because only the user who created that guide can delete it.**

## Vote on a guide
To vote on a guide, click on the up arrow to give it an up vote (orange) and on the down arrow to give it a down vote (blue). If you have already given it a vote then clicking it again will undo that vote. If you have given an up vote and click down vote or vice versa, then your vote will switch to the one you last clicked. 

## View guide details
To view guide details, click on the “book” icon to have the details pop up in a dialog for the user to see.

## View chart for all guides
To view chart statistics for all guides, tap the chart icon in the top right corner of the app bar. From there, you can analyze the chart based on the number of upvotes and downvotes for each guide.
