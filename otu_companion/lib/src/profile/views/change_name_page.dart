import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';

class ChangeNamePage extends StatefulWidget
{
  ChangeNamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChangeNamePageState createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage>
{
  final _formKey = GlobalKey<FormState>();
  AuthenticationService _authenticationService = AuthenticationService();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();

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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child:_buildFirstNameField(),
                ),
                Divider(
                  height: 10,
                  thickness: 0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: _buildLastNameField(),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget _buildFirstNameField()
  {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "First Name",
        icon: Icon(Icons.person),
        hintText:"Enter First Name",
        border: const OutlineInputBorder(),
      ),
      controller: _firstName,
      validator: (String value) {
        if (value.isEmpty) {
          return "Name is required";
        }
        return null;
      },
    );
  }

  Widget _buildLastNameField()
  {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Last Name",
        icon: Icon(Icons.person),
        hintText:"Enter Last Name",
        border: const OutlineInputBorder(),
      ),
      controller: _lastName,
      validator: (String value) {
        if (value.isEmpty) {
          return "Name is required";
        }
        return null;
      },
    );
  }
}