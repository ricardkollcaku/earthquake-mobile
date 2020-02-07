class Country {
  String country;
  String countryCode;

  Country({this.country, this.countryCode});

  Country.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['countryCode'] = this.countryCode;
    return data;
  }

  @override
  String toString() {
    return '$country $countryCode';
  }


}