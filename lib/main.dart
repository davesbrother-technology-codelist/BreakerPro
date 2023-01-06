import 'dart:io';
import 'package:breaker_pro/app_config.dart';
import 'package:breaker_pro/dataclass/part.dart';
import 'package:breaker_pro/my_theme.dart';
import 'package:breaker_pro/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> getFilePath() async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  String appDocumentsPath = appDocumentsDirectory.path;
  String filePath = '$appDocumentsPath/demoTextFile.txt';
  print(filePath);
  return filePath;
}

Future _getStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    saveFile();
  } else if (await Permission.storage.request().isPermanentlyDenied) {
    await openAppSettings();
  } else if (await Permission.storage.request().isDenied) {
    print("Denied");
  }
}

void saveFile() async {
  File file = File(await getFilePath());
  print(file.path); //
  String s = await file.readAsString();
  print(s);
  // file.writeAsString(
  //     "This is my demo text that will be saved to : demoTextFile.txt"); // 2
}

Future<void> main() async {
  // Initialize hive
  await Hive.initFlutter();
  try {
    Hive.registerAdapter(PartAdapter());
  } catch (e) {
    print("OPEnned");
  }

  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.getDeviceInfo();
  // saveFile();
  await _getStoragePermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Breaker pro',
        theme: ThemeData(primarySwatch: MyTheme.materialColor),
        home: const LoginScreen());
  }
}
