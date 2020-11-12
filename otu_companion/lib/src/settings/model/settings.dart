class Settings {
  Settings({this.materialColorIndex, this.accentColorIndex, this.themeModeIndex});

  int id;
  int materialColorIndex;
  int accentColorIndex;
  int themeModeIndex;

  Settings.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.materialColorIndex = map['materialColorIndex'];
    this.accentColorIndex = map['accentColorIndex'];
    this.themeModeIndex = map['themeModeIndex'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'materialColorIndex': this.materialColorIndex,
      'accentColorIndex': this.accentColorIndex,
      'themeModeIndex': this.themeModeIndex
    };
  }

  String toString() {
    return 'Setting{id: $id, materialColorIndex: $materialColorIndex, '
        'accentColorIndex: $accentColorIndex, themeModeIndex: $themeModeIndex}';
  }
}