import 'package:breaker_pro/api/stock_reconcile_repository.dart';
import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:breaker_pro/screens/main_dashboard.dart';
import 'package:breaker_pro/screens/quickScan.dart';
import 'package:breaker_pro/screens/vehicle_details_screen.dart';
import 'package:breaker_pro/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import '../api/stock_repository.dart';
import '../app_config.dart';
import '../dataclass/part.dart';
import '../dataclass/stock.dart';
import '../my_theme.dart';
import 'dart:io';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../utils/main_dashboard_utils.dart';
import 'manage_parts2.dart';

class ScanStockReconcile extends StatefulWidget {
  const ScanStockReconcile({Key? key}) : super(key: key);

  @override
  State<ScanStockReconcile> createState() => _ScanStockReconcileState();
}

class _ScanStockReconcileState extends State<ScanStockReconcile>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Part part;
  Stock stock = Stock();
  final GlobalKey globalKey = GlobalKey();
  String currentCode = '';
  late QRViewController controller;
  Barcode? result;
  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((event) async {
      print(event.code);
      if(event.code != null && event.code != currentCode){
        setState(() {
          AppConfig.stockReconcileList.insert(0,event.code!);
          if(AppConfig.stockReconcileList.length > 5){
            AppConfig.stockReconcileList.removeAt(5);
          }
          currentCode = event.code!;
        });
        await PartsList.prefs?.setStringList('stockReconcileList', AppConfig.stockReconcileList);
        Widget widget = Padding(
          padding: const EdgeInsets.only(left: 10,right: 10,bottom: 100),
          child: Container(
            alignment: Alignment.center,
            height: 20,
            width: MediaQuery.of(context).size.width,
            color: Colors.green,
            child: const Text('Stock added to Upload Queue',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w500),),
          ),
        );

        showToastWidget(
          widget,
          duration: Duration(seconds: 3),
          position: ToastPosition.top,
          onDismiss: () {
            print("the toast dismiss"); // the method will be called on toast dismiss.
          },
        );
        await StockReconcileRepository.update(event.code!);
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
    if (Platform.isIOS) {
      await controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  Future<void> findStockFromID(BuildContext context, String partID) async {
    AuthUtils.showLoadingDialog(context);
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

      // setState(() {
      //   available = false;
      //   isFound = false;
      //   stock = Stock();
      //   stock.stockID = partID;
      // });
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Part Not Found');
      return;
    }
    // stock = Stock();
    stock.fromJson(responseList[0]);
    part = Part.fromStock(stock);
    part.partId =
        "MNG_PRT_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}";
    print(stock.stockID);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                ManageParts2(part: part, stock: stock)));
    // setState(() {
    //   available = true;
    //   isFound = true;
    // });

    // await file.writeAsString(
    //     "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())}: onSearchByPartId Part Found ${part.partName}, ${stock.stockID}\n",
    //     mode: FileMode.append);
    // Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: MainDashboardUtils.qrWidgetInScreen(
                  context, globalKey, onQRViewCreated, animationController)),

          // infoContainer("Part ID", stock.stockID),
          // infoContainer("Part Name", stock.partName),
          // infoContainer("Current Location", stock.vehicleLocation),
          // infoContainer("Vehicle",
          //     "${stock.make} ${stock.model} ${stock.year}"),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                    child: Text('Scanned Parts',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w500),),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: AppConfig.stockReconcileList.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                      child: Text(e),
                    )).toList(),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
                child: TextButton(
                    onPressed: () async {
                      if(AppConfig.stockReconcileList.isEmpty){
                        return;
                      }
                      await findStockFromID(context, AppConfig.stockReconcileList.first);
                    },
                    child: const Text('Manage Part')),
              ),
            ],
          ),


          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(
                flex: 8,
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                  child: Container(
                    color: MyTheme.materialColor,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Exit",
                          style: TextStyle(fontSize: 15, color: MyTheme.white),
                        )),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
