# OTU Companion App

A companion app for OTU students.

> * [Event Finder](https://github.com/CSCI4100U/major-group-project-studio-wewanttopass/tree/room_finder/otu_companion#event-finder)
> * [Empty Room Finder](https://github.com/CSCI4100U/major-group-project-studio-wewanttopass/tree/room_finder/otu_companion#empty-room-finder)

# How to setup the project

### Requirements:

- Android SDK 29 or higher
- Use Android 10 (Q), Pixel 3a XL (Recommended)

### Steps:

1. Clone this repository to a location on your desktop.
2. Setup Flutter SDK.
3. Build the project using either Android Studios or VSCode.
    - Dependency Error: Go to `*/otu_companion/pubspec.yaml` and run the Pub get command.
4. Run the build.

# Front Page

## Login Feature (WIP, Not implemented)

## Dash Board

The __Dash Board__ acts as the central hub. Here the user will be able to access the many features the app will offer. Users will be shown recent news of registered events and saved empty-classrooms (WIP, skeleton-structure for now).

### Side-Bar / Drawer:

The Drawer attached to the dash board's AppBar will grant the user access to their __Profile__ (WIP), __Profile Menu__, __Event Finder__, __Classroom Finder__, __Guides__, __Chat System__ (WIP, not implemented, time permits) and joined __Groups and Events__ (WIP). The user will also be able to access the __Settings__ menu to configure how the app will operate (WIP, missing features before implementing): Appearance, Notification, Data Usage, Feed Back, About.

### Dash Board News (WIP):

Only the Skeleton structure is implemented. Waiting on __Accounts__, __Event Finder__, and __Classroom Finder__ features to implement. 

To access this feature, you can click the __Side-Bar__ and click on __Home__. 

You can interact with the feature by scrolling up and down.

## Profile (WIP)

Only the Skeleton structure is implemented. Waiting on __Accounts__ feature implementation. 

The profile page will allow the user to access secured forms to change to change an aspect of their account. 

To access this feature, click on the __Side-Bar__ and click __Profile__.

## Groups and Events (WIP)

## Settings (WIP)

Only the Skeleton structure is implemented. Waiting on __Event Finder__ and __Classroom Finder__ features implementation.

To Access this feature, click on the __Side-Bar__ and click __Settings__ 

A menu will appear with 5 different options: __Appearance__, __Notification__, __Data Usage__, __Feed Back__, __About__.

# Event Finder

## Description
The purpose of the Event Finder is to help users find club events happening around the university. Users can add events, edit events, delete events and find events created by other users. These events will be presented to the user, and they will be   able to manage and view events at their leisure. These events also have push notifications to let the user know how close the event date is coming. 

Currently, because the Event Finder is still in development, it functions more as an event planner in the sense that the user can only add, edit, or delete events and cannot “find” events from other users. Events are stored on the cloud, but are only accessible by the main user. 

## How to get to Event Finder
1. Begin by opening the OTU companion app.
2. Click the drawers on the top left and select Event Finder.

## How to interact with the Event Finder
Upon navigating to the event finder, a list of events will be displayed from the Firestore in the event box. If there are no events, then the database is empty, and it is up to the user to populate it with events. Our event finder supports the following main functions
  1. Add an event
  2. View event details
  3. Select an event
  4. Edit an event
  5. Delete an event
  6. Switch views

## Add an event
To add an event, the user can click on the “+” icon on the app bar in the top right corner, fill in the required information, then press the save icon in the bottom right. Tapping the save icon should bring the user back to the main list view, with the added event
## View event details
To view event details, in the main Event Finder view, click on the “eye” icon to quickly have the details pop up in a dialog for the user to see.

## Select an event 
To select an event, simply click the event in the list. A blue border will appear around the event you have selected.

## Edit an event
To edit an event, you will need to select the event first, otherwise an alert dialog will pop up asking for you to select an event first. Upon selecting an event, the user can tap the “edit” icon on the top right to edit the event. The button will take the user to the event form page, and allow them to edit the fields and save, which will bring them back to the main Event Finder view.

## Delete an event
To delete an event, first select the event and then click the trash can icon on the top right. If an event is not selected when the icon is clicked then an alert will pop up warning you of your mistake.

## Switch views
To switch view from list view to grid view or vice versa, press the switch view button. The current view is stored locally and will be retrieved when the program is reopened.

## Note: 
Notifications will show up based on the start date of the event. If the start date is within 24 hours then the notification will be sent instantly. If it is greater than 24 hours then the notification will be sent later on when there is 24 hours left until the start date.

# Empty Room Finder
A campus empty classroom finder 

## Purpose:
To help students find empty classrooms for studying, club events, etc.

## How to use:
Simply select a date & time or room and it'll show either what rooms are available at that date & time or what times that room is available.

How it works:
A python webscraper was made to crawl through the Available Courses preview collecting the occupied class time schedules and then the data was parsed to Firestore.
The client app reads the Firestore database and checks which rows are applicable to the search parameters.