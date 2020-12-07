import 'package:flutter/material.dart';
import 'package:otu_companion/src/event_finder/event_finder_main.dart';
import 'package:otu_companion/src/event_finder/views/event_form.dart';
import 'package:otu_companion/src/event_finder/views/event_stats.dart';
import 'package:otu_companion/src/home_page/home_page_main.dart';
import 'package:otu_companion/src/profile/profile_page_main.dart';
import 'package:otu_companion/src/profile/views/change_email_page.dart';
import 'package:otu_companion/src/profile/views/change_name_page.dart';
import 'package:otu_companion/src/profile/views/change_password_page.dart';
import 'package:otu_companion/src/profile/views/change_picture_page.dart';
import 'package:otu_companion/src/room_finder/room_finder_main.dart';
import 'package:otu_companion/src/settings/settings_main.dart';
import 'package:otu_companion/src/settings/views/appearance_settings_page.dart';
import 'package:otu_companion/src/services/authentication/login_page.dart';
import 'package:otu_companion/src/services/authentication/views/login_checker_page.dart';
import 'package:otu_companion/src/services/authentication/views/sign_up_page.dart';

class Routes {
  // Login
  static const loginPage = "/loginPage";
  static const loginCheckerPage = "/loginCheckerPage";
  static const signUpPage = "/signUpPage";
  // Home
  static const homeMain = "/homeMain";
  // Event Finder
  static const eventFinderMain = "/eventFinderMain";
  static const eventForm = "/eventForm";
  static const eventStats = "/eventStats";
  // Classroom Finder
  static const roomFinderMain = "/roomFinderMain";

  // Settings
  static const settingMain = "/settingMain";
  static const appearanceSettingPage = "/appearanceSettingPage";

  // Profile
  static const profileMain = "/profileMain";
  static const changeNamePage = "/changeNamePage";
  static const changeEmailPage = "/changeEmailPage";
  static const changePicturePage = "/changePicturePage";
  static const changePasswordPage = "/changePasswordPage";

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
      case eventStats:
        return MaterialPageRoute(
            builder: (BuildContext context) => EventStats(
                  title: 'Event Stats',
                  userID: settings.arguments,
                ));
      case roomFinderMain:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RoomFinderMain(title: 'Empty Room Finder'));
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
      case roomFinderMain:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RoomFinderMain(title: 'Empty Room Finder'));
      case changeNamePage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ChangeNamePage(title: "Change Name"));
      case changeEmailPage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ChangeEmailPage(title: "Change Email"));
      case changePasswordPage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ChangePasswordPage(title: "Change Password"));
      case changePicturePage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ChangePicturePage(title: "Change Picture"));
      case loginPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginPage());
      case loginCheckerPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginCheckerPage());
      case signUpPage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                SignUpPage(title: "Account Creation"));
    }

    return null;
  }
}
