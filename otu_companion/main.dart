import 'package:flutter/material.dart';

import 'event_finder/event_finder_main.dart';

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
      home: MyHomePage(title: 'OTU Companion Hub'),
      routes: <String, WidgetBuilder>{
        '/eventFinderMain': (BuildContext context) =>
          EventFinderMain(title: 'Event Finder'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Event Finder'),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/eventFinderMain',
            );
          },
        ),
      ),
    );
  }
}
