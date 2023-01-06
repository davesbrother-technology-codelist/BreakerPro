import 'dart:convert';
import 'dart:io';
import 'package:breaker_pro/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import '../dataclass/vehicle.dart';
import 'api_config.dart';
import 'package:async/async.dart';

class VehicleRepository {
  static Future<bool> uploadVehicle(Vehicle vehicle) async {
    Map m = {...ApiConfig.baseQueryParams, ...vehicle.toJson()};
    var r = await http.post(
      Uri.parse(
          "${ApiConfig.baseUrl}${ApiConfig.apiSubmitVehicle}?ClientID=${ApiConfig.baseQueryParams['clientid']}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(m),
    );
    print("Vehicle Upload");
    print(r.body);
    Map response = jsonDecode(r.body);

    if (response['Result'] == "Inserted Successfully") {
      Fluttertoast.showToast(msg: "Vehicle Upload Successful");
      return true;
    } else {
      Fluttertoast.showToast(msg: "Failed to Upload Vehicle");
      return false;
    }
  }

  static fileUpload(Vehicle vehicle) async {
    print("\n\n Uploading Photos\n\n");
    Uri uri = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiSubmitImage);
    Map<String, dynamic>? queryParams = {
      "ClientID": ApiConfig.baseQueryParams['clientid'],
      "VehicleID": vehicle.vehicleId,
      "PartID": "",
      "appversion": ApiConfig.baseQueryParams['appversion'],
      "deviceid": AppConfig.deviceId,
      "osversion": ApiConfig.baseQueryParams['osversion'],
    };
    uri = uri.replace(queryParameters: queryParams);
    List<File> l = List.generate(
        vehicle.imgList.length, (index) => File(vehicle.imgList[index]));
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(ApiConfig.headers);

    //adding params
    request.fields['ClientID'] = ApiConfig.baseQueryParams['clientid'];
    request.fields['VehicleID'] = vehicle.vehicleId;
    request.fields['PartID'] = '';
    request.fields['appversion'] = ApiConfig.baseQueryParams['appversion'];
    request.fields['deviceid'] = AppConfig.deviceId;
    request.fields['osversion'] = ApiConfig.baseQueryParams['osversion'];
    // request.fields['Image file'] = l[0].path;

    for (File f in l) {
      print(f.path);
      var pic =
          await http.MultipartFile.fromPath("file", f.path, filename: f.path);
      request.files.add(pic);
    }

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);

    var stream = http.ByteStream(
        DelegatingStream.typed(File(vehicle.imgList[0]).openRead()));
    var length = await File(vehicle.imgList[0]).length();

    var requestt = http.MultipartRequest("POST", uri);
    requestt.fields['ClientID'] = ApiConfig.baseQueryParams['clientid'];
    requestt.fields['VehicleID'] = vehicle.vehicleId;
    requestt.fields['PartID'] = '';
    requestt.fields['appversion'] = ApiConfig.baseQueryParams['appversion'];
    requestt.fields['deviceid'] = AppConfig.deviceId;
    requestt.fields['osversion'] = ApiConfig.baseQueryParams['osversion'];
    requestt.fields['file'] = vehicle.imgList[0];
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(File(vehicle.imgList[0]).path));
    //contentType: new MediaType('image', 'png'));

    requestt.files.add(multipartFile);
    var responsee = await requestt.send();
    print(responsee.statusCode);
    responsee.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
