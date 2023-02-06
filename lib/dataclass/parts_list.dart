import 'package:breaker_pro/dataclass/part.dart';
import 'package:breaker_pro/dataclass/vehicle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_call.dart';
import '../app_config.dart';
import 'dart:io';

class PartsList {
  static List<Part> partList = [];
  static List<Part> selectedPartList = [];
  static List<Part> uploadPartList = [];
  static Vehicle? cachedVehicle;
  static bool recall = false;
  static SharedPreferences? prefs;
  static int vehicleCount = 1;
  static int partCount = 1;
  static List<String> uploadQueue = [];
  static bool isStockRef = false;
  static bool saveVehicle = true;
  static bool isUploading = false;
  static bool newAdded = false;

  Future<bool> loadParts(String url, Map<String, dynamic> queryParams) async {
    Box<Part> box = await Hive.openBox('partsBox');
    if (box.isEmpty) {
      final Map<String, dynamic> responseJson =
          await ApiCall.get(url, queryParams);

      final File file = File(
          '${AppConfig.externalDirectory!.path}/LOGGER${DateFormat("ddMMyy").format(DateTime.now())}.txt');
      await file.writeAsString(
          "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())} PART LIST $url Success $responseJson\n",
          mode: FileMode.append);
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
    // List l = [];
    partList = box.values.toList();
    // for(Part part in partList){
    //   l += part.postageOptions.split(',');
    //   print(part.postageOptions.split(','));
    // }
    // print(l.toSet().toList());
    return true;
  }
}
