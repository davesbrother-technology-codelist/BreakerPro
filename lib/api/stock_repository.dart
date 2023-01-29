import 'dart:convert';
import 'dart:io';
import 'package:breaker_pro/api/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../app_config.dart';

class StockRepository {
  static Future<List?> findStock(Map<String, dynamic> queryParams) async {
    Uri url = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiFindStock);
    url = url.replace(queryParameters: queryParams);
    print("Finding Stock Api Call: $url");
    Response response = await http.post(url);
    print(response.body);
    if (response.body == "null") {
      return null;
    }
    final File file = File(
        '${AppConfig.externalDirectory!.path}/LOGGER${DateFormat("ddMMyy").format(DateTime.now())}.txt');
    await file.writeAsString(
        "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())} FIND STOCK $url Success = ${jsonDecode(response.body)}\n",
        mode: FileMode.append);
    List result = jsonDecode(response.body)['DataSet'];
    return result;
  }
}
