import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';

class ChangePasswordPage extends StatefulWidget
{
  ChangePasswordPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
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