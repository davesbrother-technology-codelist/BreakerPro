import 'package:breaker_pro/app_config.dart';
import 'package:breaker_pro/my_theme.dart';
import 'package:breaker_pro/screens/allocate_parts_screen.dart';
import 'package:breaker_pro/screens/login_screen.dart';
import 'package:breaker_pro/screens/main_dashboard.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.getDeviceInfo();
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
