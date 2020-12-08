import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangeProfileInfoPage extends StatefulWidget
{
  ChangeProfileInfoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChangeProfileInfoPageState createState() => _ChangeProfileInfoPageState();
}

class _ChangeProfileInfoPageState extends State<ChangeProfileInfoPage>
{
  final _formKey = GlobalKey<FormState>();
  AuthenticationService _authenticationService = AuthenticationService();

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _pictureURL = TextEditingController();
  String _urlString;
  User _user;

  @override
  void initState() {
    // Initialize Pre-existing User Values
    List<String> initFullName;
    _user = _authenticationService.getCurrentUser();
    initFullName = _user.displayName.split(" ");

    if (initFullName != null && initFullName.length == 2)
    {
      _firstName.text = initFullName[0];
      _lastName.text = initFullName[1];
    }
    if (_user.photoURL != null)
    {
      _pictureURL.text = _user.photoURL;
      _urlString = _user.photoURL;
    }
    else {
      _urlString = "";
    }

    super.initState();
  }

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
            children: <Widget>[

              // Form Inputs
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Divider(
                      height: 10,
                    ),
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
                      child: _buildLastNameField(),
                    ),
                    Divider(
                      height: 10,
                      thickness: 0,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: _buildPictureField(),
                    ),
                  ],
                ),
              ),

              // Avatar Image
              _buildUpdateAvatarButton(),
              _buildAvatarImage(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: (){
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              _authenticationService.updateProfile(
                name: _firstName.text.split(" ")[0] + " " + _lastName.text.split(" ")[0],
                imageURL: _pictureURL.text,
                context: context,
              ).whenComplete(
                (){
                  Navigator.pop(context);
                }
              );

            }
          },
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

  Widget _buildPictureField()
  {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Picture Url",
        icon: Icon(Icons.person),
        hintText:"Enter URL",
        border: const OutlineInputBorder(),
      ),
      controller: _pictureURL,
      validator: (String value) {
        if (value.isEmpty) {
          return "URL is required";
        }
        return null;
      },
    );
  }

  Widget _buildUpdateAvatarButton()
  {
    return RaisedButton(
      onPressed: (){
        setState(() {
          _urlString = _pictureURL.text;
        });
      },
      child: const Text(
        "Update Avatar",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildAvatarImage()
  {
    return CachedNetworkImage(
      imageUrl: _urlString,
      progressIndicatorBuilder:(context, url, downloadProgress)
      {
        return CircularProgressIndicator(
            value: downloadProgress.progress
        );
      },
      errorWidget: (context, url, error)
      {
        return CircleAvatar(
          backgroundColor: Colors.black,
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
    );
  }
}