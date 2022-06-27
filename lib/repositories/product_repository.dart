import 'package:gamedif/helpers/shared_value_helper.dart';

import '../app_config.dart';
import 'package:http/http.dart' as http;
import '../data_model/product_mini_response.dart';
import '../data_model/product_details_response.dart';
import '../data_model/variant_response.dart';
import 'package:flutter/foundation.dart';

class ProductRepository {
  Future<ProductMiniResponse> getFeaturedProducts({page = 1}) async {
    print("${AppConfig.BASE_URL}/products/featured");
    final response = await http
        .get("${AppConfig.BASE_URL}/products/featured?page=${page}", headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
   // print("momo");
    //print("${curr.value.replaceAll('"', '')}");
    print({
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    print('prod');
    print(response.body);

    print("${AppConfig.BASE_URL}/products/featured?page=${page}");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBestSellingProducts() async {
    final response =
        await http.get("${AppConfig.BASE_URL}/products/best-seller", headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    print("${AppConfig.BASE_URL}/products/best-seller");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTodaysDealProducts() async {
    final response =
        await http.get("${AppConfig.BASE_URL}/products/todays-deal", headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    print("${AppConfig.BASE_URL}/products/todays-deal");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFlashDealProducts(
      {@required int id = 0}) async {
    final response = await http.get(
        "${AppConfig.BASE_URL}/flash-deal-products/" + id.toString(),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        });
    print("${AppConfig.BASE_URL}/flash-deal-products/" + id.toString());
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryProducts(
      {@required int id = 0, name = "", page = 1}) async {
    final response = await http.get(
        "${AppConfig.BASE_URL}/products/category/" +
            id.toString() +
            "?page=${page}&name=${name}",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        });
    print("${AppConfig.BASE_URL}/products/category/" +
        id.toString() +
        "?page=${page}&name=${name}");
    print("${curr.value.replaceAll('"', '')}");
    print({
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    print(response.body);

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getShopProducts(
      {@required int id = 0, name = "", page = 1}) async {
    var url = "${AppConfig.BASE_URL}/products/seller/" +
        id.toString() +
        "?page=${page}&name=${name}";
    print(url);
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBrandProducts(
      {@required int id = 0, name = "", page = 1}) async {
    final response = await http.get(
        "${AppConfig.BASE_URL}/products/brand/" +
            id.toString() +
            "?page=${page}&name=${name}",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        });
    print("${AppConfig.BASE_URL}/products/brand/" +
        id.toString() +
        "?page=${page}&name=${name}");
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFilteredProducts(
      {name = "",
      sort_key = "",
      page = 1,
      brands = "",
      categories = "",
      min = "",
      max = ""}) async {
    var url = "${AppConfig.BASE_URL}/products/search" +
        "?page=${page}&name=${name}&sort_key=${sort_key}&brands=${brands}&categories=${categories}&min=${min}&max=${max}";

    print("url:" + url);
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductDetailsResponse> getProductDetails(
      {@required int id = 0}) async {
    final response = await http
        .get("${AppConfig.BASE_URL}/products/" + id.toString(), headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    print("${AppConfig.BASE_URL}/products/" + id.toString());
    print(response.body);
    print("نغنغ");
    String res =
        response.body.toString().replaceAll('"unit":null', '"unit":""');
    res = res.replaceAll('"colors":null', '"colors":[]');

    return productDetailsResponseFromJson(res);
  }

  Future<ProductMiniResponse> getRelatedProducts({@required int id = 0}) async {
    final response = await http.get(
        "${AppConfig.BASE_URL}/products/related/" + id.toString(),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        });
    print("${AppConfig.BASE_URL}/products/related/" + id.toString());
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts(
      {@required int id = 0}) async {
    final response = await http.get(
        "${AppConfig.BASE_URL}/products/top-from-seller/" + id.toString(),
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        });
    print("${AppConfig.BASE_URL}/products/top-from-seller/" + id.toString());
    return productMiniResponseFromJson(response.body);
  }

  Future<VariantResponse> getVariantWiseInfo(
      {int id = 0, color = '', variants = ''}) async {
    var url =
        "${AppConfig.BASE_URL}/products/variant/price?id=${id.toString()}&color=${color}&variants=${variants}";

    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });

    print("url:${url}");
    //  print("body -------");
    //  print(response.body);
    //   print("body end -------");
    return variantResponseFromJson(response.body);
  }
}
