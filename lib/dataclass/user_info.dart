import 'package:flutter/cupertino.dart';

class UserInfo with ChangeNotifier {
  late final String clientId;
  late final String username;
  late final String password;
  late final String deviceId;
  late final String syncDeviceLists;
  late final String appVersion;
  late final String osVersion;
  late final String devicename;

  UserInfo({required this.clientId, required this.username});
}
