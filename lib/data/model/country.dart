class Country {
  String country;
  String countryCode;
  int key;

  Country({this.country, this.countryCode,this.key});

  Country.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    countryCode = json['countryCode'];
    key=json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['countryCode'] = this.countryCode;
    data['key']=this.key;
    return data;
  }

  @override
  String toString() {
    return '$country $countryCode $key';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Country &&
              runtimeType == other.runtimeType &&
              key == other.key;

  @override
  int get hashCode => key.hashCode;



}