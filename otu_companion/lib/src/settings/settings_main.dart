import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:otu_companion/res/routes/routes.dart';

class SettingMain extends StatefulWidget
{
  SettingMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingMainState createState() => _SettingMainState();
}

class _SettingMainState extends State<SettingMain>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          _buildAppearanceTile(context),
          //_buildNotificationTile(context),
          //_buildDataUsageTile(context),
          _buildFeedBackTile(context),
         // _buildAboutTile(context),
        ],
      ),
    );
  }

  Widget _buildAppearanceTile(BuildContext context)
  {
    return ListTile(
      title: Text(
        FlutterI18n.translate(
          context, "settingsMain.buttonLabels.appearance"
        )
      ),
      leading: Icon(Icons.palette),
      onTap: ()
      {
        Navigator.pushNamed(context, Routes.appearanceSettingPage);
      },
    );
  }

  Widget _buildNotificationTile(BuildContext context)
  {
    return ListTile(
      title: Text(
        FlutterI18n.translate(
          context, "settingsMain.buttonLabels.notifications"
        )
      ),
      leading: Icon(Icons.notifications),
    );
  }


  Widget _buildDataUsageTile(BuildContext context)
  {
    return ListTile(
      title: Text(
        FlutterI18n.translate(
          context, "settingsMain.buttonLabels.dataUsage"
        )
      ),
      leading: Icon(Icons.insert_chart),
    );
  }

  Widget _buildFeedBackTile(BuildContext context)
  {
    return ListTile(
      title: Text(
        FlutterI18n.translate(
          context, "settingsMain.buttonLabels.feedback"
        )
      ),
      leading: Icon(Icons.feedback),
      onTap: (){
        Navigator.pushNamed(context, Routes.feedBackPage);
      },
    );
  }

  Widget _buildAboutTile(BuildContext context)
  {
    return ListTile(
      title: Text(
        FlutterI18n.translate(
          context, "settingsMain.buttonLabels.about"
        )
      ),
      leading: Icon(Icons.info),
      onTap: (){
        Navigator.pushNamed(context, Routes.aboutPage);
      },
    );
  }
}