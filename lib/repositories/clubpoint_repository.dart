import '../app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';
import '../data_model/clubpoint_response.dart';
import '../data_model/clubpoint_to_wallet_response.dart';

class ClubpointRepository {


  Future<ClubpointResponse> getClubPointListResponse({@required page = 1}) async {
    final response = await http.get(
      "${AppConfig.BASE_URL}/clubpoint/get-list/${user_id.value}?page=$page",
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With":"XMLHttpRequest",
        "Authorization": "Bearer ${access_token.value}",
        "currency": "${curr.value.replaceAll('"', '')}",
      },
    );
    print("${AppConfig.BASE_URL}/clubpoint/get-list/${user_id.value}?page=$page");
    print(response.body.toString());
    return clubpointResponseFromJson(response.body);
  }

  Future<ClubpointToWalletResponse> getClubpointToWalletResponse(
      @required int id) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "user_id": "${user_id.value}",
    });
    final response =
    await http.post("${AppConfig.BASE_URL}/clubpoint/convert-into-wallet",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With":"XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        },
        body: post_body);
    print("${AppConfig.BASE_URL}/clubpoint/convert-into-wallet");
    return clubpointToWalletResponseFromJson(response.body);
  }

}