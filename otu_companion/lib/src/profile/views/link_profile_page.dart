import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';

class LinkProfilePage extends StatefulWidget
{
  LinkProfilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LinkProfilePageState createState() => _LinkProfilePageState();
}

class _LinkProfilePageState extends State<LinkProfilePage>
{
  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child:Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: <Widget>[]
          ),
        ),
      ),
    );
  }
}