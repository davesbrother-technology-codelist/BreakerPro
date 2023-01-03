import 'dart:convert';
import 'dart:io';

import 'package:breaker_pro/api/api_call.dart';

class AuthRepository {
  static Future<String> login(
      String url, Map<String, dynamic> queryParams) async {
    final Map<String, dynamic> responseJson =
        await ApiCall.get(url, queryParams);
    return responseJson['result'];
  }

  static Future<String> logout(
      String url, Map<String, dynamic> queryParams) async {
    queryParams['password'] = 'LOGOUT';
    final Map<String, dynamic> responseJson =
        await ApiCall.get(url, queryParams);
    return responseJson['result'];
  }
}
