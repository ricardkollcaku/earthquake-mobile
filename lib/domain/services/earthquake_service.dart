import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/domain/services/api_service.dart';

class EarthquakeService {
  ApiService _apiService;

  EarthquakeService() {
    initFields();
  }

  void initFields() {
    _apiService = new ApiService();
  }

  Stream<Earthquake> getAllEarthquakes(int pageNumber, int elementPerPage) {
    return _apiService.getAllEarthquakes(pageNumber, elementPerPage);
  }
}
