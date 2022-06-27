import '../app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../helpers/shared_value_helper.dart';

class ChangeCurrencyRepository {

  Future<dynamic> PostChangeCurrResponse(
      @required String currcode) async {
    var post_body = jsonEncode({
      "currency_code": "$currcode",
    });
    final response =
    await http.post("${AppConfig.BASE_URL}/changeCurrency",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}"
        },
        body: post_body);
    print("${AppConfig.BASE_URL}/changeCurrency");
    print(access_token.value);
    return (response.body.trim().toString());
  }

  Future<dynamic> getChangeCurrResponse() async {
    final response =
    await http.get("${AppConfig.BASE_URL}/listcountries",headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}"
    });
    print("${AppConfig.BASE_URL}/listcountries");
    return (response.body.trim().toString());
  }

}
