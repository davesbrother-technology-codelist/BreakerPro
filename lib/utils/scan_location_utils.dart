import 'package:breaker_pro/utils/main_dashboard_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

import 'package:intl/intl.dart';

import '../api/stock_repository.dart';
import '../app_config.dart';
import '../dataclass/part.dart';
import '../dataclass/stock.dart';
import '../my_theme.dart';
import '../screens/scanPart.dart';
import 'auth_utils.dart';

class ScanLocationUtils{

  static TextEditingController locationEditingController =
  TextEditingController();

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
                                onPressed: () {
// Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ScanPart())).then((value) {
                                    if(value != null){
                                      findStockFromID(context, value);
                                    }
                                  });
                                },
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
                                  MainDashboardUtils.scanLocationDialogue(context);
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
                                onPressed: () {Navigator.pop(context);},
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


