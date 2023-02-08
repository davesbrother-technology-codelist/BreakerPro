import 'dart:convert';

import 'package:breaker_pro/screens/capture_screen.dart';
import 'package:breaker_pro/screens/quickScan.dart';
import 'package:breaker_pro/utils/auth_utils.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/manage_part_repository.dart';
import '../api/stock_repository.dart';
import '../dataclass/part.dart';
import '../dataclass/stock.dart';
import '../my_theme.dart';
import 'dart:io';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:breaker_pro/app_config.dart';

import '../utils/main_dashboard_utils.dart';
import 'manage_parts2.dart';

class ScanImaging extends StatefulWidget {
  const ScanImaging({Key? key}) : super(key: key);

  @override
  State<ScanImaging> createState() => _ScanImagingState();
}

class _ScanImagingState extends State<ScanImaging> with TickerProviderStateMixin  {
  late AnimationController animationController;
  late Part part;
  late Stock stock = Stock();
  final GlobalKey globalKey = GlobalKey();
  late QRViewController controller;
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
            isFound = false;
          }

        });

      }
      else{
        if(event.code != null && event.code != code){
          controller.pauseCamera();
          code = event.code!;
          await findStockFromID(context, event.code!);
          // controller.resumeCamera();
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

  Future<void> findStockFromID(
      BuildContext context, String partID) async {
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
      controller.resumeCamera();
      Navigator.pop(context);

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
    available = true;
    isFound = true;
    Navigator.pop(context);

    await openCamera();

    // await file.writeAsString(
    //     "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())}: onSearchByPartId Part Found ${part.partName}, ${stock.stockID}\n",
    //     mode: FileMode.append);
    // Navigator.pop(context);
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
    if(Platform.isIOS || Platform.isAndroid){
      await controller.pauseCamera();
    }
    controller.resumeCamera();
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child : MainDashboardUtils.qrWidgetInScreen(context, globalKey, onQRViewCreated, animationController)),

          isOffline ? const Center(child: Text('Offline Mode',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)) : Container(),
          available ? Container() : const Center(child: Text('Part Currently Not Available',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),)),
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
                              child: Image.file(File(ImageList
                                  .scanImagingList[index]),fit: BoxFit.fill,),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -15,
                          right: -15,
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
              : const SizedBox(),
          infoContainer("Part ID", stock.stockID),
          infoContainer("Part Name", stock.partName),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10,5,5,5),
                  child: Container(
                    color: MyTheme.materialColor,
                    child: TextButton(onPressed: () async {
                      if(stock.stockID.isEmpty){
                        Fluttertoast.showToast(msg: "Data Not Found");
                        return;
                      }
                      if(ImageList.scanImagingList.isEmpty){
                        Fluttertoast.showToast(msg: "No images to upload.");
                        return;
                      }
                      part.imgList = List.from(ImageList.scanImagingList);
                      ImageList.scanImagingList.clear();
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      if(prefs.getStringList('uploadManagePartQueue') == null){
                        await prefs.setStringList('uploadManagePartQueue', [part.partId]);
                      }
                      else{
                        List<String> l = prefs.getStringList('uploadManagePartQueue')!;
                        l.add(part.partId);
                        await prefs.setStringList('uploadManagePartQueue', l);
                      }
                      await prefs.setString(part.partId, jsonEncode(stock.toJson()));
                      Box<Part> box = await Hive.openBox('manageParts');
                      await box.put(part.partId, part);
                      await box.close();
                      ManagePartRepository.uploadPart(part, stock);
                      setState(() {
                        stock = Stock();
                        part = Part.fromStock(stock);
                        code = "";
                      });
                    },
                        child: Text("Upload & Scan New Part",
                          style: TextStyle(
                              fontSize:13,
                              color: MyTheme.white

                          ) ,
                        )),
                  ),
                ),
              ),
              const Spacer(),
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
                              fontSize:13,
                              color: MyTheme.white

                          ) ,
                        )),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child : Padding(
                  padding: const EdgeInsets.fromLTRB(5,5,10,5),
                  child: Container(
                    color: MyTheme.materialColor,
                    child: TextButton(onPressed: (){Navigator.pop(context);},
                        child: Text("Exit",
                          style: TextStyle(
                              fontSize:13,
                              color: MyTheme.white

                          ) ,
                        )),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,)

        ],
      ),
    );
  }
  openCamera() async{
    final cameras = await availableCameras();
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CaptureScreen(cameras: cameras, type: 'ScanImaging'))).then((value) async {
      await controller.resumeCamera();
      // controller.
      setState(() {
      });
    });

  }
  }



