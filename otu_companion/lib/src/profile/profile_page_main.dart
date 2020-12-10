import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:otu_companion/res/routes/routes.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';

class ProfilePageMain extends StatefulWidget
{
  ProfilePageMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfilePageMainState createState() => _ProfilePageMainState();
}

class _ProfilePageMainState extends State<ProfilePageMain>
{
  User _user;
  AuthenticationService _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context)
  {
    _user = _authenticationService.getCurrentUser();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MainSideDrawer(),
      body: Center(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildInfoContainer(context),
            Divider(thickness: 5,height: 1,),
            _buildChangeProfileInfoButton(context),
            _buildChangePasswordButton(context),

            // TODO: Implement 3rd-party account linking system
            //_buildLinkProfileButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(BuildContext context)
  {
    return Container(
      height: MediaQuery.of(context).size.height*0.3,
      margin: EdgeInsets.only(top:15,bottom:5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if(_user.photoURL != null)...[
            Padding(
              padding: EdgeInsets.only(bottom:15),
              child: CachedNetworkImage(
                imageUrl: _user.photoURL,
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
                    radius: 75,
                  );
                },
                imageBuilder: (context, imageProvider)
                {
                  return CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: 75,
                  );
                },
              ),
            ),
          ],
          if(_user.photoURL == null)...[
            Padding(
              padding: EdgeInsets.only(bottom:15),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 75,
              ),
            ),
          ],
          Text(
            _user.displayName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _user.email,
            style: TextStyle(
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChangeProfileInfoButton(BuildContext context)
  {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.changeProfileInfoPage).whenComplete((){
          setState(() {

          });
        });
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
                    FlutterI18n.translate(
                      context, "profilePageMain.buttonLabels.changeProfileInfo"),
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

  Widget _buildChangeEmailButton(BuildContext context)
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
                    FlutterI18n.translate(
                      context, "profilePageMain.buttonLabels.changeEmail"
                    ),
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


  Widget _buildLinkProfileButton(BuildContext context)
  {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.linkProfilePage);
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
                    "Link Account",
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

  showPasswordChangeDialog(BuildContext context)
  {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(
            FlutterI18n.translate(
              context, "profilePageMain.buttonLabels.resetPassword"
            ),
          ),
          content: Text(
            FlutterI18n.translate(
              context, "profilePageMain.buttonLabels.resetPasswordMessage"
            ),
          ),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                FlutterI18n.translate(
                  context, "profilePageMain.buttonLabels.cancel"
                )
              ),
            ),
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
                _authenticationService.updatePassword();
              },
              child: Text(
                FlutterI18n.translate(
                  context, "profilePageMain.buttonLabels.continue"
                )
              ),
            )
          ],
        );
      }
    );
  }

  Widget _buildChangePasswordButton(BuildContext context)
  {
    return InkWell(
      onTap: () {
        showPasswordChangeDialog(context);
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
                    FlutterI18n.translate(
                      context, "profilePageMain.buttonLabels.changePassword"
                    ),
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