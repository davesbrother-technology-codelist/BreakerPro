import 'package:breaker_pro/dataclass/part.dart';
import 'package:flutter/cupertino.dart';

import '../api/api_call.dart';

class PartsList with ChangeNotifier {
  List<Part> partList = [];

  Future<List<Part>> loadParts(
      String url, Map<String, dynamic> queryParams) async {
    final Map<String, dynamic> responseJson =
        await ApiCall.get(url, queryParams);
    List l = responseJson['Partslist'] as List;
    partList =
        List<Part>.generate(l.length, (index) => Part.fromJson(l[index]));
    notifyListeners();
    return partList;
  }
}
