import 'package:breaker_pro/dataclass/part.dart';
import 'package:breaker_pro/dataclass/vehicle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_call.dart';

class PartsList {
  static List<Part> partList = [];
  static List<Part> selectedPartList = [];
  static List<Part> uploadPartList = [];
  static Vehicle? uploadVehicle;
  static bool recall = false;
  static SharedPreferences? prefs;
  static int vehicleCount = 1;
  static int partCount = 1;

  Future<bool> loadParts(String url, Map<String, dynamic> queryParams) async {
    Box<Part> box = await Hive.openBox('partsBox');
    if (box.isEmpty) {
      final Map<String, dynamic> responseJson =
          await ApiCall.get(url, queryParams);

      FlutterLogs.logToFile(
          logFileName: "LOGGER${DateFormat("ddMMyy").format(DateTime.now())}",
          overwrite: false,
          logMessage:
              "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())} PART LIST $url Success $responseJson\n");
      List l = responseJson['Partslist'] as List;
      partList =
          List<Part>.generate(l.length, (index) => Part.fromJson(l[index]));
      Map<dynamic, Part> boxMap = {
        for (var part in partList) part.partName: part
      };
      box.putAll(boxMap);
      print("Added parts to HIVE");
      // notifyListeners();
      return true;
    }
    print("Parts from HIVE");
    partList = box.values.toList();
    return true;
  }
}
