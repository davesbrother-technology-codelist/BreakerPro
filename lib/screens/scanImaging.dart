import 'package:breaker_pro/screens/capture_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../my_theme.dart';
import 'dart:io';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:breaker_pro/app_config.dart';

class ScanImaging extends StatefulWidget {
  const ScanImaging({Key? key}) : super(key: key);

  @override
  State<ScanImaging> createState() => _ScanImagingState();
}

class _ScanImagingState extends State<ScanImaging> with TickerProviderStateMixin  {
  late AnimationController _animationController;
  bool _isVisible = true;
  bool Mode=false;
  final GlobalKey _gLobalkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  void qr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        openCamera();
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
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: Stack(
                      children : [
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
                Mode?Text('Offline Mode',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),):SizedBox(),

                ImageList.scanImagingList.isNotEmpty
                    ? Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    height: 140,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: ImageList.scanImagingList.length,
                        itemBuilder:
                            (BuildContext context, int index) {
                          return Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AspectRatio(
                                  aspectRatio: AppConfig.aspectMap[
                                  AppConfig.imageAspectRatio],
                                  child: SizedBox(
                                    width: 9,
                                    height: 16,
                                    child: Image.file(File(ImageList
                                        .scanImagingList[index])),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -5,
                                right: -13,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color:
                                    Colors.black.withOpacity(0.7),
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      ImageList.scanImagingList
                                          .removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                )
                    : SizedBox(),

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
                  padding: const EdgeInsets.all(10),
                  child: Row(
mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          color: MyTheme.materialColor,
                          child: TextButton(onPressed: (){},
                              child: Text("Upload & Scan New Part",
                                style: TextStyle(
                                    fontSize:13,
                                    color: MyTheme.white

                                ) ,
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Mode?Expanded(
                        child: Container(
                          color: MyTheme.materialColor,
                          child: TextButton(onPressed: (){
                            setState(() {
                              Mode=!Mode;
                            });
                          },
                              child: Text("Online Mode",
                                style: TextStyle(
                                    fontSize:13,
                                    color: MyTheme.white

                                ) ,
                              )),
                        ),
                      ):Expanded(
                        child: Container(
                          color: MyTheme.materialColor,
                          child: TextButton(onPressed: (){
                            setState(() {
                              Mode=!Mode;
                            });
                          },
                              child: Text("Offline Mode",
                                style: TextStyle(
                                    fontSize:13,
                                    color: MyTheme.white

                                ) ,
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          color: MyTheme.materialColor,
                          child: TextButton(onPressed: (){
                            Navigator.pop(context);
                          },
                              child: Text("Exit",
                                style: TextStyle(
                                    fontSize:13,
                                    color: MyTheme.white

                                ) ,
                              )),
                        ),
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
  openCamera() async{
    final cameras = await availableCameras();
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CaptureScreen(cameras: cameras, type: 'ScanImaging')));

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



