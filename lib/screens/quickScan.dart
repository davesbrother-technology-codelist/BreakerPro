import 'dart:io';

import 'package:breaker_pro/utils/main_dashboard_utils.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../api/stock_repository.dart';
import '../app_config.dart';
import '../dataclass/part.dart';
import '../dataclass/stock.dart';
import '../my_theme.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';


class QuickScan extends StatefulWidget {

  @override
  State<QuickScan> createState() => _QuickScanState();
}

class _QuickScanState extends State<QuickScan> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Part part;
  late Stock stock = Stock();
  final GlobalKey globalKey = GlobalKey();
  late QRViewController controller;
  Barcode? result;
  bool isOffline = false;
  bool isFound = false;
  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) async {

        print(event.code);
        if(event.code != null){
          controller.pauseCamera();
          await findStockFromID(context, event.code!);
        }

    });
    controller.pauseCamera();
    controller.resumeCamera();
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
  void initState() {
    super.initState();
    initialiseRedLineAnimation();
  }
  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if(Platform.isIOS){
      await controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  Future<void> findStockFromID(
      BuildContext context, String partID) async {
    Map<String, dynamic> queryParams = {
      "clientid": AppConfig.clientId,
      "username": AppConfig.username,
      "stockid": partID,
      "searchby": "part"
    };
    List? responseList = await StockRepository.findStock(queryParams);
    if (responseList == null) {
      // await file.writeAsString(
      //     "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())}: onSearchByPartId Part Not Found (or not synced)\n",
      //     mode: FileMode.append);
      Fluttertoast.showToast(msg: "Part Not Found (or not synced)");
      return;
    }
    // stock = Stock();
    stock.fromJson(responseList[0]);
    part = Part.fromStock(stock);
    part.partId =
    "MNG_PRT_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}";
    print(stock.stockID);
    setState(() {

    });

    // await file.writeAsString(
    //     "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())}: onSearchByPartId Part Found ${part.partName}, ${stock.stockID}\n",
    //     mode: FileMode.append);
    // Navigator.pop(context);
  }

  Widget infoContainer(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
            child: Text(
              title,
              style: TextStyle(color: MyTheme.black54),
            ),
          ),
          Expanded(
            child : Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text(
                desc ,
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: EmptyAppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child : MainDashboardUtils.qrWidget2(context, globalKey, onQRViewCreated, animationController)),

          isOffline?const Text('Offline Mode',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),):Container(),

          infoContainer("Part ID", stock.stockID),
          infoContainer("Part Name", stock.partName),
          infoContainer("Current Location", stock.vehicleLocation),
          infoContainer("Vehicle",
              "${stock.make} ${stock.model} ${stock.year}"),
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
                isOffline?Container(
                  color: MyTheme.materialColor,
                  child: TextButton(onPressed: (){
                    setState(() {
                      isOffline=!isOffline;
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
                      isOffline=!isOffline;
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

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.materialColor,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(0, 0);
}

