import '../app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../data_model/order_mini_response.dart';
import '../data_model/order_detail_response.dart';
import '../data_model/order_item_response.dart';
import '../helpers/shared_value_helper.dart';

class OrderRepository {
  Future<OrderMiniResponse> getOrderList(
      {page = 1, payment_status = "", delivery_status = ""}) async {
    var url = "${AppConfig.BASE_URL}/purchase-history/" +
        "${user_id.value}" +
        "?page=${page}&payment_status=${payment_status}&delivery_status=${delivery_status}";
    print(url);
    print(curr);
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value}"
     // "currency": "${curr.value.replaceAll('"', '')}",
    });
    print(response.body.toString());
    return orderMiniResponseFromJson(response.body);
  }

  Future<OrderDetailResponse> getOrderDetails({@required int id = 0}) async {
    var url = "${AppConfig.BASE_URL}/purchase-history-details/" + id.toString();

    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    print("${AppConfig.BASE_URL}/purchase-history-details/" + id.toString());
    print(response.body.toString());
    return orderDetailResponseFromJson(response.body);
  }

  Future<OrderItemResponse> getOrderItems({@required int id = 0}) async {
    var url = "${AppConfig.BASE_URL}/purchase-history-items/" + id.toString();

    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    print("url:" + url.toString());
    print(response.body);
    return orderItemlResponseFromJson(response.body);
  }
}
