import '../app_config.dart';
import 'package:http/http.dart' as http;
import '../data_model/wallet_balance_response.dart';
import '../data_model/wallet_recharge_response.dart';
import '../helpers/shared_value_helper.dart';

class WalletRepository {
  Future<WalletBalanceResponse> getBalance() async {
    final response = await http
        .get("${AppConfig.BASE_URL}/wallet/balance/${user_id.value}", headers: {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer ${access_token.value}",
      "currency": "${curr.value.replaceAll('"', '')}",
    });
    print(response.body.toString());
    print("${AppConfig.BASE_URL}/wallet/balance/${user_id.value}");
    print(response.body);
    return walletBalanceResponseFromJson(response.body);
  }

  Future<WalletRechargeResponse> getRechargeList({int page = 1}) async {
    final response = await http.get(
        "${AppConfig.BASE_URL}/wallet/history/${user_id.value}?page=${page}",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${access_token.value}",
          "currency": "${curr.value.replaceAll('"', '')}",
        });
    print("${AppConfig.BASE_URL}/wallet/history/${user_id.value}?page=${page}");
    print(response.body);
    return walletRechargeResponseFromJson(response.body);
  }
}
