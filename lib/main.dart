import 'dart:async';
import 'dart:io';
import 'package:breaker_pro/app_config.dart';
import 'package:breaker_pro/dataclass/part.dart';
import 'package:breaker_pro/my_theme.dart';
import 'package:breaker_pro/notification_service.dart';
import 'package:breaker_pro/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  await initialiseHive();

  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  NotificationService().initialize();

  await AppConfig.getDeviceInfo();

  await getExternalDirectory();
  runApp(const MyApp());
}

Future<void> getExternalDirectory() async {
  if (Platform.isIOS) {
    Directory externalDirectory = await getApplicationDocumentsDirectory();
    externalDirectory = Directory("${externalDirectory.path}/Logs");
    if (!externalDirectory.existsSync()) {
      externalDirectory = await Directory(externalDirectory.path).create();
    }
    AppConfig.externalDirectory = externalDirectory;
  } else {
    Directory? externalDirectory = await getExternalStorageDirectory();
    externalDirectory = Directory("${externalDirectory!.path}/Logs");
    if (!externalDirectory.existsSync()) {
      externalDirectory = await Directory(externalDirectory.path).create();
    }
    AppConfig.externalDirectory = externalDirectory;
  }

  print("External Directory ${AppConfig.externalDirectory}");
}

Future<void> initialiseHive() async {
  await Hive.initFlutter();
  try {
    Hive.registerAdapter(PartAdapter());
  } catch (e) {
    print("OPEnned");
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    switch (task) {
      case "1":
        NotificationService().instantNofitication("Hello");
        break;
    }

    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
          title: 'Breaker pro',
          theme: ThemeData(primarySwatch: MyTheme.materialColor),
          home: const LoginScreen(
            noLogin: true,
          )),
    );
  }
}
