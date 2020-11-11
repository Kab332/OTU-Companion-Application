import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/res/routes/routes.dart';

class MainSideDrawer extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.all(1),
              children: <Widget>[
                _buildDrawerHeader(),
                _buildHomeTile(context),
                _buildProfileTile(context),
                Divider(
                  thickness: 2,
                ),
                _buildEventTile(context),
                _buildRoomTile(context),
                _buildGuideTile(context),
                Divider(
                  thickness: 2,
                ),
                _buildGroupTile(context),
              ],
            ),
          ),
          Column(
            children:<Widget>[
              Divider(
                thickness: 2,
              ),
              _buildSettingsTile(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader()
  {
    return DrawerHeader(
      decoration: BoxDecoration(
        color:  Colors.blue,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            //TODO: Add Profile Icon
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35,
            ),
          ),
          Flexible(
            child:Container(
              margin: EdgeInsets.only(left:10, right:10),
              alignment: Alignment.centerLeft,
              child: Text(
                //TODO: Add Profile Name
                "Leon balogne",
                style: TextStyle(
                  fontSize: 18
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTile(BuildContext context)
  {
    return ListTile(
      title: Text('Home'),
      leading: Icon(Icons.home),
      onTap: ()
      {
        Navigator.popAndPushNamed(context, Routes.homeMain);
      },
    );
  }

  Widget _buildProfileTile(BuildContext context)
  {
    return ListTile(
      title: Text('Profile'),
      leading: Icon(Icons.account_box),
      onTap: ()
      {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildEventTile(BuildContext context)
  {
    return ListTile(
      title: Text('Event Finder'),
      leading: Icon(Icons.event),
      onTap: ()
      {
        Navigator.popAndPushNamed(context, Routes.eventFinderMain);
      },
    );
  }

  Widget _buildRoomTile(BuildContext context)
  {
    return ListTile(
      title: Text('Classroom Finder'),
      leading: Icon(Icons.room),
      onTap: ()
      {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildGuideTile(BuildContext context)
  {
    return ListTile(
      title: Text('Guides'),
      leading: Icon(Icons.menu_book),
      onTap: ()
      {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSettingsTile(BuildContext context)
  {
    return ListTile(
      title: Text('Settings'),
      leading: Icon(Icons.settings),
      trailing: Icon(Icons.nights_stay),
      onTap: ()
      {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildGroupTile(BuildContext context)
  {
    return ListTile(
      title: Text('Groups and Events'),
      trailing: Text('Edit'),
      onTap: ()
      {
        Navigator.pop(context);
      },
    );
  }
}