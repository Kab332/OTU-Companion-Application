import 'package:flutter/material.dart';
import 'package:otu_companion/src/home_page/home_page_main.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otu_companion/src/services/authentication/login_page.dart';

class LoginCheckerPage extends StatelessWidget {
  const LoginCheckerPage({Key key,}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    // Verify User Signed in
    User user = Provider.of<User>(context);
    if (user != null) {
      return HomePageMain(title: "Dash board",);
    }
    else {
      return LoginPage();
    }
  }
}