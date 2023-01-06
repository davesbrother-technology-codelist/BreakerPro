import 'package:breaker_pro/screens/barcode_screen.dart';
import 'package:flutter/material.dart';
import '../my_theme.dart';
import 'aspect_ratio_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Container(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          title: Text(
            "Settings",
            style: TextStyle(color: MyTheme.white),
          ),
        ),
        body: Column(
          children: [
            ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AspectRatioScreen())),
              title: const Text(
                'Aspect Ratio',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: MyTheme.materialColor,
                size: 35,
              ),
            ),
            Divider(
              height: 0,
              indent: 0,
              endIndent: 0,
              thickness: 1.5,
              color: MyTheme.black54,
            ),
            ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BarcodeScreen())),
              title: const Text(
                'Barcode',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: MyTheme.materialColor,
                size: 35,
              ),
            ),
            Divider(
              height: 0,
              indent: 0,
              endIndent: 0,
              thickness: 1.5,
              color: MyTheme.black54,
            ),
          ],
        ));
  }
}
