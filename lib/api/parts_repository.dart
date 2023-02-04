import 'dart:convert';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../app_config.dart';
import '../dataclass/part.dart';
import '../notification_service.dart';
import 'api_config.dart';

class PartRepository {
  static Future<bool> uploadParts(
      List<Part> partsList, String vehicleID, String model) async {
    Map response = {};
    for (int i = 0; i < partsList.length; i++) {
      Part part = partsList[i];
      if(part.status != ""){
        continue;
      }
      NotificationService().instantNofitication(
          "3/5 - Uploading Parts Data $model ${partsList[i].partName}");

      // Map m = {...ApiConfig.baseQueryParams, ...part.toJson()};
      Map m = {...part.toJson()};
      m['appversion'] = ApiConfig.baseQueryParams['appversion'];
      m['osversion'] = ApiConfig.baseQueryParams['osversion'];
      m['deviceid'] = ApiConfig.baseQueryParams['deviceid'];
      m['Clientid'] = ApiConfig.baseQueryParams['clientid'];
      m['Username'] = ApiConfig.baseQueryParams['username'];
      m['VehicleID'] = vehicleID;
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
      msg += "App version:${ApiConfig.baseQueryParams['appversion']}\n";
      msg += "OsVersion:${ApiConfig.baseQueryParams['osversion']}\n";
      msg += "Clientid:${ApiConfig.baseQueryParams['clientid']}\n";
      msg += "Username:${ApiConfig.baseQueryParams['username']}\n";
      msg += "VehicleID:$vehicleID\n";
      msg += "${partsList[i].addLog()}\n";
      msg += "Ebay_Title ${partsList[i].ebayTitle}\n";
      msg += "status: ${m['status']}\n";
      var r = await http.post(
        url,
        body: m,
      );
      print("Parts Upload");
      print(r.body);
      response = jsonDecode(r.body);
      msg += "\n${r.body}\n";
      Box<Part> box1 = await Hive.openBox('uploadPartListBox$vehicleID');
      await box1.putAt(i, part);
      box1.close();
      final File file = File(
          '${AppConfig.externalDirectory!.path}/UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}.txt');
      await file.writeAsString(msg, mode: FileMode.append);

    }

    if (response['result'] == "Inserted Successfully") {
      Fluttertoast.showToast(msg: "Parts Upload Successful");
      return true;
    }
    return true;
    // } else {
    //   Fluttertoast.showToast(msg: "Failed to Upload Parts");
    //   return false;
    // }
  }

  static Future<void> updateParts(
      List<Part> partsList, String vehicleID, String model) async {
    Map response = {};
    for (int i = 0; i < partsList.length; i++) {
      NotificationService().instantNofitication(
          "5/5 - Updating Parts Data $model ${partsList[i].partName}");
      Part part = partsList[i];

      // Map m = {...ApiConfig.baseQueryParams, ...part.toJson()};
      Map m = {};
      m['appversion'] = ApiConfig.baseQueryParams['appversion'];
      m['osversion'] = ApiConfig.baseQueryParams['osversion'];
      m['deviceid'] = ApiConfig.baseQueryParams['deviceid'];
      m['ClientID'] = ApiConfig.baseQueryParams['clientid'];
      m['VehicleID'] = vehicleID;
      m['PartID'] = part.partId;
      m['devicename'] = ApiConfig.baseQueryParams['devicename'];
      print("Body of api call:\n$m\n Body Ends");
      Uri url = Uri.parse(
          "${ApiConfig.baseUrl}${ApiConfig.apiUpdatePartsStatus}?ClientID=${ApiConfig.baseQueryParams['clientid']}+VehicleID=$vehicleID");
      String msg = "\n\nUpdating Parts:\n\nURL:${url.toString()}\nParams:\n\n";
      msg += "deviceId:${ApiConfig.baseQueryParams['deviceid']}\n";
      msg += "appversion:${ApiConfig.baseQueryParams['appversion']}\n";
      msg += "osversion:${ApiConfig.baseQueryParams['osversion']}\n";
      msg += "ClientID:${ApiConfig.baseQueryParams['clientid']}\n";
      msg += "VehicleID:$vehicleID\n";
      msg += "PartID:${part.partId}\n";
      msg += "devicename:${ApiConfig.baseQueryParams['devicename']}\n";
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

      //   FlutterLogs.logToFile(
      //       logFileName: "UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}",
      //       overwrite: false,
      //       logMessage: msg);
    }

    // if (response['result'] == "Inserted Successfully") {
    //   Fluttertoast.showToast(msg: "Parts Upload Successful");
    //   return true;
    // } else {
    //   Fluttertoast.showToast(msg: "Failed to Upload Parts");
    //   return false;
    // }
  }

  static fileUpload(
      List<Part> partsList, String vehicleID, String model) async {

    List<Part> updatePartsList = [];
    print("\n\n Uploading Parts Photos\n\n");
    int j = 0;
    int t = 0;
    for (Part part in partsList) {
      t += part.imgList.length;
    }

    for (Part part in partsList) {
      if (part.imgList.isNotEmpty) {
        updatePartsList.add(part);
      }

      print(part);

      // List<File> imgList = List.generate(
      //     part.imgList.length, (index) => File(part.imgList[index]));

      Uri uri = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiSubmitImage);

      for (int i = 0; i < part.imgList.length; i++) {
        j += 1;
        if(part.imgList[i].isEmpty){
          continue;
        }
        String msg =
            "\n\n\n--Uploading Parts Image--\n\n\nImage Uploading PartID ${part.partId}\n";
        msg += "URL: $uri";
        NotificationService().instantNofitication(
            "4/5 - Uploading Part Images $j/$t $model ${part.partName}");
        File initialImage = File(part.imgList[i]);
        String dir = path.dirname(initialImage.path);
          int count = PartsList.partCount;
          String newPath = path.join(dir,
              'IMGPRT${DateFormat('yyyyMMddHHmmss').format(DateTime.now().add(Duration(seconds: i)))}${count.toString().padLeft(4, '0')}$count${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
        File image = initialImage.copySync(newPath);
        print(image.path);
        String filename = image.path.split("/").last.toString();
        print(filename);
        msg += "\nFilename: $filename\n\nParams:\n";
        msg += "\nClientID: ${ApiConfig.baseQueryParams['clientid']}";
        msg += "\nVehicleID: $vehicleID";
        msg += "\nPartID: ${part.partId}";
        msg += "\nfile: $filename";
        msg += "\nappversion: ${ApiConfig.baseQueryParams['appversion']}";
        msg += "\ndeviceid: ${ApiConfig.baseQueryParams['deviceid']}";
        msg += "\nosversion: ${ApiConfig.baseQueryParams['osversion']}";

        Map<String, dynamic>? queryParams = {
          "ClientID": ApiConfig.baseQueryParams['clientid'],
          "VehicleID": vehicleID,
          "PartID": part.partId,
          "appversion": ApiConfig.baseQueryParams['appversion'],
          "deviceid": ApiConfig.baseQueryParams['devideid'],
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
        Box<Part> box1 = await Hive.openBox('uploadPartListBox$vehicleID');
        part.imgList[i] = "";
        await box1.put(part.partName, part);

        msg += "\n$responseString\n";
        final File file = File(
            '${AppConfig.externalDirectory!.path}/UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}.txt');
        await file.writeAsString(msg, mode: FileMode.append);
      }
    }

    await updateParts(updatePartsList, vehicleID, model);
    print("Hello");

    return true;
  }
}
