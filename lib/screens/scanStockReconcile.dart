import 'package:breaker_pro/screens/main_dashboard.dart';
import 'package:breaker_pro/screens/vehicle_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../my_theme.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';


class ScanStockReconcile extends StatefulWidget {
  const ScanStockReconcile({Key? key}) : super(key: key);

  @override
  State<ScanStockReconcile> createState() => _ScanStockReconcileState();
}

class _ScanStockReconcileState extends State<ScanStockReconcile>  {
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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 540,
                  width: 400,

                  child: QRView(
                      key: _gLobalkey,
                      onQRViewCreated: qr
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
                                    child:Text("Manage Part")),
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



