import 'dart:convert';
import 'dart:io';
import 'package:breaker_pro/api/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:breaker_pro/api/api_call.dart';
import '../app_config.dart';

class WorkOrderRepository{
  static Future<List?> getWorkOrder(
      String url, Map<String, dynamic> queryParams) async {
     final Map<String, dynamic> responseJson =
      await ApiCall.get(url, queryParams);
     return responseJson['result'];
    // Uri url = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiGetWorkOrders);
    // url = url.replace(queryParameters: queryParams);
    // // print("Finding Stock Api Call: $url");
    // Response response = await http.post(url);
    // print(response.body);
    // if (response.body == "null") {
    //   return null;
    // }
    // List result = jsonDecode(response.body)['result'];
    // return result;

  }
}