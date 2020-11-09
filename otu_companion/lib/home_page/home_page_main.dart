import 'package:flutter/material.dart';

class HomePageApp extends StatefulWidget
{
  HomePageApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageAppState createState() => _HomePageAppState();
}

class _HomePageAppState extends State<HomePageApp>
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: widget.title,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
    );
  }
}