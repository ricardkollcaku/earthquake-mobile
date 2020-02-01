import 'package:earthquake/data/model/filter.dart';

import 'api_service.dart';

class FilterService {
  ApiService _apiService;

  FilterService() {
    initFields();
  }

  void initFields() {
    _apiService = new ApiService();
  }

  Stream<Filter> getAllFilters() {
    return _apiService.getAllFilter();
  }

  Stream<Filter> remove(Filter filter) {
    return _apiService.removeFilter(filter);
  }
}
