import 'package:flutter/material.dart';
import 'package:otu_companion/res/routes/routes.dart';

class MainSideDrawer extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(1),
        children: <Widget>[
          DrawerHeader(
            child: Text('Header'),
            decoration: BoxDecoration(
              color:  Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: ()
            {
              Navigator.pushNamed(context, Routes.homeMain);
            },
          ),
          ListTile(
            title: Text('Event Finder'),
            onTap: ()
            {
              Navigator.pushNamed(context, Routes.eventFinderMain);
            },
          ),
          ListTile(
            title: Text('Classroom Finder'),
            onTap: ()
            {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Guide'),
            onTap: ()
            {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}