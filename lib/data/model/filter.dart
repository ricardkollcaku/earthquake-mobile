class Filter {
  double minMagnitude;
  String name;
  String country;
  String countryCode;

  Filter({this.minMagnitude, this.name, this.country, this.countryCode});

  Filter.fromJson(Map<String, dynamic> json) {
    minMagnitude = json['minMagnitude'];
    name = json['name'];
    country = json['country'];
    countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minMagnitude'] = this.minMagnitude;
    data['name'] = this.name;
    data['country'] = this.country;
    data['countryCode'] = this.countryCode;
    return data;
  }
}
