import 'package:flutter/material.dart';
import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';

class HomePageMain extends StatefulWidget
{
  HomePageMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageMainState createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MainSideDrawer(),
      resizeToAvoidBottomInset: false,
      body: ListView.separated(
        itemCount: 3,
        separatorBuilder: (BuildContext context, int index)
        {
          return Divider(
            color: Colors.grey[350],
            thickness: 5,
          );
        },
        itemBuilder: (BuildContext context, int index)
        {
          return _buildEventTile(context);
        },
      ),
    );
  }

  Widget _buildEventTile(BuildContext context)
  {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Container(
              child:CircleAvatar(
                backgroundColor: Colors.black,
                radius: 35,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Leon the Balogne'),
                Text('Leon is a Gamer™️', style: TextStyle(color: Colors.grey),),
              ],
            ),
            subtitle: Text('2d')
          ),
          Container(
            padding: EdgeInsets.only(top: 8, bottom: 8, left:20, right:20),
            child: Text(
                'Leon the Balogne the movie Leon the Balogne the movie Leon the Balogne the movie'
            ),
          ),
          Card(
            child: Container(
              height: MediaQuery.of(context).size.height*0.22,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}