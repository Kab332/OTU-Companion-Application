import 'package:flutter/material.dart';
import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';

class HomePageMain extends StatefulWidget
{
  HomePageMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageMainState createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MainSideDrawer(),
      body: Center(

      ),
    );
  }
}