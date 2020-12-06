import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/res/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MainSideDrawer extends StatefulWidget
{
  MainSideDrawer({Key key}) : super(key: key);

  @override
  _MainSideDrawerState createState() => _MainSideDrawerState();
}

class _MainSideDrawerState extends State<MainSideDrawer>
{
  User _user;
  AuthenticationService _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context)
  {
    _user = Provider.of<User>(context);
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
                _buildDrawerHeader(context),
                _buildHomeTile(context),
                _buildProfileTile(context),
                _buildLogOutTile(context),
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

  Widget _buildDrawerHeader(BuildContext context)
  {
    return DrawerHeader(
      decoration: BoxDecoration(
        color:  Theme.of(context).primaryColor,
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                if(_user.photoURL != null)...[
                  CachedNetworkImage(
                    imageUrl: _user.photoURL,
                    progressIndicatorBuilder:(context, url, downloadProgress)
                    {
                      return CircularProgressIndicator(
                          value: downloadProgress.progress
                      );
                    },
                    errorWidget: (context, url, error)
                    {
                      return CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                      );
                    },
                    imageBuilder: (context, imageProvider)
                    {
                      return CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 50,
                      );
                    },
                  ),
                ],
                if(_user.photoURL == null)...[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                  ),
                ]
              ],
            ),
            Flexible(
              child:Container(
                margin: EdgeInsets.only(top:8, bottom:5,left:10, right:10),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    //TODO: Add Profile Name
                    _user.displayName,
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
        // Pop Side Menu
        Navigator.pop(context);
        // Pop Current Scaffold and Push Home Scaffold
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
        // Pop Side Menu
        Navigator.pop(context);
        // Pop Current Scaffold and Push Home Scaffold
        Navigator.popAndPushNamed(context, Routes.profileMain);
      },
    );
  }

  Widget _buildLogOutTile(BuildContext context)
  {
    return ListTile(
      title: Text('Log Out'),
      leading: Icon(Icons.exit_to_app),
      onTap: ()
      {
        _authenticationService.signOut();
        // Pop everything to login page
        Navigator.popAndPushNamed(context, Routes.loginPage);
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
        Navigator.popAndPushNamed(context, Routes.roomFinderMain);
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
        Navigator.popAndPushNamed(context, Routes.settingMain);
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