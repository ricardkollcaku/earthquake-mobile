import 'dart:convert';

import 'package:earthquake/data/model/login.dart';
import 'package:earthquake/data/model/token.dart';
import 'package:earthquake/presantation/ui_helper.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class ApiService {
  String baseUrl = "http://10.0.2.2:8080/api/v1/";
  Map<String, String> header;

  ApiService({String token = ""}) {
    header = {
      "accept": "application/json",
      "content-type": "application/json",
      "Authorization": token
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
    UiHelper.showError(response.headers["error"]);
    return Stream.empty();
  }

  Stream<String> onError(error) {
    UiHelper.showError("Error comunicating with server");
    return Stream.empty();
  }

  Stream<String> heartBeat(String s) {
    return Stream.fromFuture(http.post(baseUrl + "heartBeat/$s"))
        .flatMap((response) => onResponseArrived(response))
        .onErrorResume((error) => onError(error));
  }
}
