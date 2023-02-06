import 'package:breaker_pro/my_theme.dart';
import 'package:breaker_pro/screens/main_dashboard.dart';
import 'package:breaker_pro/screens/qr_screen.dart';
import 'package:breaker_pro/utils/main_dashboard_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

class ScanPart extends StatefulWidget {
  const ScanPart({Key? key}) : super(key: key);

  @override
  State<ScanPart> createState() => _ScanPartState();
}

class _ScanPartState extends State<ScanPart> with TickerProviderStateMixin {
  late AnimationController animationController;
  final GlobalKey globalKey = GlobalKey();
  late QRViewController qrController;
  Barcode? result;
  void onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((event) async {
      await controller.stopCamera();
      print(event.code);
      Navigator.pop(context, event.code);
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController.pauseCamera();
    }
    qrController.resumeCamera();
  }

  @override
  void initState() {
    initialiseRedLineAnimation();
    super.initState();
  }

  void initialiseRedLineAnimation() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MainDashboardUtils.qrWidget(
            context, globalKey, onQRViewCreated, animationController),
      ),
    );
  }

}