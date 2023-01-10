import 'dart:convert';
import 'dart:io';
import 'package:breaker_pro/app_config.dart';
import 'package:breaker_pro/utils/auth_utils.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import '../dataclass/parts_list.dart';
import '../dataclass/vehicle.dart';
import '../utils/main_dashboard_utils.dart';
import 'api_call.dart';
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
    List<File> imgList = List.generate(
        vehicle.imgList.length, (index) => File(vehicle.imgList[index]));
    Uri uri = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiSubmitImage);

    for (File image in imgList) {
      print(image.path);
      String filename = image.path.split("/").last.toString();
      print(filename);

      Map<String, dynamic>? queryParams = {
        "ClientID": ApiConfig.baseQueryParams['clientid'],
        "VehicleID": vehicle.vehicleId,
        "PartID": "",
        "appversion": ApiConfig.baseQueryParams['appversion'],
        "deviceid": AppConfig.deviceId,
        "osversion": ApiConfig.baseQueryParams['osversion'],
        "file": filename,
      };
      uri = uri.replace(queryParameters: queryParams);
      print(uri);
      var request = http.MultipartRequest("POST", uri)
        ..fields['ClientID'] = "1024";

      //adding params
      // request.fields['ClientID'] = ApiConfig.baseQueryParams['clientid'];
      request.headers["Authorization"] = ApiConfig.baseQueryParams['clientid'];
      // request.headers["ClientID"] = ApiConfig.baseQueryParams['clientid'];

      var pic = await http.MultipartFile.fromPath("uploadedfile", image.path,
          filename: filename);
      request.files.add(pic);

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      print(response.statusCode);
      print(responseString);
    }
  }

  static Future<bool> findVehicleFromVRN(String vrn) async {
    Map<String, dynamic> queryParams = ApiConfig.baseQueryParams;
    queryParams['VRN'] = vrn;

    String url = ApiConfig.baseUrl + ApiConfig.apiVrnLookup;

    Map<String, dynamic> response = await ApiCall.get(url, queryParams);

    if (response["status"] == "Success") {
      response = response["result"];
      Vehicle vehicle = Vehicle();
      var a = response["doors"] == null ? "" : "${response["doors"]} DOOR ";
      List color = response["colour"];
      List weight = response["Weight"];
      vehicle.registrationNumber = response["registration"];
      vehicle.make = response["make"] ?? "";
      vehicle.cc = response["enginecapacity"] ?? "";
      vehicle.model = response["model"] ?? "";
      vehicle.fuel = response["fuelType"] ?? "";
      vehicle.bodyStyle = a + response["bodyType"] ?? "";
      vehicle.vin = response["chassisnumber"] ?? "";
      vehicle.colour = color.isNotEmpty ? color.first.toString() : "";
      vehicle.transmission = response["transmission"] ?? "";
      vehicle.engineCode = response["engine_code"] ?? "";
      vehicle.manufacturingYear = response["manufacturedate"] ?? "";
      vehicle.fromYear = response["Construction_from"] ?? "";
      vehicle.toYear = response["Construction_to"] ?? "";
      vehicle.ebayMake = vehicle.make;
      vehicle.ebayEngine = vehicle.cc.toString();
      vehicle.ebayModel = vehicle.model.toString();
      vehicle.ebayStyle = vehicle.bodyStyle;
      vehicle.ebayColor = vehicle.colour;
      vehicle.weight = weight.isNotEmpty ? weight.first.toString() : "";
      vehicle.commentDetails = response["description"] ?? "";
      PartsList.uploadVehicle = vehicle;
      String model = vehicle.model == "" ? "Model" : vehicle.model;
      MainDashboardUtils.titleList[0] =
          "Resume Work ( ${vehicle.make}-${model} )";

      String vehicleString = jsonEncode(vehicle.toJson());
      PartsList.prefs!.setString("vehicle", vehicleString);
      print(PartsList.prefs!.getString("vehicle"));

      print("Vehicle LOOKUP ${MainDashboardUtils.titleList[0]}");
      return true;
    }

    if (response["result"]["message"] ==
        "We could not process your request, check your submission for 'registration' it's minimum length needs to be at least 2 characters, your entry was 1 characters long.") {
      Fluttertoast.showToast(msg: response["result"]["message"]);
    } else {
      Fluttertoast.showToast(msg: "Failed to load data.");
    }

    return false;
  }

  static Future<bool> findVehicleFromStock(String stockref) async {
    Map<String, dynamic> queryParams = ApiConfig.baseQueryParams;
    queryParams['stockref'] = stockref;
    queryParams['searchby'] = "part";

    String url = ApiConfig.baseUrl + ApiConfig.apiStockRefLookup;

    Map<String, dynamic> response = await ApiCall.get(url, queryParams);

    if (response["vehicle"]["result"] == "Success") {
      response = response["vehicle"];
      Vehicle vehicle = Vehicle();
      var a = response["doors"] == null ? "" : "${response["doors"]} DOOR ";
      List color = response["colour"];
      List weight = response["Weight"];
      vehicle.registrationNumber = response["registration"];
      vehicle.make = response["make"] ?? "";
      vehicle.cc = response["enginecapacity"] ?? "";
      vehicle.model = response["model"] ?? "";
      vehicle.fuel = response["fuelType"] ?? "";
      vehicle.bodyStyle = a + response["bodyType"] ?? "";
      vehicle.vin = response["chassisnumber"] ?? "";
      vehicle.colour = color.isNotEmpty ? color.first.toString() : "";
      vehicle.transmission = response["transmission"] ?? "";
      vehicle.engineCode = response["engine_code"] ?? "";
      vehicle.manufacturingYear = response["manufacturedate"] ?? "";
      vehicle.fromYear = response["Construction_from"] ?? "";
      vehicle.toYear = response["Construction_to"] ?? "";
      vehicle.ebayMake = vehicle.make;
      vehicle.ebayEngine = vehicle.cc.toString();
      vehicle.ebayModel = vehicle.model.toString();
      vehicle.ebayStyle = vehicle.bodyStyle;
      vehicle.ebayColor = vehicle.colour;
      vehicle.weight = weight.isNotEmpty ? weight.first.toString() : "";
      vehicle.commentDetails = response["description"] ?? "";
      PartsList.uploadVehicle = vehicle;
      String model = vehicle.model == "" ? "Model" : vehicle.model;
      MainDashboardUtils.titleList[0] =
          "Resume Work ( ${vehicle.make}-${model} )";

      String vehicleString = jsonEncode(vehicle.toJson());
      PartsList.prefs!.setString("vehicle", vehicleString);
      print(PartsList.prefs!.getString("vehicle"));

      print("Stock LOOKUP ${MainDashboardUtils.titleList[0]}");
      return true;
    }

    return false;
  }
}
