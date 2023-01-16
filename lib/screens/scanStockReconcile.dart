import 'package:breaker_pro/screens/main_dashboard.dart';
import 'package:breaker_pro/screens/vehicle_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../my_theme.dart';
import 'dart:io';

import 'package:qr_code_scanner/qr_code_scanner.dart';


class ScanStockReconcile extends StatefulWidget {
  const ScanStockReconcile({Key? key}) : super(key: key);

  @override
  State<ScanStockReconcile> createState() => _ScanStockReconcileState();
}

class _ScanStockReconcileState extends State<ScanStockReconcile> with TickerProviderStateMixin   {
  late AnimationController _animationController;
  bool _isVisible = true;
  final GlobalKey _gLobalkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  List<Barcode?> results=[];
  void qr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        results.add(result);
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
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset("assets/laser.png",
                        height: 60,
                        width: 40,
                      )
                    ],
                  ),
                  Container(
                    height: 5*MediaQuery.of(context).size.height/7,
                    width: 400,

                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Stack(

                        children: [
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
                            ),),
                          Positioned(
                            top: 280,
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
                          )
                        ]

                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text('Scanned Parts',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                                  ),

                                ],
                              ),
                              SizedBox(
                                width:150 ,
                              ),
                              Column(
                                children: [
                                  TextButton(onPressed: (){},
                                      child:Text("Manage Part",style: TextStyle(color: MyTheme.materialColor),)),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Container(
                                      color: MyTheme.materialColor,
                                      child: TextButton(onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainDashboard()));
                                      },
                                          child:Text("Exit",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: MyTheme.white
                                            ),
                                          )),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                    itemCount: results.length,
                                    itemBuilder: (context,index){
                                    return (results[index] !=null) ?
                                        Padding(padding: const EdgeInsets.only(left: 8,bottom: 8),
                                        child:    Text('${results[index]!.code}')
                                        )
                                     :
                                    Text('No data found');
                                }),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                ],
              ),
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



