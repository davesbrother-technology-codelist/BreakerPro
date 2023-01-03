import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../my_theme.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';


class ScanImaging extends StatefulWidget {
  const ScanImaging({Key? key}) : super(key: key);

  @override
  State<ScanImaging> createState() => _ScanImagingState();
}

class _ScanImagingState extends State<ScanImaging>  {
  final GlobalKey _gLobalkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  void qr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan (Double click on screen)"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 500,
              width: 400,

              child: QRView(
                  key: _gLobalkey,
                  onQRViewCreated: qr
              ),
            ),
            // Center(
            //   child: (result !=null) ? Text('${result!.code}') : Text('Scan a code'),
            // ),
            SizedBox(
              height: 20,
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
                  Container(
                    color: MyTheme.materialColor,
                    child: TextButton(onPressed: (){},
                        child: Text("Upload & Scan New Part",
                          style: TextStyle(
                              fontSize:12,
                              color: MyTheme.white

                          ) ,
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    color: MyTheme.materialColor,
                    child: TextButton(onPressed: (){},
                        child: Text("Offline Mode",
                          style: TextStyle(
                              fontSize:12,
                              color: MyTheme.white

                          ) ,
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    color: MyTheme.materialColor,
                    child: TextButton(onPressed: (){},
                        child: Text("Exit",
                          style: TextStyle(
                              fontSize:12,
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



