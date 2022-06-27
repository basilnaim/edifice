import 'package:gamedif/helpers/shared_value_helper.dart';

import '../app_config.dart';
import 'package:http/http.dart' as http;
import '../data_model/banners_response.dart';

class BannerRepository {

  Future<BannersResponse> getBanners() async {
    final response =
        await http.get("${AppConfig.BASE_URL}/banners",headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        });
    print("${AppConfig.BASE_URL}/banners");
    print("${curr.value.replaceAll('"', '')}");
    return bannersResponseFromJson(response.body);
  }



}
