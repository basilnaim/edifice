import 'package:gamedif/helpers/shared_value_helper.dart';

import '../app_config.dart';
import 'package:http/http.dart' as http;
import '../data_model/flash_deal_response.dart';

class FlashDealRepository {
  Future<FlashDealResponse> getFlashDeals() async {
    final response =
        await http.get("${AppConfig.BASE_URL}/flash-deals",headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        });
    print("${AppConfig.BASE_URL}/flash-deals");
    return flashDealResponseFromJson(response.body);
  }
}
