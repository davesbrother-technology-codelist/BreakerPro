import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../my_theme.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';


class QuickScan extends StatefulWidget {
QuickScan(){
  
}
  @override
  State<QuickScan> createState() => _QuickScanState();
}

class _QuickScanState extends State<QuickScan>  {
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
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
                    SizedBox(
                      width: 5,
                    ),
                    (result !=null) ? Text('${result!.code}') : Text('Scan a code')
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
                    Container(
                      color: MyTheme.materialColor,
                      child: TextButton(onPressed: (){},
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



