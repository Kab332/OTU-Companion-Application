import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class RoomFinderMain extends StatefulWidget {
  RoomFinderMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RoomFinderMainState createState() => _RoomFinderMainState();
}

class _RoomFinderMainState extends State<RoomFinderMain> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateFormat dateFormatter = DateFormat('yyyy/MM/dd');
  DateFormat timeFormatter = DateFormat('HH:mm');

  String type = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search by Time...",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                FlatButton(
                  textColor: Colors.blue,
                  onPressed: () => _selectDate(context),
                  child: Text(dateFormatter.format(selectedDate)),
                ),
                FlatButton(
                  textColor: Colors.blue,
                  onPressed: () => _selectTime(context),
                  child: Text(
                    selectedTime.format(context).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
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
              ]),
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
                    Expanded(
                      child: SearchableDropdown.single(
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        items: classes,
                        value: selectedRoom,
                        hint: "e.g. UA1350",
                        searchHint: "Select one",
                        onChanged: (value) {
                          setState(() {
                            selectedRoom = value;
                            type = 'room';
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                  ]),
              Divider(),
              _buildListHeader(context, type),
              SizedBox(
                height: 4,
              ),
              Expanded(child: _buildList(context, type))
            ],
          ),
        ));
  }

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

  _selectTime(BuildContext context) async {
    //  Creates DateTimePickerDialog
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  Widget _buildList(BuildContext context, String type) {
    if (type == 'time') {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: classes.length,
        itemBuilder: (BuildContext context, int index) {
          return ButtonTheme(
            height: 50,
            child: RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Center(child: Text(classes[index].value.toString())),
              onPressed: () {},
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 4,
          );
        },
      );
    } else if (type == 'room') {
      return ListView.separated(
        itemCount: times.length,
        itemBuilder: (BuildContext context, int index) {
          return ButtonTheme(
            height: 50,
            child: RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Center(child: Text(times[index].value.toString())),
              onPressed: () {},
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 4,
          );
        },
      );
    }
    return Container();
  }

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
}

String selectedRoom = "";

final classesSelected = TextEditingController();

List<DropdownMenuItem> classes = [
  DropdownMenuItem(child: Text("UA1350"), value: "UA1350"),
  DropdownMenuItem(child: Text("UA1120"), value: "UA1120"),
  DropdownMenuItem(child: Text("UB2080"), value: "UB2080"),
  DropdownMenuItem(child: Text("UB4095"), value: "UB4095"),
  DropdownMenuItem(child: Text("UB4085"), value: "UB4085"),
  DropdownMenuItem(child: Text("test1"), value: "test1"),
  DropdownMenuItem(child: Text("test2"), value: "test2"),
  DropdownMenuItem(child: Text("test3"), value: "test3"),
  DropdownMenuItem(child: Text("test4"), value: "test4"),
  DropdownMenuItem(child: Text("test5"), value: "test5"),
];

List<DropdownMenuItem> times = [
  DropdownMenuItem(child: Text("11:00 am"), value: "11:00 am"),
  DropdownMenuItem(child: Text("12:30 pm"), value: "12:30 pm"),
  DropdownMenuItem(child: Text("2:00 pm"), value: "2:00 pm"),
  DropdownMenuItem(child: Text("3:30 pm"), value: "3:30 pm"),
  DropdownMenuItem(child: Text("5:00 pm"), value: "5:00 pm"),
];
