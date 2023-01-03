import 'package:breaker_pro/my_theme.dart';
import 'package:breaker_pro/screens/main_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanPart extends StatefulWidget {
  const ScanPart({Key? key}) : super(key: key);

  @override
  State<ScanPart> createState() => _ScanPartState();
}

class _ScanPartState extends State<ScanPart> {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 660,
                width: 400,
                child: QRView(key: _gLobalkey, onQRViewCreated: qr),
              ),
              // Center(
              //   child: (result !=null) ? Text('${result!.code}') : Text('Scan a code'),
              // )
            ],
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

              content: Container(
                width: double.infinity,
                child: Builder(
                  builder: (context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                        TextField(
                          decoration: InputDecoration(hintText: "Location"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>MainDashboard()));
                            },
                          ),
                        ),
                      ],
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
