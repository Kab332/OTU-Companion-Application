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
                  child: Text(selectedTime.format(context).toString(), style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),),
                ),
                RaisedButton(
                  onPressed: () {},
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
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                  ]),
              Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return ButtonTheme(
                      height: 50,
                      child: RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Center(child: Text('Entry $index')),
                        onPressed: () {},
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 4,
                    );
                  },
                ),
              )
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
}

String selectedRoom = "";

final classesSelected = TextEditingController();

List<DropdownMenuItem> classes = [
  DropdownMenuItem(child: Text("UA1350"), value: "UA1350"),
  DropdownMenuItem(child: Text("UA1120"), value: "UA1120"),
  DropdownMenuItem(child: Text("UB2080"), value: "UB2080"),
  DropdownMenuItem(child: Text("UB4095"), value: "UB4095"),
  DropdownMenuItem(child: Text("UB4085"), value: "UB4085"),
];
