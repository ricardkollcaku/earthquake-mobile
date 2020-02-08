import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/domain/services/api_service.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

class EarthquakeService {
  ApiService _apiService;
  UserService _userService;

  EarthquakeService() {
    initFields();
  }

  void initFields() {
    _apiService = new ApiService();
    _userService = new UserService();
  }

  Stream<Earthquake> getAllEarthquakes(int pageNumber, int elementPerPage) {
    return _userService.isLogIn().flatMap((t) =>
        getEarthquakesByUserType(t, pageNumber, elementPerPage));
  }

  Stream<Earthquake> getEarthquakesByUserType(bool t, int pageNumber,
      int elementPerPage) {
    return t
        ? _apiService.getUserAllEarthquakes(pageNumber, elementPerPage)
        : _apiService.getAllEarthquakes(pageNumber, elementPerPage);
  }


}
