import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:otu_companion/src/services/authentication/model/authentication_service.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'package:geocoding/geocoding.dart';

import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';
import '../event_finder/model/event_model.dart';
import '../event_finder/model/event.dart';

class HomePageMain extends StatefulWidget {
  HomePageMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageMainState createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain> {
  AuthenticationService _authenticationService = AuthenticationService();
  User user;

  var geocoder = GeocodingPlatform.instance;

  @override
  Widget build(BuildContext context) {
    user = _authenticationService.getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MainSideDrawer(),
      resizeToAvoidBottomInset: false,
      body: _buildEventList(context),
    );
  }

  Widget _buildEventList(BuildContext context) {
    EventModel _eventModel = EventModel();
    return FutureBuilder<QuerySnapshot>(
        future: _eventModel.getUserEvents(user.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.isNotEmpty) {
              return ListView(
                children: snapshot.data.docs
                    .map((DocumentSnapshot document) =>
                        _buildEventTile(context, document))
                    .toList(),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    FlutterI18n.translate(
                      context, "homePageMain.messages.noEvents"
                    ),
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                  ),
                ),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildEventTile(BuildContext context, DocumentSnapshot eventData) {
    final event =
        Event.fromMap(eventData.data(), reference: eventData.reference);

    LatLng _centre = LatLng(event.geoPoint.latitude, event.geoPoint.longitude);

    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
              leading: Container(
                child: CircleAvatar(
                  child: Text(event.name[0],
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.black,
                  radius: 35,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(event.name),
                ],
              ),
              subtitle: Text(event.startDateTime.toString())),
          Container(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
            child: Align(
                alignment: Alignment.topLeft, child: Text(event.description)),
          ),
          Card(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.22,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: FlutterMap(
                options: MapOptions(
                  minZoom: 5.0,
                  zoom: 10.0,
                  maxZoom: 20.0,
                  center: _centre,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1IjoibGVvbi1jaG93MSIsImEiOiJja2hyMGRteWcwNjh0MzBteXh1NXNibHY0In0.nFSqVO-aIMytp_hQWKmXXQ',
                      'id': 'mapbox.mapbox-streets-v8'
                    },
                    subdomains: ['a', 'b', 'c'],
                  ),
                  new MarkerLayerOptions(
                    markers: [
                      Marker(
                        width: 70.0,
                        height: 70.0,
                        point: _centre,
                        builder: (context) => Container(
                            child: IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.location_on),
                          onPressed: () {
                            print('Clicked icon!');
                          },
                        )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
