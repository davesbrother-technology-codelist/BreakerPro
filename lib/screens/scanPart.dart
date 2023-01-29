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

  void ScannedScreen(Barcode? result) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              content: Container(
                width: double.infinity,
                height: 4 * MediaQuery.of(context).size.height / 5,
                child: Builder(
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Part ID",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('${result!.code}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Part Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Current Location',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Vehicle',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Location",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.grey), //<-- SEE HERE
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 200,
                              color: MyTheme.materialColor,
                              child: TextButton(
                                child: Text(
                                  'Scan Barcode',
                                  style: TextStyle(
                                    color: MyTheme.white,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ScanPart()));
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 200,
                              color: MyTheme.materialColor,
                              child: TextButton(
                                child: Text(
                                  'Set Location',
                                  style: TextStyle(
                                    color: MyTheme.white,
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 200,
                              color: MyTheme.materialColor,
                              child: TextButton(
                                child: Text(
                                  'Search Again',
                                  style: TextStyle(
                                    color: MyTheme.white,
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 200,
                              color: MyTheme.materialColor,
                              child: TextButton(
                                child: Text(
                                  'Exit',
                                  style: TextStyle(
                                    color: MyTheme.white,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MainDashboard()));
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ));
        });
  }
}
// Future<void> scanBarcode() async{
//   // var status = await Permission.camera.request();
//   // if (status.isGranted) {
//     try{
//        scanResult = await FlutterBarcodeScanner.scanBarcode("#ff66666","Cancel",true,ScanMode.BARCODE);
//
//
//     }on PlatformException{
//       scanResult="failed";
//     }
//     if(!mounted) return;
//     setState((){
//       this.scanResult=scanResult;
//
//     });
// } else {
//   print("error");
// }
