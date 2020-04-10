import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/data/model/filter.dart';
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

  Stream<Earthquake> getAllEarthquakes(int pageNumber, int elementPerPage,{Filter filter}) {
    return _userService.isLogIn().flatMap((t) =>
        getEarthquakesByUserType(t, pageNumber, elementPerPage,filter: filter));
  }

  Stream<Earthquake> getEarthquakesByUserType(bool t, int pageNumber,
      int elementPerPage,{Filter filter}) {
    if(filter!=null)
    return t
        ? _apiService.getUserAllEarthquakes(pageNumber, elementPerPage)
        : _apiService.getAllEarthquakes(pageNumber, elementPerPage,mag: filter.minMagnitude,countryKey: filter.countryKey);
    return  t
        ? _apiService.getUserAllEarthquakes(pageNumber, elementPerPage)
        : _apiService.getAllEarthquakes(pageNumber, elementPerPage);
  }


Stream<bool> isLogin(){
    return _userService.isLogIn();
}

}
