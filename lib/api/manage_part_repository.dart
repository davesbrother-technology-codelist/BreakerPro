import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../app_config.dart';
import '../dataclass/part.dart';
import '../dataclass/stock.dart';
import '../notification_service.dart';
import 'api_config.dart';
import 'dart:io';

class ManagePartRepository {
  static Future<bool> uploadPart(Part part, Stock stock) async {
    Map response = {};
    NotificationService().instantNofitication(
        "1/3 - Uploading Parts Data ${stock.model} ${part.partName}");
    Map m = {...part.toStockJson(stock)};
    m['appversion'] = ApiConfig.baseQueryParams['appversion'];
    m['osversion'] = ApiConfig.baseQueryParams['osversion'];
    m['deviceid'] = ApiConfig.baseQueryParams['deviceid'];
    m['Clientid'] = ApiConfig.baseQueryParams['clientid'];
    m['Username'] = ApiConfig.baseQueryParams['username'];
    m['VehicleID'] = stock.vehicleId;
    if (part.imgList.isEmpty) {
      m['status'] = "Pending";
    } else {
      m['status'] = "Uploading";
    }
    print("Body of api call:\n$m\n Body Ends");
    Uri url = Uri.parse("${ApiConfig.baseUrl}${ApiConfig.apiSubmitParts}");
    String msg = "\n\nUploading Parts:\n\nURL:${url.toString()}\nParams:\n\n";
    msg += "DeviceId:${ApiConfig.baseQueryParams['deviceid']}\n";
    msg += "App version:${ApiConfig.baseQueryParams['appversion']}\n";
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
      Fluttertoast.showToast(msg: "Parts Upload Successful");

      return true;
    } else {
      Fluttertoast.showToast(msg: "Failed to Upload Parts");
      return false;
    }
  }

  static fileUpload(
      Part part, Stock stock) async {
    print("\n\n Uploading Parts Photos\n\n");
    int t = part.imgList.length;


      List<File> imgList = List.generate(
          part.imgList.length, (index) => File(part.imgList[index]));
      Uri uri = Uri.parse(ApiConfig.baseUrl + ApiConfig.apiSubmitImage);
      for (int i = 0; i < imgList.length; i++) {
        NotificationService().instantNofitication(
            "4/5 - Uploading Part Images ${i+1}/$t ${stock.model} ${part.partName}");
        String msg =
            "\n\n\n--Uploading Parts Image--\n\n\nImage Uploading PartID ${part.partId}\n";
        msg += "URL: $uri";
        File image = imgList[i];
        print(image.path);
        String filename = image.path.split("/").last.toString();
        print(filename);
        msg += "\nFilename: $filename\n\nParams:\n";
        msg += "\nClientID: ${ApiConfig.baseQueryParams['clientid']}";
        msg += "\nVehicleID: ${stock.vehicleId}";
        msg += "\nPartID: ${part.partId}";
        msg += "\nfile: $filename";
        msg += "\nappversion: ${ApiConfig.baseQueryParams['appversion']}";
        msg += "\ndeviceid: ${AppConfig.deviceId}";
        msg += "\nosversion: ${ApiConfig.baseQueryParams['osversion']}";

        Map<String, dynamic>? queryParams = {
          "ClientID": ApiConfig.baseQueryParams['clientid'],
          "VehicleID": {stock.vehicleId},
          "PartID": part.partId,
          "BPPartID": {stock.stockID},
          "appversion": ApiConfig.baseQueryParams['appversion'],
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

        msg += "\n$responseString\n";
        print(msg);
        final File file = File(
            '${AppConfig.externalDirectory!.path}/UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}.txt');
        await file.writeAsString(msg, mode: FileMode.append);

      }


  }
}
