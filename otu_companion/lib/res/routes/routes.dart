import 'package:flutter/material.dart';
import 'package:otu_companion/event_finder/event_finder_main.dart';
import 'package:otu_companion/room_finder/room_finder_main.dart';
import 'package:otu_companion/src/home_page/home_page_main.dart';

class Routes
{
  // Login

  // Home
  static const homeMain = "/homeMain";
  // Event Finder
  static const eventFinderMain = "/eventFinderMain";
  // Classroom Finder
  static const roomFinderMain = "/roomFinderMain";

  // Others

  static Route<dynamic> generateRoute(RouteSettings settings)
  {
    switch (settings.name)
    {
      case homeMain:
        return MaterialPageRoute(builder: (BuildContext context) =>
            HomePageMain(title: 'Dash Board'));
      case eventFinderMain:
        return MaterialPageRoute(builder: (BuildContext context) =>
            EventFinderMain(title: 'Event Finder'));
      case roomFinderMain:
        return MaterialPageRoute(builder: (BuildContext context) =>
            RoomFinderMain(title: 'Room Finder'));
    }

    return null;
  }
}