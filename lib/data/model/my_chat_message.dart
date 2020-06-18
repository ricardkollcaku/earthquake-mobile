class MyChatMessage {
  String id;
  String message;
  String earthquakeId;
  int createdTime;
  User user;

  MyChatMessage(
      {this.id, this.message, this.earthquakeId, this.createdTime, this.user});

  MyChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    earthquakeId = json['earthquakeId'];
    createdTime = json['createdTime'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['earthquakeId'] = this.earthquakeId;
    data['createdTime'] = this.createdTime;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String id;
  String name;
  String lastName;

  User({this.id, this.name, this.lastName});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    return data;
  }
}
