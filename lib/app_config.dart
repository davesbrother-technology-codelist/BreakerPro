import 'package:device_info/device_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'dart:io';
Map<int,String> Month={1:"January",2:"February",3:"March",4:"April",5:"May",6:"June",7:"July",8:"August",9:"September",10:"October",11:"November",12:"December"};

class AppConfig {
  static String clientId = "";
  static String username = "";
  static String password = "";
  static String appName = "Breaker Pro";
  static String appVersion = "version 0.3.0";
  static String updateDate = "Updated on 10 March 2023";
  static String rightsInfo = "${DateTime.now().year.toString()} All Rights Reserved by Lyons Systems Ltd.";

  static String deviceId = "";
  static String deviceName = "";
  static String osVersion = "";

  static String imageAspectRatio = 'Default';
  static String barcode = 'Qr code';

  static Directory? externalDirectory;

  static bool isConnected = false;

  static Map aspectMap = {
    'Default': 9 / 16,
    '1:1': 1 / 1,
    '4:3': 3 / 4,
    '16:9': 9 / 16,
  };

  static List<String> postageOptionsList = [];
  static List<String> fuelItems = [];
  static List<String> partConditionList = [];
  static List<String> partTypeList = [];
  static List<String> stockReconcileList = [];
  static Map postageOptionsMap = {};

  static getDeviceInfo() async {
    deviceId = (await PlatformDeviceId.getDeviceId)!;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      var product = androidInfo.product;
      deviceName = "$model $manufacturer $product";
      osVersion = sdkInt.toString();
    }

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      deviceName = "$name $model";
      osVersion = version.toString();
    }

    print(
        "deviceId $deviceId deviceName $deviceName osVersion $osVersion appVersion $appVersion");
  }
}
