class Earthquake {
  String id;
  String type;
  String country;
  String countryCode;
  int countryKey;
  Properties properties;
  Geometry geometry;
  double depth;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Earthquake && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Earthquake(
      {this.id,
      this.type,
      this.country,
      this.properties,
      this.geometry,
      this.depth,
      this.countryKey});

  Earthquake.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    country = json['country'];
    countryCode = json['countryCode'];
    countryKey = json['countryKey'];

    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    depth = json['depth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['country'] = this.country;
    data['countryCode'] = this.countryCode;
    data['countryKey'] = this.countryKey;

    if (this.properties != null) {
      data['properties'] = this.properties.toJson();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['depth'] = this.depth;
    return data;
  }
}

class Properties {
  double mag;
  String place;
  int time;
  int updated;
  int tz;
  String url;
  String detail;
  String status;
  int tsunami;
  int sig;
  String net;
  String code;
  String ids;
  String sources;
  String types;
  int nst;
  double dmin;
  double rms;
  double gap;
  String magType;
  String type;
  String title;

  Properties(
      {this.mag,
      this.place,
      this.time,
      this.updated,
      this.tz,
      this.url,
      this.detail,
      this.status,
      this.tsunami,
      this.sig,
      this.net,
      this.code,
      this.ids,
      this.sources,
      this.types,
      this.nst,
      this.dmin,
      this.rms,
      this.gap,
      this.magType,
      this.type,
      this.title});

  Properties.fromJson(Map<String, dynamic> json) {
    mag = json['mag'];
    place = json['place'];
    time = json['time'];
    updated = json['updated'];
    tz = json['tz'];
    url = json['url'];
    detail = json['detail'];
    status = json['status'];
    tsunami = json['tsunami'];
    sig = json['sig'];
    net = json['net'];
    code = json['code'];
    ids = json['ids'];
    sources = json['sources'];
    types = json['types'];
    nst = json['nst'];
    dmin = json['dmin'];
    rms = json['rms'];
    gap = json['gap'];
    magType = json['magType'];
    type = json['type'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mag'] = this.mag;
    data['place'] = this.place;
    data['time'] = this.time;
    data['updated'] = this.updated;
    data['tz'] = this.tz;
    data['url'] = this.url;
    data['detail'] = this.detail;
    data['status'] = this.status;
    data['tsunami'] = this.tsunami;
    data['sig'] = this.sig;
    data['net'] = this.net;
    data['code'] = this.code;
    data['ids'] = this.ids;
    data['sources'] = this.sources;
    data['types'] = this.types;
    data['nst'] = this.nst;
    data['dmin'] = this.dmin;
    data['rms'] = this.rms;
    data['gap'] = this.gap;
    data['magType'] = this.magType;
    data['type'] = this.type;
    data['title'] = this.title;
    return data;
  }
}

class Geometry {
  String type;
  List<double> coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
