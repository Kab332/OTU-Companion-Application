import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import '../model/guide.dart';

// This is basically a simpler version of the event form
class GuideFormPage extends StatefulWidget {
  GuideFormPage({Key key, this.title, this.guide}) : super(key: key);

  final Guide guide;
  final String title;

  @override
  _GuideFormPageState createState() => _GuideFormPageState();
}

class _GuideFormPageState extends State<GuideFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String _description = "";

  Guide _selectedGuide;

  void initState() {
    super.initState();

    _selectedGuide = widget.guide != null ? widget.guide : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(1.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
              )
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    _buildTextFormField("Guide Name"),
                    _buildTextFormField("Description"),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Guide guide = Guide(
                  name: _name != "" ? _name : _selectedGuide.name,
                  description: _description != ""
                      ? _description
                      : _selectedGuide.description);

              Navigator.pop(context, guide);
            }
          },
          tooltip: "Save",
          child: Icon(Icons.save),
        ));
  }

  // A function for building the name and description text forms, works similar to the one in event form
  Widget _buildTextFormField(String type) {
    String typeVal = "";

    if (type == "Guide Name" && _selectedGuide != null) {
      typeVal = _selectedGuide.name;
    } else if (type == "Description" && _selectedGuide != null) {
      typeVal = _selectedGuide.description;
    }

    return TextFormField(
      decoration: InputDecoration(
        labelText: type == "Guide Name"
            ? FlutterI18n.translate(context, "guidesForm.formLabels.name")
            : FlutterI18n.translate(
                context, "guidesForm.formLabels.description"),
      ),
      autovalidateMode: AutovalidateMode.always,
      initialValue: _selectedGuide != null ? typeVal : '',
      maxLines: type == "Description" ? 3 : 1,
      validator: (String value) {
        if (value.isEmpty) {
          return type == "Guide Name"
              ? FlutterI18n.translate(
                  context, "guidesForm.errorLabels.emptyName")
              : FlutterI18n.translate(
                  context, "guidesForm.errorLabels.emptyDescription");
        } else if (type == "Guide Name" && value.length > 12) {
          return FlutterI18n.translate(
              context, "guidesForm.errorLabels.nameLength");
        }
        return null;
      },
      onChanged: (String newValue) {
        if (type == "Guide Name") {
          _name = newValue;
        } else if (type == "Description") {
          _description = newValue;
        }
      },
    );
  }
}
