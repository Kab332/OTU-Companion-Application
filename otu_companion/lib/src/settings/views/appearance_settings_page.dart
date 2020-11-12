import 'package:flutter/material.dart';
import '../../../res/values/colours.dart';
import '../model/settings.dart';
import '../model/settings_model.dart';
class AppearanceSettingPage extends StatefulWidget
{
  AppearanceSettingPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AppearanceSettingPageState createState() => _AppearanceSettingPageState();
}

class _AppearanceSettingPageState extends State<AppearanceSettingPage>
{
  ColorSwatch selectedMaterialColor = materialColors[0];
  ColorSwatch selectedAccentColor = accentColors[0];
  Brightness currentMode = themeMode[0];

  final _model = SettingsModel();

  var _newMaterialColorIndex;
  var _newAccentColorIndex;
  var _newThemeModeIndex;

  void _updateSetting() {
    Settings setting = Settings(materialColorIndex: _newMaterialColorIndex,
        accentColorIndex: _newAccentColorIndex, themeModeIndex: _newThemeModeIndex);
    setting.id = 1;
    _model.updateSettings(setting);
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Primary Color"),
                  DropdownButton(
                      value: selectedMaterialColor,
                      icon: Icon(Icons.arrow_downward),
                      items:  materialColors.map((color)  {
                        return DropdownMenuItem(
                          value: color,
                          child: Container(
                            width: 200,
                            height: 40,
                            color: color,
                          ),
                        );
                      }).toList(),
                      onChanged:  (newColor) {
                        setState(() {
                          selectedMaterialColor = newColor;
                          print(materialColors.indexOf(selectedMaterialColor));
                          _newMaterialColorIndex = materialColors.indexOf(selectedMaterialColor);
                        });
                      })
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Accent Color"),
                  DropdownButton(
                      value: selectedAccentColor,
                      icon: Icon(Icons.arrow_downward),
                      items:  accentColors.map((color)  {
                        return DropdownMenuItem(
                          value: color,
                          child: Container(
                            width: 200,
                            height: 40,
                            color: color,
                          ),
                        );
                      }).toList(),
                      onChanged:  (newColor) {
                        setState(() {
                          selectedAccentColor = newColor;
                          print(accentColors.indexOf(selectedAccentColor));
                          _newAccentColorIndex = accentColors.indexOf(selectedAccentColor);
                        });
                      })
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text("Change Theme"),
                  Expanded(
                    child: ListTile(
                      title: Text("Light"),
                      leading: Radio(
                        value: themeMode[0],
                        groupValue: currentMode,
                        onChanged: (Brightness value) {
                          setState(() {
                            currentMode = value;
                            print(themeMode.indexOf(currentMode));
                            _newThemeModeIndex = themeMode.indexOf(currentMode);
                          });
                        },
                      ),
                    )
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text("Dark"),
                      leading: Radio(
                        value: themeMode[1],
                        groupValue: currentMode,
                        onChanged: (Brightness value) {
                          setState(() {
                            currentMode = value;
                            print(themeMode.indexOf(currentMode));
                            _newThemeModeIndex = themeMode.indexOf(currentMode);
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: RaisedButton(
                onPressed: _updateSetting,
                child: Text('Apply', style: TextStyle(fontSize: 20)),
              ),
            )
          ],
        ),
      ),
    );
  }
}