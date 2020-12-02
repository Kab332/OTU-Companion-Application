import 'package:flutter/material.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';
import 'package:otu_companion/res/routes/routes.dart';

class LoginPage extends StatefulWidget
{
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            //Logo
            Text("Welcome Back To OTU Companion App!"),

            // Form Inputs
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildEmailField(),
                  _buildPasswordField(),
                ],
              ),
            ),

            // Buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildLoginWithEmailButton(context),
                _buildSignUpButton(context),
                _buildLoginWithGoogleButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField()
  {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Email",
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
                height: MediaQuery.of(context).size.height/11,
                width: MediaQuery.of(context).size.width/1.25,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
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
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          _authenticationService.signUpWithEmailAndPassword(
            email: _email.text,
            password: _password.text,
          ).then((verifying){
            _verification = verifying;
          }
          ).whenComplete((){
            if (_verification) {
              print(_verification);
              Navigator.pushReplacementNamed(context, Routes.homeMain);
            }
          });
        }
      },
      child:Container(
        child: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height/11,
                width: MediaQuery.of(context).size.width/1.25,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
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
                height: MediaQuery.of(context).size.height/11,
                width: MediaQuery.of(context).size.width/1.25,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Login With Google",
                    style: TextStyle(
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
}