class AccountInfo
{
  String id;
  String name;
  String email;
  String imageURL;

  AccountInfo({this.id, this.name, this.email, this.imageURL});

  AccountInfo.fromMap(Map<String, dynamic> maps) {
    this.id = maps['id'];
    this.name = maps['name'];
    this.email = maps['email'];
    this.imageURL = maps['imageURL'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : this.id,
      'name' : this.name,
      'email' : this.email,
      'imageURL' : this.imageURL,
    };
  }
}