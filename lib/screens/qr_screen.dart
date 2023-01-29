import 'package:breaker_pro/utils/main_dashboard_utils.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> with TickerProviderStateMixin {
  final GlobalKey _globalKey = GlobalKey(debugLabel: "QR Screen");
  late AnimationController _animationController;
  late QRViewController qrController;

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((event) {
      setState(() {
        print("Hello ${event.code}");
      });
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
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainDashboardUtils.qrWidget(
          context, _globalKey, onQRViewCreated, _animationController),
    );
  }
}
