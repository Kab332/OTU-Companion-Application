import 'package:flutter/material.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';
import 'package:otu_companion/res/routes/routes.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SignUpPage extends StatefulWidget
{
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
{
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthenticationService _authenticationService = AuthenticationService();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordRe = TextEditingController();
  bool _disableButton = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: <Widget>[

              // Form Inputs
              Container(
                padding: EdgeInsets.only(top:30, bottom: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child:_buildFirstNameField(),
                      ),
                      Divider(
                        height: 10,
                        thickness: 0,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child:_buildLastNameField(),
                      ),
                      Divider(
                        height: 10,
                        thickness: 0,
                      ),
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
                      Divider(
                        height: 10,
                        thickness: 0,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: _buildPasswordReField(),
                      ),
                    ],
                  ),
                ),
              ),

              // Sign Up Button - Others
              _buildSignUpButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameField()
  {
    return TextFormField(
      decoration: InputDecoration(
        labelText: FlutterI18n.translate(
          context, "signUpPage.labelText.firstName"),
        icon: Icon(Icons.person),
        hintText: FlutterI18n.translate(
          context, "signUpPage.hintText.firstName"),
        border: const OutlineInputBorder(),
      ),
      controller: _firstName,
      validator: (String value) {
        if (value.isEmpty) {
          return FlutterI18n.translate(
          context, "signUpPage.isEmptyText.firstName");
        }
        return null;
      },
    );
  }

  Widget _buildLastNameField()
  {
    return TextFormField(
      decoration: InputDecoration(
        labelText: FlutterI18n.translate(
          context, "signUpPage.labelText.lastName"),
        icon: Icon(Icons.person),
        hintText: FlutterI18n.translate(
          context, "signUpPage.hintText.lastName"),
        border: const OutlineInputBorder(),
      ),
      controller: _lastName,
      validator: (String value) {
        if (value.isEmpty) {
          return FlutterI18n.translate(
          context, "signUpPage.isEmptyText.lastName");
        }
        return null;
      },
    );
  }

  Widget _buildEmailField()
  {
    return TextFormField(
      decoration: InputDecoration(
        labelText: FlutterI18n.translate(
          context, "signUpPage.labelText.email"),
        icon: Icon(Icons.email),
        hintText: FlutterI18n.translate(
          context, "signUpPage.hintText.email"),
        border: const OutlineInputBorder(),
      ),
      controller: _email,
      validator: (String value) {
        if (value.isEmpty) {
          return FlutterI18n.translate(
          context, "signUpPage.isEmptyText.email");
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
      decoration: InputDecoration(
        labelText: FlutterI18n.translate(
          context, "signUpPage.labelText.password"),
        icon: Icon(Icons.lock),
        hintText: FlutterI18n.translate(
          context, "signUpPage.hintText.password"),
        border: const OutlineInputBorder(),
      ),
      controller: _password,
      validator: (String value) {
        if (value.isEmpty) {
          return FlutterI18n.translate(
          context, "signUpPage.isEmptyText.password");
        }
        return null;
      },
    );
  }

  Widget _buildPasswordReField()
  {
    return TextFormField(
      obscureText: true,
      obscuringCharacter: "*",
      decoration: InputDecoration(
        labelText: FlutterI18n.translate(
          context, "signUpPage.labelText.rePassword"),
        icon: Icon(Icons.lock),
        hintText: FlutterI18n.translate(
          context, "signUpPage.hintText.rePassword"),
        border: const OutlineInputBorder(),
      ),
      controller: _passwordRe,
      validator: (String value) {
        if (value.isEmpty) {
          return FlutterI18n.translate(
          context, "signUpPage.isEmptyText.rePassword"
          );
        } else if (_password.text != value) {
          return FlutterI18n.translate(
            context, "signUpPage.doesNotMatch.rePassword"
          );
        }
        return null;
      },
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_formKey.currentState.validate() && _disableButton != true) {
          _disableButton = true;
          _formKey.currentState.save();
          _authenticationService.signUpWithEmailAndPassword(
            email: _email.text,
            password: _password.text,
            firstName: _firstName.text,
            lastName: _lastName.text
          ).then((errorMessage){
            if (errorMessage == null) {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, Routes.homeMain);
            }
            else
            {
              var snackbar = SnackBar(content: Text(errorMessage));
              _scaffoldKey.currentState.showSnackBar(snackbar);
            }
            _disableButton = false;
          });
        }
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height*0.08,
                width: MediaQuery.of(context).size.width*0.7,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    FlutterI18n.translate(
                      context, "signUpPage.buttonLabels.signUp"
                    ),
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
}