class Filter {
  double minMagnitude;
  String name;
  String country;
  String countryCode;
  bool isNotificationEnabled;

  Filter({this.minMagnitude, this.name, this.country, this.countryCode,this.isNotificationEnabled});

  Filter.fromJson(Map<String, dynamic> json) {
    minMagnitude = json['minMagnitude'];
    name = json['name'];
    country = json['country'];
    countryCode = json['countryCode'];
    isNotificationEnabled=json['isNotificationEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minMagnitude'] = this.minMagnitude;
    data['name'] = this.name;
    data['country'] = this.country;
    data['countryCode'] = this.countryCode;
    data['isNotificationEnabled']=this.isNotificationEnabled;
    return data;
  }
}
