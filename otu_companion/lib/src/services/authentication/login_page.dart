import 'package:flutter/material.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';
import 'package:otu_companion/res/routes/routes.dart';

class LoginPage extends StatefulWidget
{
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{
  final _formKey = GlobalKey<FormState>();
  AuthenticationService _authenticationService = AuthenticationService();

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _verification = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child:Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: <Widget>[
              //Logo - Header
              Container(
                height: MediaQuery.of(context).size.height * 0.29,
                child: Center(
                  child:Text(
                    "Welcome Back To OTU Companion App!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Divider(
                height: 30,
                thickness: 0,
              ),

              // Form Inputs
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child:_buildEmailField(),
                    ),
                    Divider(
                      height: 10,
                      thickness: 0,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: _buildPasswordField(),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 20,
                thickness: 0,
              ),

              // Buttons
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildSignUpButton(context),
                  _buildLoginWithEmailButton(context),
                ],
              ),

              Divider(
                height: 50,
                thickness: 0,
              ),

              // Other Login Options Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildLoginWithGoogleButton(context),
                  _buildLoginWithTwitterButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField()
  {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Email",
        icon: Icon(Icons.email),
        hintText:"Enter Email Address",
        border: const OutlineInputBorder(),
      ),
      controller: _email,
      validator: (String value) {
        if (value.isEmpty) {
          return "Email is required";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField()
  {
    return TextFormField(
      obscureText: true,
      obscuringCharacter: "*",
      decoration: const InputDecoration(
          labelText: "Password",
          icon: Icon(Icons.lock),
          hintText:"Enter Password",
          border: const OutlineInputBorder(),
      ),
      controller: _password,
      validator: (String value) {
        if (value.isEmpty) {
          return "Password is required";
        }
        return null;
      },
    );
  }

  Widget _buildLoginWithEmailButton(BuildContext context)
  {
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          _authenticationService.signInWithEmailAndPassword(
            email: _email.text,
            password: _password.text,
          ).then((verifying){
            _verification = verifying;
          }
          ).whenComplete((){
            if (_verification) {
              Navigator.pushReplacementNamed(context, Routes.homeMain);
            }
          });
        }
      },
      child:Container(
        child: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height* 0.1,
                width: MediaQuery.of(context).size.width * 0.45,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context)
  {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.signUpPage);
      },
      child:Container(
        child: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height*0.1,
                width: MediaQuery.of(context).size.width* 0.45,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoginWithGoogleButton(BuildContext context)
  {
    return InkWell(
      onTap: () {

      },
      child:Container(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.08,
              width: MediaQuery.of(context).size.width*0.45,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                ),
              ),
              child: Stack(
                children:<Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset('lib/res/images/icons/google_logo.png'),
                    ],
                  ),
                  Center(
                    child: Text(
                    "Google",
                    style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  Widget _buildLoginWithFacebookButton(BuildContext context)
  {
    return InkWell(
      onTap: () {

      },
      child:Container(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.08,
              width: MediaQuery.of(context).size.width*0.3,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF1877f2),
                borderRadius: BorderRadius.circular(8),
              ),
              child:  Stack(
                children:<Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset('lib/res/images/icons/facebook_logo.png'),
                    ],
                  ),
                  Center(
                    child: Text(
                      "Facebook",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
   */

  Widget _buildLoginWithTwitterButton(BuildContext context)
  {
    return InkWell(
      onTap: () {

      },
      child:Container(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.08,
              width: MediaQuery.of(context).size.width*0.45,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xff1DA1F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children:<Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right:18),
                        child: Image.asset(
                          'lib/res/images/icons/twitter_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Text(
                      "Twitter",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}