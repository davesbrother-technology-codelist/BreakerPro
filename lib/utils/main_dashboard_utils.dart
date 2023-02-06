import 'package:breaker_pro/api/vehicle_repository.dart';
import 'package:breaker_pro/api/workOrder_repository.dart';
import 'package:breaker_pro/dataclass/workOrder.dart';
import 'package:breaker_pro/screens/quickScan.dart';
import 'package:breaker_pro/screens/scanImaging.dart';
import 'package:breaker_pro/screens/scanStockReconcile.dart';
import 'package:breaker_pro/screens/vehicle_details_screen.dart';
import 'package:breaker_pro/screens/workOrderScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import '../api/api_config.dart';
import '../api/stock_repository.dart';
import '../app_config.dart';
import '../dataclass/part.dart';
import '../dataclass/parts_list.dart';
import '../dataclass/stock.dart';
import '../my_theme.dart';
import 'package:breaker_pro/screens/scanPart.dart';
import 'package:breaker_pro/screens/manageParts.dart';

import '../screens/main_dashboard.dart';
import 'auth_utils.dart';

class MainDashboardUtils {
  static List<Function?> functionList = [
    addBreakerDialog,
    addPartDialog,
    scanLocationDialogue,
    ScanStockReconcileFunction,
    ScanImagingFunction,
    ManagePartsFunction,
    WorkOrdersFunction
  ];

  static TextEditingController partIdEditingController =
      TextEditingController();
  static TextEditingController locationEditingController =
      TextEditingController();

  static void addBreakerDialog(
      BuildContext context, PartsList partsList) async {
    if (PartsList.partList.isEmpty) {
      Fluttertoast.showToast(msg: "Fetching Parts");
      return;
    }
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10),
                  child: SizedBox(height: 100, width: 100, child: imageList[0]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  child: Text(
                    'Add a Breaker',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            content: Builder(builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: TextField(
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (String? vrn) async {
                        if (vrn != null) {
                          AuthUtils.showLoadingDialog(context);
                          bool b =
                              await VehicleRepository.findVehicleFromVRN(vrn);
                          Navigator.pop(context);
                          if (b) {
                            PartsList.recall = true;
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) =>
                                  const VehicleDetailsScreen(),
                            ))
                                .then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => MainDashboard()),
                                  (Route r) => false);
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                          focusColor: MyTheme.black,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyTheme.black),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: MyTheme.black,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: MyTheme.black)),
                          labelText: 'Registration Number',
                          labelStyle: TextStyle(color: MyTheme.black)),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: TextField(
                      textCapitalization: TextCapitalization.characters,
                      cursorColor: MyTheme.black,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (String? stockref) async {
                        if (stockref != null) {
                          AuthUtils.showLoadingDialog(context);
                          bool b = await VehicleRepository.findVehicleFromStock(
                              stockref);
                          Navigator.pop(context);
                          if (b) {
                            PartsList.recall = true;
                            PartsList.isStockRef = true;
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) =>
                                  const VehicleDetailsScreen(),
                            ))
                                .then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => MainDashboard()),
                                  (Route r) => false);
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                          focusColor: MyTheme.black,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyTheme.black),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: MyTheme.black,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: MyTheme.black)),
                          labelText: 'Stock Reference Number',
                          labelStyle: TextStyle(color: MyTheme.black)),
                    ),
                  ),
                  TextButton(
                      onPressed: () => {
                            // Navigator.of(context).pop(),
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) =>
                                  const VehicleDetailsScreen(),
                            ))
                                .then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => MainDashboard()),
                                  (Route r) => false);
                            })
                          },
                      child: const Text(
                        "MANUAL ENTRY",
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              );
            }),
          );
        });
  }

  static void addPartDialog(BuildContext context, PartsList partsList) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10),
                  child: SizedBox(height: 100, width: 100, child: imageList[1]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  child: Text(
                    titleList[1],
                    style: const TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
            content: Builder(builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: TextField(
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (String? vrn) async {
                        if (vrn != null) {
                          AuthUtils.showLoadingDialog(context);
                          bool b =
                              await VehicleRepository.findVehicleFromVRN(vrn);
                          Navigator.pop(context);
                          if (b) {
                            PartsList.recall = true;
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) =>
                                  const VehicleDetailsScreen(),
                            ))
                                .then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => MainDashboard()),
                                  (Route r) => false);
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                          focusColor: MyTheme.black,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyTheme.black),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: MyTheme.black,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: MyTheme.black)),
                          labelText: 'Registration Number',
                          labelStyle: TextStyle(color: MyTheme.black)),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: TextField(
                      cursorColor: MyTheme.black,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (String? stockref) async {
                        if (stockref != null) {
                          AuthUtils.showLoadingDialog(context);
                          bool b = await VehicleRepository.findVehicleFromStock(
                              stockref);
                          Navigator.pop(context);
                          if (b) {
                            PartsList.recall = true;
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) =>
                                  const VehicleDetailsScreen(),
                            ))
                                .then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => MainDashboard()),
                                  (Route r) => false);
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                          focusColor: MyTheme.black,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyTheme.black),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: MyTheme.black,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: MyTheme.black)),
                          labelText: 'Stock Reference Number',
                          labelStyle: TextStyle(color: MyTheme.black)),
                    ),
                  ),
                  TextButton(
                      onPressed: () => {
                            // Navigator.of(context).pop(),
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) =>
                                  const VehicleDetailsScreen(),
                            ))
                                .then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => MainDashboard()),
                                  (Route r) => false);
                            })
                          },
                      child: const Text(
                        "MANUAL ENTRY",
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              );
            }),
          );
        });
  }

  static Widget qrWidget(
      BuildContext context,
      Key key,
      Function(QRViewController) onQRViewCreated,
      AnimationController animationController) {
    return LayoutBuilder(
      builder: (context , constraints ) { return Stack(
          children:[
            QRView(
              key: key,
              onQRViewCreated: onQRViewCreated,
              cameraFacing: CameraFacing.back,
              overlay: QrScannerOverlayShape(
                borderLength: 35,
                borderWidth: 4,
                borderColor: Colors.lightGreenAccent,
                cutOutHeight:constraints.maxHeight*0.3,
                cutOutWidth: constraints.maxWidth*0.7,
              ),
            ),
            Positioned(
              top: constraints.maxHeight/2 - 0.5,
              left: constraints.maxWidth*0.15,
              right: constraints.maxWidth*0.15,
              bottom: constraints.maxHeight/2 - 0.5,
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: animationController.value,
                    child: Container(
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  alignment: AlignmentDirectional.topEnd,
                  color: Colors.white54,
                  height: 60,
                  width: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/laser.png",
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
              ),
            ),
          ]

      ); },

    );
  }

  static Widget qrWidget2(
      BuildContext context,
      Key key,
      Function(QRViewController) onQRViewCreated,
      AnimationController animationController) {
    return Column(
      children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset("assets/laser.png",
              height: 60,
              width: 50,
            ),
          )
        ],
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: LayoutBuilder(
            builder: (context , constraints ) { return Stack(
                children:[
                  QRView(
                    key: key,
                    onQRViewCreated: onQRViewCreated,
                    cameraFacing: CameraFacing.back,
                    overlay: QrScannerOverlayShape(
                      borderLength: 35,
                      borderWidth: 4,
                      borderColor: Colors.lightGreenAccent,
                      cutOutHeight:constraints.maxHeight*0.4,
                      cutOutWidth: constraints.maxWidth*0.7,
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight/2 - 0.5,
                    left: constraints.maxWidth*0.15,
                    right: constraints.maxWidth*0.15,
                    bottom: constraints.maxHeight/2 - 0.5,
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: animationController.value,
                          child: Container(
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                ]

            ); },

          ),
        ),
      ),
    ],);

  }

  static Future<void> findStockFromID(
      BuildContext context, String partID) async {
    final File file = File(
        '${AppConfig.externalDirectory!.path}/UPLOAD_MANAGE_PARTS${DateFormat("ddMMyy").format(DateTime.now())}.txt');
    await file.writeAsString(
        "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())}: onSearchByPartId $partID\n",
        mode: FileMode.append);
    AuthUtils.showLoadingDialog(context);
    Map<String, dynamic> queryParams = {
      "clientid": AppConfig.clientId,
      "username": AppConfig.username,
      "stockid": partID,
      "searchby": "part"
    };
    List? responseList = await StockRepository.findStock(queryParams);
    Navigator.pop(context);
    if (responseList == null) {
      await file.writeAsString(
          "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())}: onSearchByPartId Part Not Found (or not synced)\n",
          mode: FileMode.append);
      Fluttertoast.showToast(msg: "Part Not Found (or not synced)");
      Navigator.pop(context);
      return;
    }
    Stock stock = Stock();
    stock.fromJson(responseList[0]);
    Part part = Part.fromStock(stock);
    part.partId =
        "MNG_PRT_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}";
    print(stock.stockID);

    await file.writeAsString(
        "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())}: onSearchByPartId Part Found ${part.partName}, ${stock.stockID}\n",
        mode: FileMode.append);
    Navigator.pop(context);
    openPartFoundDialog(context, part, stock);
  }


  static void scanLocationDialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 13),
              contentPadding: const EdgeInsets.all(10),
              title: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10),
                    child:
                        SizedBox(height: 100, width: 100, child: imageList[2]),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: Text(
                      titleList[2],
                      style: const TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
              content: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                            child: TextFormField(
                              controller: partIdEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  prefixIcon: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.0),
                                    child: Icon(Icons.search),
                                  ),
                                  prefixIconConstraints:
                                      BoxConstraints(minHeight: 5, minWidth: 5),
                                  hintText: "Part ID",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 20, 5, 20),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2))),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              color: MyTheme.materialColor,
                              child: TextButton(
                                  onPressed: () {
                                    findStockFromID(
                                        context, partIdEditingController.text);
                                  },
                                  child: Text(
                                    "Find",
                                    style: TextStyle(
                                        fontSize: 18, color: MyTheme.white),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Container(
                        color: MyTheme.materialColor,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ScanPart())).then((value) {
                                if(value != null){
                                  findStockFromID(context, value);
                                }
                              });
                            },
                            child: Text(
                              "Scan Part",
                              style:
                                  TextStyle(fontSize: 18, color: MyTheme.white),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Container(
                        color: MyTheme.materialColor,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => QuickScan()));
                            },
                            child: Text(
                              "Quick Scan",
                              style:
                                  TextStyle(fontSize: 18, color: MyTheme.white),
                            )),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  static void ScanStockReconcileFunction(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ScanStockReconcile()));
  }

  static void ScanImagingFunction(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ScanImaging()));
  }

  static void ManagePartsFunction(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ManagePart()));
  }

  static void WorkOrdersFunction(BuildContext context) async {
    AuthUtils.showLoadingDialog(context);
    Map<String, dynamic> queryParams = {
      "clientid": AppConfig.clientId,
      "WO_Status": "All",
    };
    String url = ApiConfig.baseUrl + ApiConfig.apiGetWorkOrders;
    List? responseList =
        await WorkOrderRepository.getWorkOrder(url, queryParams);

    List<workOrder> workOrderList =
        List.generate(responseList!.length, (index) {
      workOrder WorkOrder = workOrder();
      WorkOrder.fromJson(responseList[index]);
      return WorkOrder;
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WorkOrderScreen(workOrderList: workOrderList)));
  }

  static List<String> titleList = [
    "Add & Manage Breaker",
    "Add Part",
    "Scan Location",
    "Scan Stock Reconcile",
    "Scan Imaging",
    "Manage Parts",
    "Work Orders"
  ];
  static List<String> subtitleList = [
    "Add a new breaker, or customised to an existing",
    "Easily add the part according to your specific needs",
    "Allocate parts into a shelf location by scanning or searching the parts",
    "Quick scan stock take of your parts, and reconcile report",
    "Quick way to scan and take images",
    "Search and manage existing stock",
    "Process and manage picking, packing and dispatch orders"
  ];
  static List<Image> imageList = [
    Image.asset("assets/ic_add_new.png"),
    Image.asset("assets/ic_add_parts.png"),
    Image.asset("assets/ic_scan.png"),
    Image.asset("assets/ic_scan_stock_reconcile.png"),
    Image.asset("assets/ic_scan_imaging.png"),
    Image.asset("assets/ic_manage.png"),
    Image.asset("assets/ic_work_order.png")
  ];

  static openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(
          msg: "Couldn't open url.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static Widget infoContainer(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
          child: Text(
            title,
            style: TextStyle(color: MyTheme.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text(
            desc,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }

  static void openPartFoundDialog(
      BuildContext context, Part part, Stock stock) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 13),
                  contentPadding: const EdgeInsets.all(10),
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        infoContainer("Part ID", stock.stockID),
                        infoContainer("Part Name", part.partName),
                        infoContainer("Current Location", stock.vehicleLocation),
                        infoContainer("Vehicle",
                            "${stock.make} ${stock.model} ${stock.year}"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                          child: TextFormField(
                            controller: locationEditingController,
                            decoration: const InputDecoration(
                                hintText: "Location",
                                contentPadding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.grey, width: 2))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Container(
                            color: MyTheme.materialColor,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Scan Barcode",
                                  style:
                                      TextStyle(fontSize: 18, color: MyTheme.white),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Container(
                            color: MyTheme.materialColor,
                            child: TextButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.pop(context);
                                  scanLocationDialogue(context);
                                  StockRepository.updateLocation(stock, locationEditingController.text);},
                                child: Text(
                                  "Set Location",
                                  style:
                                      TextStyle(fontSize: 18, color: MyTheme.white),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Container(
                            color: MyTheme.materialColor,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "New Search",
                                  style:
                                      TextStyle(fontSize: 18, color: MyTheme.white),
                                )),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          );
        });
  }
}
