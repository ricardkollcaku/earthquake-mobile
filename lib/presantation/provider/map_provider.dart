import 'package:earthquake/data/model/earthquake.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';

class MapProvider {
  static LatLng _currentLocation;
  static Distance _distance;
  static NumberFormat _numberFormat;

  static initMapProvider() {
    _getAddressFromLatLng();
    _distance = new Distance();
    _numberFormat = new NumberFormat("#,###");
  }

  static _getAddressFromLatLng() async {
    _currentLocation = new LatLng(0, 0);
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
    _currentLocation.latitude = position.latitude;
    _currentLocation.longitude = position.longitude;
  }

  static String getDistanceInKm(Geometry latLng) {
    if (_currentLocation == null ||
        (_currentLocation.latitude == 0 && _currentLocation.longitude == 0))
      return "Your location is not detected";
    final double km = _distance.as(
        LengthUnit.Kilometer,
        new LatLng(latLng.coordinates[1], latLng.coordinates[0]),
        _currentLocation);
    return _numberFormat.format(km) + "KM away from you";
  }
}
