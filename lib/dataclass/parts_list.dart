import 'package:breaker_pro/dataclass/part.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../api/api_call.dart';

class PartsList {
  static List<Part> partList = [];

  Future<bool> loadParts(String url, Map<String, dynamic> queryParams) async {
    Box<Part> box = await Hive.openBox('partsBox');
    if (box.isEmpty) {
      final Map<String, dynamic> responseJson =
          await ApiCall.get(url, queryParams);
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
