import 'package:gamedif/helpers/shared_value_helper.dart';

import '../app_config.dart';
import 'package:http/http.dart' as http;
import '../data_model/category_response.dart';

class CategoryRepository {
  Future<CategoryResponse> getCategories({parent_id = 0}) async {
    final response = await http.get(
        "${AppConfig.BASE_URL}/categories?parent_id=${parent_id}",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        });
    print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    // print(response.body.toString());
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFeturedCategories() async {
    final response =
        await http.get("${AppConfig.BASE_URL}/categories/featured", headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    //print(response.body.toString());
    //print("--featured cat--");

    print("${AppConfig.BASE_URL}/categories/featured");
    print("${curr.value.replaceAll('"', '')}");
    print("Bearer ${access_token.value}");
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getTopCategories() async {
    final response =
        await http.get("${AppConfig.BASE_URL}/categories/top", headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    print("${AppConfig.BASE_URL}/categories/top");
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFilterPageCategories() async {
    final response =
        await http.get("${AppConfig.BASE_URL}/filter/categories", headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    print("${AppConfig.BASE_URL}/filter/categories");
    return categoryResponseFromJson(response.body);
  }
}
