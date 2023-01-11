import 'dart:convert';
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

  // static fileUpload(List<Part> partsList) async {
  //   print("\n\n Uploading Photos\n\n");
  //   // List<File> imgList = List.generate(partsList.length,
  //   //         (index) => File(partsList[index].im));
  //   Uri uri = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiSubmitImage);
  //
  //   for (int i = 0; i < imgList.length; i++) {
  //     File image = imgList[i];
  //     NotificationService().instantNofitication("2/5 - Uploading Vehicle Images ${i+1}/${imgList.length}");
  //     print(image.path);
  //     String filename = image.path.split("/").last.toString();
  //     print(filename);
  //
  //     Map<String, dynamic>? queryParams = {
  //       "ClientID": ApiConfig.baseQueryParams['clientid'],
  //       "VehicleID": vehicle.vehicleId,
  //       "PartID": "",
  //       // "appversion": ApiConfig.baseQueryParams['appversion'],
  //       // "deviceid": AppConfig.deviceId,
  //       // "osversion": ApiConfig.baseQueryParams['osversion'],
  //       "file": filename,
  //     };
  //     uri = uri.replace(queryParameters: queryParams);
  //     print(uri);
  //     var request = http.MultipartRequest("POST", uri)
  //       ..fields['ClientID'] = ApiConfig.baseQueryParams['clientid'];
  //
  //     var pic = await http.MultipartFile.fromPath("uploadedfile", image.path);
  //     request.files.add(pic);
  //
  //     var response = await request.send();
  //     var responseData = await response.stream.toBytes();
  //     var responseString = String.fromCharCodes(responseData);
  //
  //     print(response.statusCode);
  //     print(responseString);
  //   }
  // }
}
