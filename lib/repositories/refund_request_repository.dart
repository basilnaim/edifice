import '../app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';
import '../data_model/refund_request_response.dart';
import '../data_model/refund_request_send_response.dart';

class RefundRequestRepository {
  Future<RefundRequestResponse> getRefundRequestListResponse(
      {@required page = 1}) async {
    final response = await http.get(
      "${AppConfig.BASE_URL}/refund-request/get-list/${user_id.value}?page=$page",
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Authorization": "Bearer ${access_token.value}",
        "currency": "${curr.value.replaceAll('"', '')}",
      },
    );
    print(
        "${AppConfig.BASE_URL}/refund-request/get-list/${user_id.value}?page=$page");
    // print(response.body.toString());
    return refundRequestResponseFromJson(response.body);
  }

  Future<RefundRequestSendResponse> getRefundRequestSendResponse(
      {@required int id, @required String reason}) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "user_id": "${user_id.value}",
      "reason": "${reason}",
    });
    final response =
        await http.post("${AppConfig.BASE_URL}/refund-request/send",
            headers: {
              "Content-Type": "application/json",
              "X-Requested-With": "XMLHttpRequest",
              "Authorization": "Bearer ${access_token.value}",
              "currency": "${curr.value.replaceAll('"', '')}",
            },
            body: post_body);
    print("${AppConfig.BASE_URL}/refund-request/send");
    return refundRequestSendResponseFromJson(response.body);
  }
}
