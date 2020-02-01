import 'dart:convert';

import 'package:earthquake/data/model/change_password.dart';
import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/data/model/filter.dart';
import 'package:earthquake/data/model/login.dart';
import 'package:earthquake/data/model/register.dart';
import 'package:earthquake/data/model/token.dart';
import 'package:earthquake/data/model/user.dart';
import 'package:earthquake/presantation/ui_helper.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class ApiService {
//  String baseUrl = "http://10.0.2.2:8080/api/v1/";
  String baseUrl = "http://192.168.0.15:8080/api/v1/";
  //String baseUrl = "http://[2a02:8108:8f80:2ad6:30b5:aaea:db47:4b04]:8080/api/v1/";

  Map<String, String> header;
  static String _token = "";

  ApiService({String token = ""}) {
    if (token != "")
      _token = token;
    header = {
      "accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + _token
    };
  }

  String setToken(String token) {
    _token = token;
    header = {
      "accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + _token
    };
  }

  Stream<Token> login(Login loginDto) {
    return Stream.fromFuture(http.post(baseUrl + "users/login",
            body: (json.encode(loginDto.toJson())), headers: header))
        .flatMap((response) => onResponseArrived(response))
        .onErrorResume((error) => onError(error))
        .map((body) => Token.fromJson(jsonDecode(body)));
  }

  Stream<String> onResponseArrived(http.Response response) {
    if (response.statusCode == 200) return Stream.value(response.body);
    if(response.statusCode==401){
      UiHelper.showError("User is unauthorized");
      return Stream.error("User is unauthorized");
    }
    UiHelper.showError(response.headers["error"]);
    return Stream.error("error");
  }

  Stream<String> onError(error) {
    UiHelper.showError("Error comunicating with server");
    return Stream.error(error);
  }

  Stream<String> heartBeat(String s) {
    return Stream.fromFuture(http.post(baseUrl + "heartBeat/$s"))
        .flatMap((response) => onResponseArrived(response))
        .onErrorResume((error) => onError(error));
  }


  Stream<Token> register(Register register) {
    return Stream.fromFuture(http.post(baseUrl + "users/register",
        body: (json.encode(register.toJson())), headers: header))
        .flatMap((response) => onResponseArrived(response))
        .onErrorResume((error) => onError(error))
        .map((body) => Token.fromJson(jsonDecode(body)));
  }

  Stream<String> forgotPassword(String s) {
    return Stream.fromFuture(http.post(baseUrl + "users/forgotPassword/$s"))
        .flatMap((response) => onResponseArrived(response))
        .onErrorResume((error) => onError(error));
  }

  Stream<User> changePassword(ChangePassword changePassword) {
    return Stream.fromFuture(http.put(baseUrl + "users/changePassword",
        body: (json.encode(changePassword.toJson())), headers: header))
        .flatMap((response) => onResponseArrived(response))
        .onErrorResume((error) => onError(error))
        .map((body) => User.fromJson(jsonDecode(body)));
  }

  Stream<User> changeNotification(User user) {
    return Stream.fromFuture(http.put(baseUrl + "users/setNotification/" +
        user.isNotificationEnabled.toString(), headers: header))
        .flatMap((response) => onResponseArrived(response))
        .onErrorResume((error) => onError(error))
        .map((body) => User.fromJson(jsonDecode(body)));
  }

  Stream<User> getCurrentUser() {
    return Stream.fromFuture(
        http.get(baseUrl + "users/currentUser", headers: header))
        .flatMap((response) => onResponseArrived(response))
        .onErrorResume((error) => onError(error))
        .map((body) => User.fromJson(jsonDecode(body)));
  }

  Stream<Earthquake> getAllEarthquakes(int pageNr, int elementPerPage) {
    return Stream.fromFuture(
        http.get(baseUrl +
            "earthquake/all?pageNumber=$pageNr&elementPerPage=$elementPerPage",
            headers: header))
        .flatMap((response) => onResponseArrived(response))
        .onErrorResume((error) => onError(error))
        .flatMap((body) => Stream.fromIterable(jsonDecode(body)))
        .map((s) => Earthquake.fromJson(s));
  }

  Stream<Filter> getAllFilter() {
    return Stream.fromFuture(
        http.get(baseUrl + "filters",
            headers: header))
        .flatMap((response) => onResponseArrived(response))
        .onErrorResume((error) => onError(error))
        .flatMap((body) => Stream.fromIterable(jsonDecode(body)))
        .map((s) => Filter.fromJson(s));
  }

  Stream<Filter> removeFilter(Filter filter) {
    return Stream.fromFuture(
        http.put(baseUrl + "filters",
            headers: header, body: (json.encode(filter.toJson()))))
        .flatMap((response) => onResponseArrived(response))
        .onErrorResume((error) => onError(error))
        .map((body) => jsonDecode(body))
        .map((s) => Filter.fromJson(s));
  }

}
