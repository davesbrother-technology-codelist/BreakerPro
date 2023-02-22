import 'dart:convert';

import '../app_config.dart';
import '../notification_service.dart';
import 'api_config.dart';
import 'package:http/http.dart' as http;

class StockReconcileRepository{
   static update(String stockID) async {
     Uri url = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiUploadStockReconcile);
     NotificationService().instantNofitication(
         "Uploading Stock Reconcile Data\n\n$stockID");
     Map body = {};
     body['username'] = ApiConfig.baseQueryParams['username'];
     body['ClientID'] = ApiConfig.baseQueryParams['clientid'];
     body['Stockid'] = stockID;
     body['Deviceid'] = ApiConfig.baseQueryParams['deviceid'];
     body['Appversion'] = AppConfig.appVersion;


     print("Body of api call:\n$body\n Body Ends");

     // String msg = "\n\n--Update Part Location--\n\nURL:${url.toString()}\nParams:\n\n";
     // msg += "username:${ApiConfig.baseQueryParams['username']}\n";
     // msg += "ClientID:${ApiConfig.baseQueryParams['clientid']}\n";
     // msg += "Stockid:${stock.stockID}\n";
     // msg += "NewPartLocation:$location\n";
     // msg += "deviceid:${ApiConfig.baseQueryParams['deviceid']}\n";
     // msg += "appversion:${AppConfig.appVersion}\n";
     // msg += "osVersion:${ApiConfig.baseQueryParams['osversion']}\n";

     var r = await http.post(
       url,
       body: body,
     );
     print(r.body);
     Map response = jsonDecode(r.body);
     // msg += "\nResponse: ${r.body}\n";
     // print(msg);
     // final File file = File(
     //     '${AppConfig.externalDirectory!.path}/UPDATE_LOCATION__${DateFormat("ddMMyy").format(DateTime.now())}.txt');
     // await file.writeAsString(msg, mode: FileMode.append);
     print(response);
     if(response['Result'] == "Successfully Updated"){
       NotificationService().instantNofitication(
           "Upload Stock Reconcile Complete");
     }
   }
}