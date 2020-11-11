import 'package:flutter/material.dart';

class AppearanceSettingPage extends StatefulWidget
{
  AppearanceSettingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AppearanceSettingPageState createState() => _AppearanceSettingPageState();
}

class _AppearanceSettingPageState extends State<AppearanceSettingPage>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(

      ),
    );
  }
}