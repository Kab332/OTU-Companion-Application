import 'package:flutter/material.dart';
import 'package:otu_companion/src/event_finder/event_finder_main.dart';
import 'package:otu_companion/src/event_finder/views/event_form.dart';
import 'package:otu_companion/src/home_page/home_page_main.dart';
import 'package:otu_companion/src/profile/profile_page_main.dart';
import 'package:otu_companion/src/settings/settings_main.dart';
import 'package:otu_companion/src/settings/views/appearance_settings_page.dart';
import 'package:otu_companion/src/services/authentication/login_page.dart';
import 'package:otu_companion/src/services/authentication/views/login_checker_page.dart';

class Routes {
  // Login
  static const loginPage = "/loginPage";
  static const loginCheckerPage = "/loginCheckerPage";
  // Home
  static const homeMain = "/homeMain";
  // Event Finder
  static const eventFinderMain = "/eventFinderMain";
  static const eventForm = "/eventForm";
  // Classroom Finder

  // Settings
  static const settingMain = "/settingMain";
  static const appearanceSettingPage = "/appearanceSettingPage";

  // Profile
  static const profileMain = "/profileMain";

  // Others

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeMain:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                HomePageMain(title: 'Dash Board'));
      case eventFinderMain:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                EventFinderMain(title: 'Event Finder'));
      case eventForm:
          return MaterialPageRoute(
              builder: (BuildContext context) =>
                  EventFormPage(title: 'Event Form', event: settings.arguments));
      case settingMain:
        return MaterialPageRoute(
            builder: (BuildContext context) => SettingMain(title: 'Settings'));
      case appearanceSettingPage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                AppearanceSettingPage(title: 'Appearance'));
      case profileMain:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ProfilePageMain(title: 'Profile'));
      case loginPage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                LoginPage(title: 'Login'));
      case loginCheckerPage:
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              LoginCheckerPage());
    }

    return null;
  }
}
