import 'dart:convert';
import 'dart:io';
import 'package:breaker_pro/api/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../app_config.dart';
import '../dataclass/stock.dart';
import '../notification_service.dart';

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
        "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())} FIND STOCK ${ApiConfig.apiFindStock} Success = ${jsonDecode(response.body)}\n",
        mode: FileMode.append);
    List result = jsonDecode(response.body)['DataSet'];
    return result;
  }

  static updateLocation(Stock stock, String location) async {
    Uri url = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiUpdateLocation);
    NotificationService().instantNofitication(
        "Uploading Location Data\n\n${stock.stockID}\n$location");
    Map body = {};
    body['username'] = ApiConfig.baseQueryParams['username'];
    body['ClientID'] = ApiConfig.baseQueryParams['clientid'];
    body['Stockid'] = stock.stockID;
    body['NewPartLocation'] = location;
    body['deviceid'] = ApiConfig.baseQueryParams['deviceid'];
    body['appversion'] = AppConfig.appVersion;
    body['osversion'] = ApiConfig.baseQueryParams['osversion'];


    print("Body of api call:\n$body\n Body Ends");

    String msg = "\n\n--Update Part Location--\n\nURL:${url.toString()}\nParams:\n\n";
    msg += "username:${ApiConfig.baseQueryParams['username']}\n";
    msg += "ClientID:${ApiConfig.baseQueryParams['clientid']}\n";
    msg += "Stockid:${stock.stockID}\n";
    msg += "NewPartLocation:$location\n";
    msg += "deviceid:${ApiConfig.baseQueryParams['deviceid']}\n";
    msg += "appversion:${AppConfig.appVersion}\n";
    msg += "osVersion:${ApiConfig.baseQueryParams['osversion']}\n";

    var r = await http.post(
      url,
      body: body,
    );
    print(r.body);
    Map response = jsonDecode(r.body);
    msg += "\nResponse: ${r.body}\n";
    print(msg);
    final File file = File(
        '${AppConfig.externalDirectory!.path}/UPDATE_LOCATION__${DateFormat("ddMMyy").format(DateTime.now())}.txt');
    await file.writeAsString(msg, mode: FileMode.append);
    print(response);
    if(response['Result'] == "Successfully Updated"){
      NotificationService().instantNofitication(
          "Upload Location Complete");
    }
  }

}
