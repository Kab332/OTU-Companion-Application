class AccountInfo
{
  String name;
  String email;
  String imageURL;

  AccountInfo({this.name, this.email, this.imageURL});

  AccountInfo.fromMap(Map<String, dynamic> maps) {
    this.name = maps['name'];
    this.email = maps['email'];
    this.imageURL = maps['imageURL'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name' : this.name,
      'email' : this.email,
      'imageURL' : this.imageURL,
    };
  }
}