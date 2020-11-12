import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';

class ProfilePageMain extends StatefulWidget
{
  ProfilePageMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfilePageMainState createState() => _ProfilePageMainState();
}

class _ProfilePageMainState extends State<ProfilePageMain>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
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
            _buildChangeNameButton(context),
            _buildChangeEmailButton(context),
            _buildChangePictureButton(context),
            _buildChangePasswordButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(BuildContext context)
  {
    return Container(
      height: MediaQuery.of(context).size.height/4,
      margin: EdgeInsets.only(top:15,bottom:25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom:15),
            child:CircleAvatar(
              backgroundColor: Colors.black,
              radius: 55,
            ),
          ),
          Text(
            "Leon Balogne",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Email@gmail.com",
            style: TextStyle(
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChangeNameButton(BuildContext context)
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
                      color: Colors.blue
                  ),
                ),
                child: Center(
                  child: Text(
                    "Change Name",
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
                      color: Colors.blue
                  ),
                ),
                child: Center(
                  child: Text(
                    "Change Email",
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


  Widget _buildChangePictureButton(BuildContext context)
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
                      color: Colors.blue
                  ),
                ),
                child: Center(
                  child: Text(
                    "Change Picture",
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

  Widget _buildChangePasswordButton(BuildContext context)
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
                      color: Colors.blue
                  ),
                ),
                child: Center(
                  child: Text(
                    "Change Password",
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