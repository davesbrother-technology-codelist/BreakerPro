import 'dart:convert';
import 'dart:io';

import 'package:breaker_pro/api/api_call.dart';
import 'package:breaker_pro/app_config.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:intl/intl.dart';

class AuthRepository {
  static Future<String> login(
      String url, Map<String, dynamic> queryParams) async {
    final Map<String, dynamic> responseJson =
        await ApiCall.get(url, queryParams);
    // await FlutterLogs.initLogs(
    //     logLevelsEnabled: [
    //       LogLevel.INFO,
    //       LogLevel.WARNING,
    //       LogLevel.ERROR,
    //       LogLevel.SEVERE
    //     ],
    //     timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
    //     directoryStructure: DirectoryStructure.SINGLE_FILE_FOR_DAY,
    //     logTypesEnabled: [
    //       "LOGGER${DateFormat("ddMMyy").format(DateTime.now())}",
    //     ],
    //     logFileExtension: LogFileExtension.TXT,
    //     logsWriteDirectoryName: "MyLogs",
    //     logsExportDirectoryName: "MyLogs/Exported",
    //     // logsExportZipFileName:
    //     //     "Logger${DateFormat('dd_MM_YYYY').format(DateTime.now())}",
    //     debugFileOperations: true,
    //     isDebuggable: true);
    // FlutterLogs.logToFile(
    //     logFileName: "LOGGER${DateFormat("ddMMyy").format(DateTime.now())}",
    //     overwrite: false,
    //     logMessage:
    //         "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())} LOGIN $url SUCCESS $responseJson\n");

    final File file = File(
        '${AppConfig.externalDirectory!.path}/LOGGER${DateFormat("ddMMyy").format(DateTime.now())}.txt');
    await file.writeAsString(
        "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())} LOGIN $url SUCCESS $responseJson\n",
        mode: FileMode.append);
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
