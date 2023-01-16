import 'package:breaker_pro/my_theme.dart';
import 'package:breaker_pro/screens/main_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

class ScanPart extends StatefulWidget {
  const ScanPart({Key? key}) : super(key: key);

  @override
  State<ScanPart> createState() => _ScanPartState();
}

class _ScanPartState extends State<ScanPart> with TickerProviderStateMixin  {
  late AnimationController _animationController;
  bool _isVisible = true;
  final GlobalKey _gLobalkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  void qr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        ScannedScreen(result!);
      });
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 6),
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
    controller?.dispose();
    _animationController.dispose();

    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if(Platform.isIOS){
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children:[
                      QRView(
                      key: _gLobalkey,
                      onQRViewCreated: qr,
                      cameraFacing: CameraFacing.back,
                      overlay: QrScannerOverlayShape(
                        borderLength: 35,
                        borderWidth: 4,
                        borderColor: Colors.lightGreenAccent,
                        cutOutHeight:MediaQuery.of(context).size.height*0.26,
                        cutOutWidth: MediaQuery.of(context).size.width*0.7,
                      )
                      ),
                      Container(
                        color: Colors.white54,
                        height: 60,
                        width: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/laser.png",
                          height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 390,
                        left: 60,
                        right: 60,
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _animationController.value,
                              child: Container(
                                width: 420,
                                height: 1,
                                color: Colors.red,
                              ),
                            );
                          },
                        ),
                      )
                    ]
                  ),
                ),
                // Center(
                //   child: (result !=null) ? Text('${result!.code}') : Text('Scan a code'),
                // )
              ],
            ),
          ),
        ),
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
                height: 4*MediaQuery.of(context).size.height/5,
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
                                fontWeight: FontWeight.bold, color: Colors.grey),
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
                                fontWeight: FontWeight.bold, color: Colors.grey),
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
                                fontWeight: FontWeight.bold, color: Colors.grey),
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
                                fontWeight: FontWeight.bold, color: Colors.grey),
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
                              decoration: InputDecoration(hintText: "Location",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.grey), //<-- SEE HERE
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
                                          builder: (context) => MainDashboard()));
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
