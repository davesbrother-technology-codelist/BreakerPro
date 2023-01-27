import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../my_theme.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';


class QuickScan extends StatefulWidget {

  @override
  State<QuickScan> createState() => _QuickScanState();
}

class _QuickScanState extends State<QuickScan> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isVisible = true;
  final GlobalKey _gLobalkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  bool Mode=false;
  void qr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
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
    return  Scaffold(

      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset("assets/laser.png",
                      height: 60,
                      width: 50,
                    )
                  ],
                ),
                Container(
                  height:5* MediaQuery.of(context).size.height/9,
                  width: 400,

                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Stack(
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
                            ),


                          ),
                          Positioned(
                            top: 220,
                            left: 50,
                            right: 50,
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
                          ),
                        ]

                    ),
                  ),
                ),
                // Center(
                //   child: (result !=null) ? Text('${result!.code}') : Text('Scan a code'),
                // ),
                Mode?Text('Offline Mode',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),):Container(),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text('Part ID',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),),
                      SizedBox(
                        width: 5,
                      ),
                      (result !=null) ? Text('${result!.code}') : Text('')
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text('Part Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),),
                      Text('')
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text('Current Location',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),),
                      Text('')
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text('Vehicle',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),),
                      Text('')
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14,right: 14),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Location",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2
                            )
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: MyTheme.materialColor,
                        child: TextButton(onPressed: (){},
                            child: Text("Set Location",
                              style: TextStyle(
                                  fontSize:18,
                                  color: MyTheme.white

                              ) ,
                            )),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Mode?Container(
                        color: MyTheme.materialColor,
                        child: TextButton(onPressed: (){
                          setState(() {
                            Mode=!Mode;
                          });
                        },
                            child: Text("Online Mode",
                              style: TextStyle(
                                  fontSize:18,
                                  color: MyTheme.white

                              ) ,
                            )),
                      ):Container(
                        color: MyTheme.materialColor,
                        child: TextButton(onPressed: (){
                          setState(() {
                            Mode=!Mode;
                          });
                        },
                            child: Text("Offline Mode",
                              style: TextStyle(
                                  fontSize:18,
                                  color: MyTheme.white

                              ) ,
                            )),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        color: MyTheme.materialColor,
                        child: TextButton(onPressed: (){},
                            child: Text("Exit",
                              style: TextStyle(
                                  fontSize:18,
                                  color: MyTheme.white

                              ) ,
                            )),
                      ),


                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );

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



