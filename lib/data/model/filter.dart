class Filter {
  double minMagnitude;
  String name;
  String country;
  int countryKey;
  String countryCode;
  bool isNotificationEnabled;

  Filter(
      {this.minMagnitude,
      this.name,
      this.country,
      this.countryKey,
      this.isNotificationEnabled,
      this.countryCode});

  Filter.fromJson(Map<String, dynamic> json) {
    minMagnitude = json['minMagnitude'];
    name = json['name'];
    country = json['country'];
    countryKey = json['countryKey'];
    isNotificationEnabled = json['isNotificationEnabled'];
    countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minMagnitude'] = this.minMagnitude;
    data['name'] = this.name;
    data['country'] = this.country;
    data['countryKey'] = this.countryKey;
    data['isNotificationEnabled'] = this.isNotificationEnabled;
    data['countryCode'] = this.countryCode;
    return data;
  }
}
