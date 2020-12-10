import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key, this.title}) : super(key: key);

  final String title;

  _AboutPageState createState() => _AboutPageState();
}
class _AboutPageState extends State<AboutPage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:"About Our App:",
                style: TextStyle(

                ),
              ),
              TextSpan(
                text: "Github Project Repo.",
                style: TextStyle(

                ),
                recognizer: TapGestureRecognizer()
                ..onTap = () async{
                  final url = "https://github.com/CSCI4100U/major-group-project-studio-wewanttopass";
                  if (await canLaunch(url)) {
                    launch(url);
                  }
                },
              )
            ],
          ),
        ),
      )
    );
  }
}