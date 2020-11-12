// view entity class, also has mapping functions for sql queries
class View {
  int id;
  String viewType;
  
  View({this.id, this.viewType});
  
  View.fromMap(Map<String, dynamic> data) {
    this.id = data['id'];
    this.viewType = data['viewType'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'viewType': this.viewType,
    };
  }
}