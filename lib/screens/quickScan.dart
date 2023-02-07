import 'dart:io';

import 'package:breaker_pro/screens/manage_parts2.dart';
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
  TextEditingController locationController = TextEditingController();
  late QRViewController controller;
  Barcode? result;
  bool isOffline = false;
  bool available = true;
  bool isFound = false;
  String code = "";
  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((event) async {

        print(event.code);
        if(isOffline && event.code != null){
          available = true;
          setState(() {
            if(event.code != code){
              stock = Stock();
              stock.stockID = event.code!;
              code = event.code!;
            }

          });

        }
        else{
          if(event.code != null && event.code != code){
            controller.pauseCamera();
            code = event.code!;
            await findStockFromID(context, event.code!);
            controller.resumeCamera();

          }
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
      // Fluttertoast.showToast(msg: "Part Not Found (or not synced)");

      setState(() {
        available = false;
        isFound = false;
        stock = Stock();
        stock.stockID = partID;
      });
      return;
    }
    // stock = Stock();
    stock.fromJson(responseList[0]);
    part = Part.fromStock(stock);
    part.partId =
    "MNG_PRT_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}";
    print(stock.stockID);
    setState(() {
      available = true;
      isFound = true;
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
              style: TextStyle(color: MyTheme.black54,fontWeight: FontWeight.w500),
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
          ),
          title == 'Part ID' && isFound ? TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => ManageParts2(part: part, stock: stock)));}, child: Text('Manage Part')) : SizedBox(),
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
          Expanded(child : MainDashboardUtils.qrWidgetInScreen(context, globalKey, onQRViewCreated, animationController)),

          isOffline ? const Center(child: Text('Offline Mode',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)) : Container(),
          available ? Container() : const Center(child: Text('Part Currently Not Available',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),

          infoContainer("Part ID", stock.stockID),
          infoContainer("Part Name", stock.partName),
          infoContainer("Current Location", stock.vehicleLocation),
          infoContainer("Vehicle",
              "${stock.make} ${stock.model} ${stock.year}"),
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 5),
            child: TextFormField(
              controller:locationController,
              decoration: const InputDecoration(
                  hintText: "Location",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide:
                      BorderSide(color: Colors.grey, width: 2))),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10,5,5,5),
                  child: Container(
                    color: MyTheme.materialColor,
                    child: TextButton(onPressed: () async {
                      if(isFound && !isOffline){
                        await StockRepository.updateLocation(stock, locationController.text);
                      }
                    },
                        child: Text("Set Location",
                          style: TextStyle(
                              fontSize:15,
                              color: MyTheme.white

                          ) ,
                        )),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5,5,5,5),
                  child: Container(
                    color: MyTheme.materialColor,
                    child: TextButton(onPressed: (){
                      setState(() {
                        isOffline = !isOffline;
                        if(!isOffline){
                          code = "";
                        }
                      });
                    },
                        child: Text(isOffline ? "Online Mode" : "Offline Mode",
                          style: TextStyle(
                              fontSize:15,
                              color: MyTheme.white

                          ) ,
                        )),
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 2,
                child : Padding(
                  padding: const EdgeInsets.fromLTRB(5,5,10,5),
                  child: Container(
                    color: MyTheme.materialColor,
                    child: TextButton(onPressed: (){Navigator.pop(context);},
                        child: Text("Exit",
                          style: TextStyle(
                              fontSize:15,
                              color: MyTheme.white

                          ) ,
                        )),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,)

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

