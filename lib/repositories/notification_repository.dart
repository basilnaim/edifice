import 'package:gamedif/helpers/shared_value_helper.dart';

import '../app_config.dart';
import 'package:http/http.dart' as http;
import '../data_model/notification_response.dart';

class NotificationRepository {
  Future<NotificationResponse> getNotification(int page) async {
    final response =
        await http.get("${AppConfig.BASE_URL}/get-notifications/?page=${page}",headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        });
    print("${AppConfig.BASE_URL}/get-notifications");
    return notificationResponseFromJson(response.body);
  }
}
