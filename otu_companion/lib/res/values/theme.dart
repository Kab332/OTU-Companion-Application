import 'package:flutter/material.dart';
import 'package:otu_companion/res/values/colours.dart';
import 'colours.dart';
import '../../src/settings/model/settings.dart';
import '../../src/settings/model/settings_db_utils.dart';
import '../../src/settings/model/settings_model.dart';

class Themes
{
  final _model = SettingsModel();
  List<Settings> settings;
  Settings currentSetting;

  void mainAppTheme() async
  {
    var a = await readSetting();

  }

  Future<void> readSetting() async {
    settings = await _model.getAll();
    currentSetting = settings[0];

    print("Settings: ");
      print(currentSetting);
  }

  ThemeData generateTheme() {
    return ThemeData(
      brightness: themeMode[currentSetting.themeModeIndex],
      primarySwatch: materialColors[currentSetting.materialColorIndex],
      accentColor: accentColors[currentSetting.accentColorIndex],

      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}