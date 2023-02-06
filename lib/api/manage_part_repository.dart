import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_config.dart';
import 'package:path/path.dart' as path;
import '../dataclass/part.dart';
import '../dataclass/stock.dart';
import '../notification_service.dart';
import 'api_config.dart';
import 'dart:io';

class ManagePartRepository {
  static Future<bool> uploadPart(Part part, Stock stock) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Box<Part> box = await Hive.openBox('manageParts');
    Map response = {};
    if(part.status != ""){
      if(part.imgList.isNotEmpty){
        await fileUpload(part, stock);
        await updatePart(part, stock);
      }
      if(!box.isOpen){
        box = await Hive.openBox('manageParts');
      }
      await box.delete(part.partId);
      await prefs.remove(part.partId);
      List<String>? l = prefs.getStringList('uploadManagePartQueue');
      l!.remove(part.partId);
      await prefs.setStringList("uploadManagePartQueue", l);
      NotificationService().instantNofitication(
          "Upload Complete",playSound: true);
      return true;
    }
    NotificationService().instantNofitication(
        "1/3 - Uploading Parts Data\n\n${part.partName}\n${stock.stockID}");
    Map m = {...part.toStockJson(stock)};
    m['appversion'] = AppConfig.appVersion;
    m['osversion'] = ApiConfig.baseQueryParams['osversion'];
    m['deviceid'] = ApiConfig.baseQueryParams['deviceid'];
    m['Clientid'] = ApiConfig.baseQueryParams['clientid'];
    m['Username'] = ApiConfig.baseQueryParams['username'];
    m['VehicleID'] = stock.vehicleId;
    if (part.imgList.isEmpty) {
      m['status'] = "Pending";
      part.status = "Pending";
    } else {
      m['status'] = "Uploading";
      part.status = "Uploading";

    }
    print("Body of api call:\n$m\n Body Ends");
    Uri url = Uri.parse("${ApiConfig.baseUrl}${ApiConfig.apiSubmitParts}");
    String msg = "\n\nUploading Parts:\n\nURL:${url.toString()}\nParams:\n\n";
    msg += "DeviceId:${ApiConfig.baseQueryParams['deviceid']}\n";
    msg += "App version:${AppConfig.appVersion}\n";
    msg += "OsVersion:${ApiConfig.baseQueryParams['osversion']}\n";
    msg += "Clientid:${ApiConfig.baseQueryParams['clientid']}\n";
    msg += "Username:${ApiConfig.baseQueryParams['username']}\n";
    msg += "VehicleID:${stock.vehicleId}\n";
    msg += "${part.addStockLog(stock)}\n";
    msg += "Ebay_Title ${part.ebayTitle}\n";
    msg += "status: ${m['status']}\n";
    var r = await http.post(
      url,
      body: m,
    );
    print("Parts Upload");
    print(r.body);
    response = jsonDecode(r.body);
    msg += "\nResponse: ${r.body}\n";
    print(msg);
    final File file = File(
        '${AppConfig.externalDirectory!.path}/UPLOAD_MANAGE_PARTS_${DateFormat("ddMMyy").format(DateTime.now())}.txt');
    await file.writeAsString(msg, mode: FileMode.append);

    if (response['result'] == "Inserted Successfully") {
      await box.put(part.partId, part);
      Fluttertoast.showToast(msg: "Parts Upload Successful");
      if(part.imgList.isNotEmpty){
        await fileUpload(part, stock);
        await updatePart(part, stock);
      }
      if(!box.isOpen){
        box = await Hive.openBox('manageParts');
      }
      await box.delete(part.partId);
      await prefs.remove(part.partId);
      List<String>? l = prefs.getStringList('uploadManagePartQueue');
      l!.remove(part.partId);
      await prefs.setStringList("uploadManagePartQueue", l);

      NotificationService().instantNofitication(
          "Upload Complete",playSound: true);
      return true;
    } else {
      Fluttertoast.showToast(msg: "Failed to Upload Parts");
      return false;
    }
  }

  static fileUpload(
      Part part, Stock stock) async {
    Box<Part> box = await Hive.openBox('manageParts');
    print("\n\n Uploading Parts Photos\n\n");
    int t = part.imgList.length;
    // List<File> imgList = List.generate(
    //       part.imgList.length, (index) => File(part.imgList[index]));
    Uri uri = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiSubmitImage);
    for (int i = 0; i < part.imgList.length; i++) {
      if(part.imgList[i].isEmpty){
        continue;
      }
      NotificationService().instantNofitication(
          "2/3 - Uploading Part Images ${i+1}/$t \n${part.partName}\n${stock.stockID}");
      String msg =
          "\n\n\n--Uploading Parts Image--\n\n\nImage Uploading PartID ${part.partId}\n";
      msg += "URL: $uri";
      File initialImage = File(part.imgList[i]);
      String dir = path.dirname(initialImage.path);
      String newPath = path.join(dir,
          'IMG${stock.stockID}1${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
      File image = initialImage.copySync(newPath);
      print(image.path);
      String filename = image.path.split("/").last.toString();
      print(filename);
      msg += "\nFilename: $filename\n\nParams:\n";
      msg += "\nClientID: ${ApiConfig.baseQueryParams['clientid']}";
      msg += "\nVehicleID: ${stock.vehicleId}";
      msg += "\nPartID: ${part.partId}";
      msg += "\nfile: $filename";
      msg += "\nappversion: ${AppConfig.appVersion}";
      msg += "\ndeviceid: ${AppConfig.deviceId}";
      msg += "\nosversion: ${ApiConfig.baseQueryParams['osversion']}";

      Map<String, dynamic>? queryParams = {
        "ClientID": ApiConfig.baseQueryParams['clientid'],
        "VehicleID": stock.vehicleId,
        "PartID": part.partId,
        "BPPartID": stock.stockID,
        "appversion": AppConfig.appVersion,
        "deviceid": AppConfig.deviceId,
        "osversion": ApiConfig.baseQueryParams['osversion'],
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
      part.imgList[i] = "";
      await box.put(part.partId, part);

      msg += "\n$responseString\n";
      print(msg);
      final File file = File(
          '${AppConfig.externalDirectory!.path}/UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}.txt');
      await file.writeAsString(msg, mode: FileMode.append);

    }
  }

  static updatePart(Part part, Stock stock) async {

      NotificationService().instantNofitication(
          "3/3 - Updating Part Data\n${part.partName}\n${stock.stockID}");

      Map m = {};
      m['appversion'] = AppConfig.appVersion;
      m['osversion'] = AppConfig.osVersion;
      m['deviceid'] = AppConfig.deviceId;
      m['ClientID'] = AppConfig.clientId;
      m['VehicleID'] = stock.vehicleId;
      m['PartID'] = part.partId;
      m['devicename'] = AppConfig.deviceName;

      print("Body of api call:\n$m\n Body Ends");
      Uri url = Uri.parse(
          "${ApiConfig.baseUrl}${ApiConfig.apiUpdatePartsStatus}?ClientID=${ApiConfig.baseQueryParams['clientid']}+VehicleID=${stock.vehicleId}");
      String msg = "\n\nUpdating Parts:\n\nURL:${url.toString()}\nParams:\n\n";
      msg += "deviceId:${AppConfig.deviceId}\n";
      msg += "appversion:${AppConfig.appVersion}\n";
      msg += "osversion:${AppConfig.osVersion}\n";
      msg += "ClientID:${AppConfig.clientId}\n";
      msg += "VehicleID:${stock.vehicleId}\n";
      msg += "PartID:${part.partId}\n";
      msg += "devicename:${AppConfig.deviceName}\n";
      // msg += "${partsList[i].addLog()}\n";
      // msg += "Ebay_Title ${partsList[i].ebayTitle}\n";
      var r = await http.post(
        url,
        body: m,
      );
      print("Parts Update");
      print(r.body);
      // response = jsonDecode(r.body);
      msg += "\n${r.body}\n";
      final File file = File(
          '${AppConfig.externalDirectory!.path}/UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}.txt');
      await file.writeAsString(msg, mode: FileMode.append);



  }
}
