import 'dart:convert';
import 'dart:io';

import 'package:breaker_pro/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static String baseUrl = "https://matchapart.com/script/";

  static String apiLogin = "mobileapp_ws_logon_json.php";
  static String apiPartList = "mobileapp_ws_part_list_json.php";
  static String apiSelectList = "mobileapp_ws_select_list_json.php";
  static String apiFindStock = "mobileapp_ws_findstock_json.php";
  static String apiUpdateLocation = "mobileapp_ws_newpartlocation_json.php";
  static String apiCheckQty = "mobileapp_ws_checkqty_json.php";
  static String apiVrnLookup = "mobileapp_ws_vrnlookup_json.php";
  static String apiStockRefLookup = "mobileapp_ws_stockref_lookup_json.php";
  static String apiSubmitParts = "mobileapp_ws_submit_parts_json.php";
  static String apiSubmitPartsTemp = "mobileapp_ws_submit_parts_jsonDEV.php";
  static String apiSubmitVehicle = "mobileapp_ws_submit_vehicle_json.php";
  static String apiSubmitImage = "mobileapp_ws_submitimage.php";
  static String apiUpdatePartsStatus = "mobileapp_ws_updatepartsstatus.php";
  static String apiGetWorkOrders = "mobileapp_get_work_orders.php";
  static String apiSubmitWorkOrders = "mobileapp_submit_work_orders.php";
  static String apiUploadStockReconcile = "mobileapp_ws_stocktake_json.php";

  static Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json'
  };

  static Map<String, dynamic> baseQueryParams = {};
  static Future<bool> fetchParamsFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') != null) {
      baseQueryParams = jsonDecode(prefs.getString('userData').toString());
      AppConfig.username = baseQueryParams['username'];
      AppConfig.clientId = baseQueryParams['clientid'];
      AppConfig.password = baseQueryParams['password'];
       AppConfig.deviceId = baseQueryParams['deviceid'];
     AppConfig.appVersion = baseQueryParams['appversion'];
     AppConfig.osVersion = baseQueryParams['osversion'];
     AppConfig.deviceName = baseQueryParams['devicename'];
      print("Query Params from storage $baseQueryParams");
      return true;
    }
    return false;
  }

  static uploadParamsToStorage(Map<String, dynamic> queryParams) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = jsonEncode(queryParams);
    prefs.setString('userData', user);
    baseQueryParams = queryParams;
    AppConfig.username = baseQueryParams['username'];
    AppConfig.clientId = baseQueryParams['clientid'];
    AppConfig.password = baseQueryParams['password'];
  }
}
