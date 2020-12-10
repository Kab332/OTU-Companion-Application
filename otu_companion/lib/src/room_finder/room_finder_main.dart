/*
The empty room finder tool is a simple tool, supplied with a premade db the tool
queries the db at the user's specified input and then returns lists of either
empty class times or empty times for a class.
The premade db is made via a python-based webscraper that scrapes a specified
semester's schedules from the MyCampus Available Courses Preview.
*/

import 'package:flutter/material.dart';
import 'package:otu_companion/src/navigation_views/main_side_drawer.dart';
import 'package:intl/intl.dart';
import 'package:otu_companion/src/room_finder/model/room_model.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'model/room.dart';

class RoomFinderMain extends StatefulWidget {
  RoomFinderMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RoomFinderMainState createState() => _RoomFinderMainState();
}

class _RoomFinderMainState extends State<RoomFinderMain> {

  // Initializes variables
  final _model = RoomModel();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  DateFormat dateFormatter = DateFormat('yyyy/MM/dd');

  String type = '';
  String selectedRoom = "";
  String selectedBuilding = "";

  final classesSelected = TextEditingController();

  List<DropdownMenuItem> buildings = new List<DropdownMenuItem>();
  List<DropdownMenuItem> classes = new List<DropdownMenuItem>();
  List<DropdownMenuItem> times = new List<DropdownMenuItem>();

  Future myRoomsFuture;
  Future myBuildingsFuture;

  // --------------------------------------------------------------------------

  @override
  void initState() {
    selectedEndTime = selectedEndTime.replacing(
      hour: selectedEndTime.hour + 1,
    );

    myRoomsFuture = _getRooms();
    myBuildingsFuture = _getBuildings();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainSideDrawer(),
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(icon: Icon(Icons.help), onPressed: (){
              showAlertDialog(context);
            })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearch(context),
              _buildListHeader(context, type),
              Expanded(child: _buildList(context, type))
            ],
          ),
        ));
  }

  // --------------------------------------------------------------------------

  // Builds search display
  Widget _buildSearch(BuildContext context) {
    return Column(children: [
      Text(
        "Search by Time...",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
        children: [
          FutureBuilder(
              future: myBuildingsFuture,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: SearchableDropdown.single(
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      items: snapshot.data,
                      value: selectedBuilding,
                      hint: "Building (Optional)",
                      searchHint: "Select one",
                      onChanged: (value) {
                        setState(() {
                          selectedBuilding = value;
                        });
                      },
                      isExpanded: true,
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
        FlatButton(
          textColor: Colors.blue,
          onPressed: () => _selectDate(context),
          child: Text(dateFormatter.format(selectedDate)),
        ),
        FlatButton(
          textColor: Colors.blue,
          onPressed: () => _selectStartTime(context),
          child: Text(
            selectedStartTime.format(context).toString(),
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Text('to', style: TextStyle(
          color: Colors.blue
        ),),
        FlatButton(
          textColor: Colors.blue,
          onPressed: () => _selectEndTime(context),
          child: Text(
            selectedEndTime.format(context).toString(),
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ]),
      RaisedButton(
        onPressed: () {
          setState(() {
            type = 'time';
          });
        },
        color: Colors.blue,
        textColor: Colors.white,
        child: Text("Confirm Time"),
      ),
      Divider(),
      Text(
        "Search by Room...",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
                future: myRoomsFuture,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: SearchableDropdown.single(
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        items: snapshot.data,
                        value: selectedRoom,
                        hint: "e.g. UA1120",
                        searchHint: "Select one",
                        onChanged: (value) {
                          setState(() {
                            selectedRoom = value;
                            type = 'room';
                          });
                        },
                        isExpanded: true,
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ]),
      Divider(),
    ]);
  }

  // Builds/displays queried search parameters
  Widget _buildList(BuildContext context, String type) {
    return FutureBuilder(
        future: _getList(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  if (type == 'time') {
                    if (snapshot.data != null){
                      return ListTile(
                        title: Text(snapshot.data[index].room),
                      );
                    }
                    else {
                      return Container();
                    }
                  }
                  else if (type == 'room'){
                    if (snapshot.data != null){
                      return ListTile(
                        title: Text(DateFormat("h:mm a").format(DateFormat('HH:mm').parse(snapshot.data[index].time))),
                      );
                    }
                    else {
                      return Container();
                    }
                  }
                  else {
                    return Container();
                  }
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: snapshot.data.length);
          } else {
            return Container();
          }
        });
  }

  // Builds list header
  Widget _buildListHeader(BuildContext context, String type) {
    if (type == 'time') {
      return Text(
        "List of available rooms at specified time...",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (type == 'room') {
      return Text(
        "List of available times at specified room...",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return Container();
  }

  // Gets list of rooms for rooms DropdownMenu
  Future _getRooms() async {
    List<DropdownMenuItem> rooms  = await _model.getDropdownRooms();

    await Future.delayed(Duration(seconds: 1));

    return rooms;
  }

  // Gets list of buildings for building DropdownMenu
  Future _getBuildings() async {
    List<DropdownMenuItem> buildings = await _model.getDropdownBuildings();

    await Future.delayed(Duration(seconds: 1));

    return buildings;
  }

  // Gets queried search parameters for display
  Future _getList() async {
    if (type == 'time') {
      String day = _getDay(selectedDate);
      DateTime startTime = DateFormat('HH:mm a').parse(selectedStartTime.format(context).toString());
      DateTime endTime = DateFormat('HH:mm a').parse(selectedEndTime.format(context).toString());
      DateFormat dateFormatter = DateFormat('HH:mm');
      print("Query Input: " + day + " " + dateFormatter.format(startTime) + " " + dateFormatter.format(endTime) + " " + selectedBuilding);


      List<Room> rooms = await _model.getRoomsAtTime(day, dateFormatter.format(startTime), dateFormatter.format(endTime), selectedBuilding);
      await Future.delayed(Duration(seconds: 1));

      return rooms;
    }
    else if (type == 'room') {

      List<Room> rooms = await _model.getTimesAtRoom(selectedRoom);
      await Future.delayed(Duration(seconds: 1));

      return rooms;
    }
  }

  // Converts selected date to how the uni stores a day, used for querying db
  String _getDay(DateTime selectedDate) {
    DateFormat dateFormatter = DateFormat('EEEE');
    String date = dateFormatter.format(selectedDate);

    switch(date){
      case 'Monday': {
        return 'M';
      }
      break;

      case 'Tuesday': {
        return 'T';
      }
      break;

      case 'Wednesday': {
        return 'W';
      }
      break;

      case 'Thursday': {
        return 'R';
      }
      break;

      case 'Friday': {
        return 'F';
      }
      break;


      case 'Saturday': {
        return 'S';
      }
      break;


      case 'Sunday': {
        return 'S';
      }
      break;

      default: {
        return 'S';
      }
      break;
    }
  }

  // Creates FAQ popup
  showAlertDialog(BuildContext context) {
    Widget close = FlatButton(
      child: Text("Close"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // Sets up alert
    AlertDialog alert = AlertDialog(
      title: Text("FAQ"),
      content: Text("The empty room finder is a simple tool that shows either "
          "the empty rooms between a specified time range or the empty times "
          "(at 10 minute intervals) for a specified room.\nTimes between "
          "9:30pm to 8:00am are not included as they are inherently free. No "
          "classes are scheduled at those times."),
      actions: [
        close,
      ],
    );

    // Shows dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Creates pickers for selecting date & times

  _selectDate(BuildContext context) async {
    //  Creates DateTimePickerDialog
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  _selectStartTime(BuildContext context) async {
    //  Creates TimeOfDayPickerDialog
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime)
      setState(() {
        selectedStartTime = picked;
      });
  }

  _selectEndTime(BuildContext context) async {
    //  Creates TimeOfDayPickerDialog
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null && picked != selectedEndTime)
      setState(() {
        selectedEndTime = picked;
      });
  }
}
