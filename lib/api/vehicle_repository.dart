import 'dart:convert';
import 'dart:io';
import 'package:breaker_pro/app_config.dart';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:breaker_pro/utils/auth_utils.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import '../dataclass/parts_list.dart';
import '../dataclass/vehicle.dart';
import '../notification_service.dart';
import '../utils/main_dashboard_utils.dart';
import 'api_call.dart';
import 'api_config.dart';
import 'package:async/async.dart';

class VehicleRepository {
  static Future<bool> uploadVehicle(Vehicle vehicle) async {
    NotificationService().instantNofitication("1/5 - Uploading Vehicle Data");
    Map m = {...ApiConfig.baseQueryParams, ...vehicle.toJson()};
    print(vehicle.toJson());
    var r = await http.post(
      Uri.parse(
          "${ApiConfig.baseUrl}${ApiConfig.apiSubmitVehicle}?ClientID=${ApiConfig.baseQueryParams['clientid']}"),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      body: m,
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
    List<File> imgList = List.generate(ImageList.vehicleImgList.length,
        (index) => File(ImageList.vehicleImgList[index]));
    Uri uri = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiSubmitImage);

    for (int i = 0; i < imgList.length; i++) {
      File image = imgList[i];
      NotificationService().instantNofitication(
          "2/5 - Uploading Vehicle Images ${i + 1}/${imgList.length}");
      print(image.path);
      String filename = image.path.split("/").last.toString();
      print(filename);

      Map<String, dynamic>? queryParams = {
        "ClientID": ApiConfig.baseQueryParams['clientid'],
        "VehicleID": vehicle.vehicleId,
        "PartID": "",
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

  static Future<bool> findVehicleFromVRN(String vrn) async {
    Map<String, dynamic> queryParams = ApiConfig.baseQueryParams;
    queryParams['VRN'] = vrn;

    String url = ApiConfig.baseUrl + ApiConfig.apiVrnLookup;

    Map<String, dynamic> response = await ApiCall.get(url, queryParams);
    try {
      if (response["status"] == "Success") {
        response = response["result"];
        Vehicle vehicle = Vehicle();
        var a = response["doors"] == null ? "" : "${response["doors"]} DOOR ";
        vehicle.registrationNumber = response["registration"];
        vehicle.make = response["make"] ?? "";
        vehicle.cc = response["enginecapacity"] ?? "";
        vehicle.model = response["model"] ?? "";
        vehicle.fuel = response["fuelType"] ?? "";
        vehicle.bodyStyle = a + response["bodyType"] ?? "";
        vehicle.vin = response["chassisnumber"] ?? "";
        vehicle.colour =
            response["colour"].runtimeType == String ? response["colour"] : "";
        vehicle.transmission = response["transmission"] ?? "";
        vehicle.engineCode = response["engine_code"] ?? "";
        vehicle.manufacturingYear = response["manufacturedate"] ?? "";
        vehicle.fromYear = response["Construction_from"] ?? "";
        vehicle.toYear = response["Construction_to"] ?? "";
        vehicle.ebayMake = vehicle.make;
        vehicle.ebayEngine = vehicle.cc.toString();
        vehicle.ebayModel = vehicle.model.toString();
        vehicle.ebayStyle = vehicle.bodyStyle;
        vehicle.ebayColor = response["colour"] ?? "";
        vehicle.weight =
            response["Weight"].runtimeType == String ? response["Weight"] : "";
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
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load data.");
      return false;
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
    if (response['vehicle']['result'] == 'No Stock Found') {
      Fluttertoast.showToast(msg: "Failed to load data");
      return false;
    }
    try {
      response = response["vehicle"]["result"];
      Vehicle vehicle = Vehicle();
      var a = response["doors"] == null ? "" : "${response["doors"]} DOOR ";
      vehicle.stockReference = stockref;
      vehicle.registrationNumber = response["VRN"];
      vehicle.make = response["DVLA_Make"] ?? "";
      vehicle.cc = response["EngineCapacity"] ?? "";
      vehicle.model = response["DVLA_Model"] ?? "";
      vehicle.fuel = response["FuelType"] ?? "";
      vehicle.bodyStyle = a + response["BodyStyle"] ?? "";
      vehicle.vin = response["VIN_Original_DVLA"] ?? "";
      vehicle.colour = response["ColourCurrent"] ?? "";
      vehicle.transmission = response["transmission"] ?? "";
      vehicle.engineCode = response["engine_code"] ?? "";
      vehicle.manufacturingYear = response["DateFirstRegistered"] ?? "";
      vehicle.fromYear = response["YearRangeOne"] ?? "";
      vehicle.toYear = response["YearRangeLast"] ?? "";
      vehicle.ebayMake = response["Ebay_Make"] ?? "";
      vehicle.ebayEngine = response["Ebay_CC"] ?? "";
      vehicle.ebayModel = response["Ebay_Model"] ?? "";
      vehicle.ebayStyle = response["Ebay_Style"] ?? "";
      vehicle.ebayColor = response["Ebay_Colour"] ?? "";
      vehicle.weight = response['data']['weight'] ?? "";
      vehicle.commentDetails = response["Details"] ?? "";
      vehicle.mileage = response["Mileage"] ?? "";
      vehicle.costPrice = response["VehCost"] ?? "";
      PartsList.uploadVehicle = vehicle;
      String model = vehicle.model == "" ? "Model" : vehicle.model;
      MainDashboardUtils.titleList[0] =
          "Resume Work ( ${vehicle.make}-${model} )";

      String vehicleString = jsonEncode(vehicle.toJson());
      PartsList.prefs!.setString("vehicle", vehicleString);
      print(PartsList.prefs!.getString("vehicle"));

      print("Stock LOOKUP ${MainDashboardUtils.titleList[0]}");
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load data");
      return false;
    }
  }
}
