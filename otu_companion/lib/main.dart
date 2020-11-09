import 'package:flutter/material.dart';
import 'event_finder/event_finder_main.dart';
import 'res/routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTU Companion Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.homeMain,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
