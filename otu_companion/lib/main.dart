import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'res/routes/routes.dart';
import 'res/values/theme.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error initializing firebase');
            return Text('Error initializing firebase');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'OTU Companion Hub',
              theme: Themes.mainAppTheme(),
              initialRoute: Routes.homeMain,
              onGenerateRoute: Routes.generateRoute,
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
