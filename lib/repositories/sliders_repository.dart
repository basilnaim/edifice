import 'package:gamedif/helpers/shared_value_helper.dart';

import '../app_config.dart';
import 'package:http/http.dart' as http;
import '../data_model/slider_response.dart';

class SlidersRepository {
  Future<SliderResponse> getSliders() async {
    final response =
        await http.get("${AppConfig.BASE_URL}/sliders",headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}"
        });
    /*print(response.body.toString());
    print("sliders");*/
    print("${AppConfig.BASE_URL}/sliders");
    print("roro");
    print((response.body));
    return sliderResponseFromJson(response.body);
  }
}
