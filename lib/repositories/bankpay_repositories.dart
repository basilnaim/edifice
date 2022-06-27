import '../app_config.dart';
import '../data_model/profile_image_update_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data_model/profile_counters_response.dart';
import '../data_model/profile_update_response.dart';
import '../data_model/device_token_update_response.dart';

import '../helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class BankPayRepository {
  Future<ProfileImageUpdateResponse> getBankPayResponse(
      @required double amt,
      @required String bankname,
      @required String routingname,
      @required String paymeth,
      @required String trxid,
      @required String image) async {
    var post_body = jsonEncode({
      "amount": "${amt.toInt()}",
      "bank_name": "${bankname}",
      "routing_name": "${routingname}",
      "payment_method": "${paymeth}",
      "trx_id": "${trxid}",
      "photo": "${image}",
    });
    //print(post_body.toString());

    final response =
        await http.post("${AppConfig.BASE_URL}/wallet/recharge",
            headers: {
              "Content-Type": "application/json",
              "X-Requested-With": "XMLHttpRequest",
              "Authorization": "Bearer ${access_token.value}",
              "currency": "${curr.value.replaceAll('"', '')}",
            },
            body: post_body);
    print("${AppConfig.BASE_URL}/wallet/recharge");
    //print(response.body.toString());
    return profileImageUpdateResponseFromJson(response.body);
  }
}
