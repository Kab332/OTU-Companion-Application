import 'package:flutter/material.dart';
import 'event_finder/event_finder_main.dart';
import 'res/routes/routes.dart';
import 'res/values/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTU Companion Hub',
      theme: Themes.mainAppTheme(),
      initialRoute: Routes.homeMain,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
