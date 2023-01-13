import 'dart:convert';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../dataclass/part.dart';
import '../notification_service.dart';
import 'api_config.dart';

class PartRepository {
  static Future<bool> uploadParts(
      List<Part> partsList, String vehicleID) async {
    Map response = {};
    for (int i = 0; i < partsList.length; i++) {
      await FlutterLogs.initLogs(
          logLevelsEnabled: [
            LogLevel.INFO,
            LogLevel.WARNING,
            LogLevel.ERROR,
            LogLevel.SEVERE
          ],
          timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
          directoryStructure: DirectoryStructure.SINGLE_FILE_FOR_DAY,
          logTypesEnabled: [
            "UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}",
            "LOGGER${DateFormat("ddMMyy").format(DateTime.now())}",
            "${ApiConfig.baseQueryParams['username']}_${DateFormat("ddMMyy").format(DateTime.now())}"
          ],
          logFileExtension: LogFileExtension.TXT,
          logsWriteDirectoryName: "MyLogs",
          logsExportDirectoryName: "MyLogs/Exported",
          logsExportZipFileName:
              "Logger${DateFormat('dd_MM_YYYY').format(DateTime.now())}",
          debugFileOperations: true,
          isDebuggable: true);
      NotificationService().instantNofitication(
          "3/5 - Uploading Parts Data ${i + 1}/${partsList.length}");
      Part part = partsList[i];
      print(part.toJson());
      Map m = {...ApiConfig.baseQueryParams, ...part.toJson()};
      Uri url = Uri.parse(
          "${ApiConfig.baseUrl}${ApiConfig.apiSubmitParts}?Clientid=${ApiConfig.baseQueryParams['clientid']}");
      String msg = "\nUploading Parts:\n\nURL:${url.toString()}\nParams:\n\n";
      msg += "DeviceId:${ApiConfig.baseQueryParams['deviceid']}\n";
      msg += "App version:${ApiConfig.baseQueryParams['appversion']}\n";
      msg += "OsVersion:${ApiConfig.baseQueryParams['osversion']}\n";
      msg += "Clientid:${ApiConfig.baseQueryParams['clientid']}\n";
      msg += "Username:${ApiConfig.baseQueryParams['username']}\n";
      msg += "$vehicleID\n";
      msg += "${partsList[i].addLog()}\n";
      msg += "Ebay_Tile ${partsList[i].ebayTitle}\n";
      var r = await http.post(
        url,
        body: m,
      );
      print("Parts Upload");
      print(r.body);
      response = jsonDecode(r.body);
      msg += "\n${r.body}\n";
      FlutterLogs.logToFile(
          logFileName: "UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}",
          overwrite: false,
          logMessage: msg);
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
    await FlutterLogs.initLogs(
        logLevelsEnabled: [
          LogLevel.INFO,
          LogLevel.WARNING,
          LogLevel.ERROR,
          LogLevel.SEVERE
        ],
        timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
        directoryStructure: DirectoryStructure.SINGLE_FILE_FOR_DAY,
        logTypesEnabled: [
          "UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}",
          "LOGGER${DateFormat("ddMMyy").format(DateTime.now())}",
          "${ApiConfig.baseQueryParams['username']}_${DateFormat("ddMMyy").format(DateTime.now())}"
        ],
        logFileExtension: LogFileExtension.TXT,
        logsWriteDirectoryName: "MyLogs",
        logsExportDirectoryName: "MyLogs/Exported",
        logsExportZipFileName:
            "Logger${DateFormat('dd_MM_YYYY').format(DateTime.now())}",
        debugFileOperations: true,
        isDebuggable: true);
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
        String msg =
            "\n--Uploading Parts Image--\n\n\nImage Uploading PartID ${part.partId}\n";
        msg += "URL: $uri";
        File image = imgList[i];
        NotificationService().instantNofitication(
            "2/5 - Uploading Part Images ${i + 1}/${imgList.length}");
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

        msg += "\n$responseString\n";
        FlutterLogs.logToFile(
            logFileName:
                "UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}",
            overwrite: false,
            logMessage: msg);
      }
    }
  }
}
