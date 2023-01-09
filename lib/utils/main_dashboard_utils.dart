import 'package:breaker_pro/api/vehicle_repository.dart';
import 'package:breaker_pro/screens/quickScan.dart';
import 'package:breaker_pro/screens/scanImaging.dart';
import 'package:breaker_pro/screens/scanStockReconcile.dart';
import 'package:breaker_pro/screens/vehicle_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:url_launcher/url_launcher.dart';
import '../dataclass/parts_list.dart';
import '../my_theme.dart';
import 'package:breaker_pro/screens/scanPart.dart';
import 'package:breaker_pro/screens/manageParts.dart';

import 'auth_utils.dart';

class MainDashboardUtils {
  static List<Function?> functionList = [
    addBreakerDialog,
    addPartDialog,
    scanLocationDialogue,
    f4,
    f5,
    f6,
    f7
  ];

  static void addBreakerDialog(BuildContext context, PartsList partsList) {
    if (PartsList.partList!.isEmpty) {
      Fluttertoast.showToast(msg: "Fetching Parts");
      return;
    }
    showDialog(
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
                    titleList[0],
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
                      textInputAction: TextInputAction.search,
                      onSubmitted: (String? vrn) async {
                        if (vrn != null) {
                          AuthUtils.showLoadingDialog(context);
                          bool b =
                              await VehicleRepository.findVehicleFromVRN(vrn);
                          Navigator.pop(context);
                          if (b) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => VehicleDetailsScreen()));
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
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => VehicleDetailsScreen()));
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
                            Navigator.of(context).pop(),
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const VehicleDetailsScreen(),
                            ))
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
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (String? vrn) async {
                        if (vrn != null) {
                          AuthUtils.showLoadingDialog(context);
                          bool b =
                              await VehicleRepository.findVehicleFromVRN(vrn);
                          Navigator.pop(context);
                          if (b) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => VehicleDetailsScreen()));
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
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => VehicleDetailsScreen()));
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
                            Navigator.of(context).pop(),
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const VehicleDetailsScreen(),
                            ))
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

  static void scanLocationDialogue(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10),
                  child: SizedBox(height: 100, width: 100, child: imageList[2]),
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
            content: Builder(builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: TextField(
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
                                    borderSide:
                                        BorderSide(color: MyTheme.black)),
                                labelText: 'Part ID',
                                labelStyle: TextStyle(color: MyTheme.black)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.3 - 20,
                          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                          color: MyTheme.materialColor,
                          child: TextButton(
                              onPressed: () => {
                                    Navigator.of(context).pop(),
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => ScanPart()))
                                  },
                              child: Text(
                                "Find",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: MyTheme.white,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    color: MyTheme.materialColor,
                    child: TextButton(
                        onPressed: () => {
                              Navigator.of(context).pop(),
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ScanPart()))
                            },
                        child: Text(
                          "Scan Part",
                          style: TextStyle(
                            fontSize: 18,
                            color: MyTheme.white,
                          ),
                        )),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    color: MyTheme.materialColor,
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: TextButton(
                        onPressed: () => {
                              Navigator.of(context).pop(),
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => QuickScan()))
                            },
                        child: Text(
                          "Quick Scan",
                          style: TextStyle(
                            fontSize: 18,
                            color: MyTheme.white,
                          ),
                        )),
                  ),
                ],
              );
            }),
          );
        });
  }

  static void f4(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ScanStockReconcile()));
  }

  static void f5(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ScanImaging()));
  }

  static void f6(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ManagePart()));
  }

  static void f7(BuildContext context) {
    print("f7");
  }

  static List<String> titleList = [
    "Add Breaker",
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
}
