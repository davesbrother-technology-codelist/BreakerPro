import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../dataclass/part.dart';
import 'api_config.dart';

class PartRepository {
  static Future<bool> uploadParts(List<Part> partsList) async {
    Map response = {};
    for (Part part in partsList) {
      Map m = {...ApiConfig.baseQueryParams, ...part.toJson()};
      Uri url = Uri.parse(
          "${ApiConfig.baseUrl}${ApiConfig.apiSubmitParts}?Clientid=${ApiConfig.baseQueryParams['clientid']}");
      var r = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(m),
      );
      print("Parts Upload");
      print(r.body);
      response = jsonDecode(r.body);
    }

    if (response['result'] == "Inserted Successfully") {
      Fluttertoast.showToast(msg: "Parts Upload Successful");
      return true;
    } else {
      Fluttertoast.showToast(msg: "Failed to Upload Parts");
      return false;
    }
  }
}
