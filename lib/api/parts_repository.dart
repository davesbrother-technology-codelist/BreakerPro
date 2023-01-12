import 'dart:convert';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'dart:io';
import '../dataclass/part.dart';
import '../notification_service.dart';
import 'api_config.dart';

class PartRepository {
  static Future<bool> uploadParts(List<Part> partsList) async {
    Map response = {};
    for (int i = 0; i < partsList.length; i++) {
      NotificationService().instantNofitication(
          "3/5 - Uploading Parts Data ${i + 1}/${partsList.length}");
      Part part = partsList[i];
      print(part.toJson());
      Map m = {...ApiConfig.baseQueryParams, ...part.toJson()};
      Uri url = Uri.parse(
          "${ApiConfig.baseUrl}${ApiConfig.apiSubmitParts}?Clientid=${ApiConfig.baseQueryParams['clientid']}");
      var r = await http.post(
        url,
        // headers: <String, dynamic>{
        //   'Content-Type': 'application/json; charset=UTF-8',
        // },
        body: m,
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

  static fileUpload(List<Part> partsList, String vehicleID) async {
    print("\n\n Uploading Parts Photos\n\n");
    int j = 1;
    int t = 0;
    for (Part part in partsList) {
      for (int i = 0; i < part.imgList.length; i++) {
        t += 1;
      }
    }

    for (Part part in partsList) {
      print(part);
      NotificationService()
          .instantNofitication("2/5 - Uploading Part Images ${j}/${t}");
      List<File> imgList = List.generate(
          part.imgList.length, (index) => File(part.imgList[index]));

      Uri uri = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiSubmitImage);

      for (int i = 0; i < imgList.length; i++) {
        File image = imgList[i];
        NotificationService().instantNofitication(
            "2/5 - Uploading Part Images ${i + 1}/${imgList.length}");
        print(image.path);
        String filename = image.path.split("/").last.toString();
        print(filename);

        Map<String, dynamic>? queryParams = {
          "ClientID": ApiConfig.baseQueryParams['clientid'],
          "VehicleID": vehicleID,
          "PartID": part.partId,
          // "appversion": ApiConfig.baseQueryParams['appversion'],
          // "deviceid": AppConfig.deviceId,
          // "osversion": ApiConfig.baseQueryParams['osversion'],
          "file": filename,
        };
        uri = uri.replace(queryParameters: queryParams);
        print(uri);
        var request = http.MultipartRequest("POST", uri)
          ..fields['ClientID'] = ApiConfig.baseQueryParams['clientid'];

        var pic = await http.MultipartFile.fromPath("uploadedfile", image.path);
        request.files.add(pic);

        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        print(response.statusCode);
        print(responseString);
      }
    }
  }
}
