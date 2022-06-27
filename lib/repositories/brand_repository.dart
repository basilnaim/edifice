import 'package:gamedif/helpers/shared_value_helper.dart';

import '../app_config.dart';
import 'package:http/http.dart' as http;
import '../data_model/brand_response.dart';

class BrandRepository {
  Future<BrandResponse> getFilterPageBrands() async {
    final response =
        await http.get("${AppConfig.BASE_URL}/filter/brands", headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    print("${AppConfig.BASE_URL}/filter/brands");
    return brandResponseFromJson(response.body);
  }

  Future<BrandResponse> getBrands({name = "", page = 1}) async {
    final response = await http.get(
        "${AppConfig.BASE_URL}/brands" + "?page=${page}&name=${name}",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        });
    print("${AppConfig.BASE_URL}/brands" + "?page=${page}&name=${name}");
    return brandResponseFromJson(response.body);
  }
}
