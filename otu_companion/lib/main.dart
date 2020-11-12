import 'package:flutter/material.dart';
import 'res/routes/routes.dart';
import 'res/values/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    Themes theme = new Themes();
    theme.mainAppTheme();
    return MaterialApp(
      title: 'OTU Companion Hub',
      initialRoute: Routes.homeMain,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
