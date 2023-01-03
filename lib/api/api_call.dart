import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class ApiCall {
  static Future<Map<String, dynamic>> get(
      String url, Map<String, dynamic> queryParams) async {
    Uri uri = Uri.parse(url);
    uri = uri.replace(queryParameters: queryParams);
    print("Api Get Call : $uri");
    final response = await http.get(uri, headers: ApiConfig.headers);
    String responseBody = utf8.decoder.convert(response.bodyBytes);
    final Map<String, dynamic> responseJson = json.decode(responseBody);

    print("Response : $responseJson");
    return responseJson;
  }
}
