class User {
  String email;
  String lastname;
  String firstname;
  bool isNotificationEnabled;
  bool fullDatabaseSearch;

  User({this.email, this.lastname, this.firstname, this.isNotificationEnabled,this.fullDatabaseSearch});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    lastname = json['lastName'];
    firstname = json['firstName'];
    isNotificationEnabled = json['isNotificationEnabled'];
    if (isNotificationEnabled == null)
      isNotificationEnabled = true;

    fullDatabaseSearch = json['fullDatabaseSearch'];
    if (fullDatabaseSearch == null)
      fullDatabaseSearch = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['lastName'] = this.lastname;
    data['firstName'] = this.firstname;
    data['isNotificationEnabled'] = this.isNotificationEnabled;
    data['fullDatabaseSearch'] = this.fullDatabaseSearch;

    return data;
  }

  static User clone(User user) {
    User clonedUser = new User();
    clonedUser.email = user.email;
    clonedUser.lastname = user.lastname;
    clonedUser.firstname = user.firstname;
    clonedUser.isNotificationEnabled = user.isNotificationEnabled;
    clonedUser.fullDatabaseSearch = user.fullDatabaseSearch;

    return clonedUser;
  }
}
