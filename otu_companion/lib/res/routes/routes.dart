import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:otu_companion/src/event_finder/event_finder_main.dart';
import 'package:otu_companion/src/event_finder/views/event_form.dart';
import 'package:otu_companion/src/event_finder/views/event_stats.dart';
import 'package:otu_companion/src/home_page/home_page_main.dart';
import 'package:otu_companion/src/profile/profile_page_main.dart';
import 'package:otu_companion/src/profile/views/change_profile_info_page.dart';
import 'package:otu_companion/src/profile/views/link_profile_page.dart';
import 'package:otu_companion/src/room_finder/room_finder_main.dart';
import 'package:otu_companion/src/settings/settings_main.dart';
import 'package:otu_companion/src/settings/views/appearance_settings_page.dart';
import 'package:otu_companion/src/settings/views/feed_back_page.dart';
import 'package:otu_companion/src/settings/views/about_page.dart';
import 'package:otu_companion/src/services/authentication/login_page.dart';
import 'package:otu_companion/src/services/authentication/views/login_checker_page.dart';
import 'package:otu_companion/src/services/authentication/views/sign_up_page.dart';
import 'package:otu_companion/src/chat/chat_main.dart';
import 'package:otu_companion/src/guides/guides_main.dart';
import 'package:otu_companion/src/guides/views/guides_form.dart';
import 'package:otu_companion/src/guides/views/guides_stats.dart';
import 'package:otu_companion/src/chat/views/addFriendPage.dart';
import 'package:otu_companion/src/chat/views/messagePage.dart';

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
  static const feedBackPage = "/feedBackPage";
  static const aboutPage = "/aboutPage";

  // Profile
  static const profileMain = "/profileMain";
  static const changeProfileInfoPage = "/changeProfileInfoPage";
  static const linkProfilePage = "/linkProfilePage";

  // Chat
  static const chatMain = "/chatMain";
  static const chatAddFriend = "/chatAddFriend";
  static const messagePage = "/messagePage";

  // Guides
  static const guidesMain = "/guidesMain";
  static const guidesForm = "/guidesForm";
  static const guidesStats = "/guideStats";

  // Others

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeMain:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                HomePageMain(title: FlutterI18n.translate(
            context, "routes.titles.dashboard")));
      case eventFinderMain:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                EventFinderMain(title: FlutterI18n.translate(
            context, "routes.titles.eventFinder")));
      case eventForm:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                EventFormPage(title: FlutterI18n.translate(
            context, "routes.titles.eventForm"), event: settings.arguments));
      case eventStats:
        return MaterialPageRoute(
            builder: (BuildContext context) => EventStats(title: FlutterI18n.translate(
                  context, "routes.titles.eventStats"),
                  userID: settings.arguments,
                ));
      case roomFinderMain:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RoomFinderMain(title: FlutterI18n.translate(
            context, "routes.titles.emptyRoomFinder")));
      case settingMain:
        return MaterialPageRoute(
            builder: (BuildContext context) => SettingMain(
              title: FlutterI18n.translate(
              context, "routes.titles.settings")));
      case appearanceSettingPage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                AppearanceSettingPage(title: FlutterI18n.translate(
            context, "routes.titles.appearance")));
      case feedBackPage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                FeedBackPage(title: FlutterI18n.translate(
            context, "routes.titles.feedback")));
      case aboutPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => AboutPage(title: FlutterI18n.translate(
            context, "routes.titles.about")));
      case profileMain:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ProfilePageMain(
                  title: FlutterI18n.translate(
                  context, "routes.titles.profile")));
      case changeProfileInfoPage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ChangeProfileInfoPage(title: FlutterI18n.translate(
            context, "routes.titles.changeProfileInfo")));
      case linkProfilePage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                LinkProfilePage(title: FlutterI18n.translate(
            context, "routes.titles.linkAccounts")));
      case loginPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginPage());
      case loginCheckerPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginCheckerPage());
      case signUpPage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                SignUpPage(title: FlutterI18n.translate(
            context, "routes.titles.accountCreation")));
      case chatMain:
        return MaterialPageRoute(
            builder: (BuildContext context) => ChatPage(
              title: FlutterI18n.translate(
              context, "routes.titles.messaging")));
      case guidesMain:
        return MaterialPageRoute(
            builder: (BuildContext context) => GuidesMain(
              title: FlutterI18n.translate(
              context, "routes.titles.guides")));
      case guidesForm:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                GuideFormPage(title: FlutterI18n.translate(
            context, "routes.titles.guidesForm"), guide: settings.arguments));
      case guidesStats:
        return MaterialPageRoute(
            builder: (BuildContext context) => GuideStats(
              title: FlutterI18n.translate(
                context, "routes.titles.guidesStats"),
              userID: settings.arguments,
                ));
      case chatMain:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                ChatPage(
                  title: FlutterI18n.translate(
                  context, "routes.titles.friends")));
      case chatAddFriend:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                AddFriendPage(
                  title: FlutterI18n.translate(
                  context, "routes.titles.addFriends")));
      case messagePage:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                MessagePage(
                  title: FlutterI18n.translate(
                  context, "routes.titles.friend")));
    }

    return null;
  }
}
