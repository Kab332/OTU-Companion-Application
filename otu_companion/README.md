# Empty Room Finder
A campus empty classroom finder 

# Purpose:
To help students find empty classrooms for studying, club events, etc.

# How to use:
Simply select a date & time or room and it'll show either what rooms are available at that date & time or what times that room is available.

How it works:
A python webscraper was made to crawl through the Available Courses preview collecting the occupied class time schedules and then the data was parsed to Firestore.
The client app reads the Firestore database and checks which rows are applicable to the search parameters.
