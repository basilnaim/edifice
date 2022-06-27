import '../app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data_model/review_response.dart';
import '../data_model/review_submit_response.dart';

import '../helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class ReviewRepository {
  Future<ReviewResponse> getReviewResponse(@required int product_id,
      {page = 1}) async {
    //print(product_id.toString()+"hehehe");
    final response = await http.get(
      "${AppConfig.BASE_URL}/reviews/product/${product_id}?page=${page}",
      headers: {
        "Content-Type": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Authorization": "Bearer ${access_token.value}",
        "currency": "${curr.value.replaceAll('"', '')}",
      },
    );
    print("${AppConfig.BASE_URL}/reviews/product/${product_id}?page=${page}");
    return reviewResponseFromJson(response.body);
  }

  Future<ReviewSubmitResponse> getReviewSubmitResponse(
    @required int product_id,
    @required int rating,
    @required String comment,
  ) async {
    var post_body = jsonEncode({
      "product_id": "${product_id}",
      "user_id": "${user_id.value}",
      "rating": "$rating",
      "comment": "$comment"
    });
    // print(post_body.toString());
    final response = await http.post("${AppConfig.BASE_URL}/reviews/submit",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        },
        body: post_body);
    print("${AppConfig.BASE_URL}/reviews/submit");
    return reviewSubmitResponseFromJson(response.body);
  }
}
