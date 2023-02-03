import 'package:breaker_pro/my_theme.dart';
import 'package:breaker_pro/screens/scanPart.dart';
import 'package:breaker_pro/screens/stocks_screen.dart';
import 'package:breaker_pro/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api/api_config.dart';
import '../api/manage_part_repository.dart';
import '../api/stock_repository.dart';
import '../app_config.dart';
import '../dataclass/image_list.dart';
import '../dataclass/part.dart';
import '../dataclass/stock.dart';
import '../notification_service.dart';
import 'manage_parts2.dart';
import 'dart:io';

class ManagePart extends StatefulWidget {
  const ManagePart({Key? key}) : super(key: key);

  @override
  State<ManagePart> createState() => _ManagePartState();
}

class _ManagePartState extends State<ManagePart> {
  OutlineInputBorder border =
      OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.grey));
  TextStyle textStyle = TextStyle(fontSize: 17, color: MyTheme.grey);
  EdgeInsetsGeometry textEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(0, 10, 10, 10);
  EdgeInsetsGeometry containerEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(10, 5, 10, 5);
  late String defaultValue;
  late TextEditingController partIdController;
  late TextEditingController vrnController;
  late TextEditingController stockRefIdController;
  late TextEditingController makeController;
  late TextEditingController modelController;
  late TextEditingController mnfYearController;
  late TextEditingController partNameController;
  late TextEditingController ebayNumberController;
  late TextEditingController locationController;
  late TextEditingController partNumberController;

  @override
  void initState() {
    defaultValue = "${AppConfig.clientId}-171219-165004-12";
    partIdController = TextEditingController();
    vrnController = TextEditingController();
    stockRefIdController = TextEditingController();
    makeController = TextEditingController();
    modelController = TextEditingController();
    mnfYearController = TextEditingController();
    partNameController = TextEditingController();
    ebayNumberController = TextEditingController();
    locationController = TextEditingController();
    partNumberController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: MyTheme.materialColor,
          leading: Container(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          title: Text(
            "Manage Parts",
            style: TextStyle(color: MyTheme.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 10),
                child: Center(
                    child: Image(
                  image: AssetImage("assets/ic_manage.png"),
                  height: 100,
                  width: 90,
                )),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Manage Parts",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 5),
                child: TextFormField(
                  controller: partIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Part ID",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2))),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 5, 5, 5.0),
                      child: Container(
                        color: Colors.grey,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                partIdController.text = defaultValue;
                              });
                            },
                            child: Text(
                              "Reset",
                              style:
                                  TextStyle(fontSize: 18, color: MyTheme.white),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 14, 5),
                      child: Container(
                        color: MyTheme.materialColor,
                        child: TextButton(
                            onPressed: findStockFromID,
                            child: Text(
                              "Find",
                              style:
                                  TextStyle(fontSize: 18, color: MyTheme.white),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: MyTheme.materialColor,
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => ScanPart()))
                            .then((value) {
                          if (value != null) {
                            print("Output + $value");
                            partIdController.text = value;
                            findStockFromID();
                          }
                        });
                      },
                      child: Text(
                        "Scan Part",
                        style: TextStyle(fontSize: 18, color: MyTheme.white),
                      )),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: MyTheme.materialColor,
                  child: TextButton(
                      onPressed: () {
                        advanceSearch(context);
                      },
                      child: Text(
                        "Advance Search",
                        style: TextStyle(fontSize: 18, color: MyTheme.white),
                      )),
                ),
              ),
              // AspectRatio(
              //   aspectRatio: AppConfig.aspectMap[
              //   AppConfig.imageAspectRatio],
              //   child: SizedBox(
              //     width: 9,
              //     height: 6,
              //     child: Image.file(File("/data/user/0/com.example.breaker_pro/cache/IMG2023013114003820230131140038.jpg")),
              //   ),
              // ),
            ],
          ),
        ),
      );
  }

  void advanceSearch(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  8.0, 8, 8, MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Material(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          color: MyTheme.materialColor,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: MyTheme.white,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "Manage Parts",
                                  style: TextStyle(
                                      color: MyTheme.white, fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          customTextField("VRN", vrnController),
                          customTextField(
                              "Stock Reference", stockRefIdController),
                        ],
                      ),
                      Row(
                        children: [
                          customTextField("Make", makeController),
                          customTextField("Model", modelController)
                        ],
                      ),
                      Row(
                        children: [
                          customTextField("Manufacture Year", mnfYearController,
                              inputType: TextInputType.number),
                          // model,
                          customTextField("Part Name", partNameController)
                        ],
                      ),
                      Row(
                        children: [
                          customTextField("Ebay Number", ebayNumberController),
                          customTextField("Location", locationController)
                        ],
                      ),
                      Row(
                        children: [
                          customTextField("Part Number", partNumberController)
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 5, 5, 15),
                              child: Container(
                                color: Colors.grey,
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        vrnController.clear();
                                        stockRefIdController.clear();
                                        makeController.clear();
                                        modelController.clear();
                                        mnfYearController.clear();
                                        partNameController.clear();
                                        ebayNumberController.clear();
                                        locationController.clear();
                                        partNumberController.clear();
                                      });
                                    },
                                    child: Text(
                                      "Reset",
                                      style: TextStyle(
                                          fontSize: 18, color: MyTheme.white),
                                    )),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 14, 15),
                              child: Container(
                                color: MyTheme.materialColor,
                                child: TextButton(
                                    onPressed: findStockFromParams,
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
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget customTextField(String title, TextEditingController controller,
      {TextInputType? inputType}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
        child: TextFormField(
          controller: controller,
          keyboardType: inputType ?? TextInputType.text,
          decoration: InputDecoration(
              hintText: title,
              hintStyle: const TextStyle(color: Colors.grey),
              border: border),
        ),
      ),
    );
  }

  createMenuList(
      String title, List<DropdownMenuItem<String>> menu, Map responseJson) {
    List l = responseJson[title];
    menu = List<DropdownMenuItem<String>>.generate(
        l.length,
        (index) => DropdownMenuItem(
            value: l[index].toString(), child: Text(l[index])));
    // for (var a in menu) {
    //   print(a);
    // }
    return menu;
  }

  Future<void> findStockFromID() async {
    AuthUtils.showLoadingDialog(context);
    Map<String, dynamic> queryParams = {
      "clientid": AppConfig.clientId,
      "username": AppConfig.username,
      "stockid": partIdController.text,
      "searchby": "part"
    };
    List? responseList = await StockRepository.findStock(queryParams);
    Navigator.pop(context);
    if (responseList == null) {
      Fluttertoast.showToast(msg: "Part Not Found (or not synced)");
      return;
    }
    Stock stock = Stock();
    stock.fromJson(responseList[0]);
    Part part = Part.fromStock(stock);
    part.partId =
        "MNG_PRT_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}";
    print(stock.stockID);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ManageParts2(part: part, stock: stock)));
  }

  Future<void> findStockFromParams() async {
    AuthUtils.showLoadingDialog(context);
    Map<String, dynamic> queryParams = {
      "clientid": AppConfig.clientId,
      "username": AppConfig.username,
      "searchby": "part",
      "searchmode": "list",
      "make": makeController.text,
      "model": modelController.text,
      "stockref": stockRefIdController.text,
      "year": mnfYearController.text,
      "partname": partNameController.text,
      "location": locationController.text,
      "ebaynumber": ebayNumberController.text,
      "vrn": vrnController.text,
      "partnumber": partNumberController.text,
    };
    List? responseList = await StockRepository.findStock(queryParams);
    Navigator.pop(context);
    if (responseList == null) {
      Fluttertoast.showToast(msg: "Part Not Found (or not synced)");
      return;
    }

    List<Stock> stockList = List.generate(responseList.length, (index) {
      Stock stock = Stock();
      stock.fromJson(responseList[index]);
      // print("${responseList[index]}");
      return stock;
    });
    List<Part> partList = List.generate(responseList.length, (index) {
      Part part = Part.fromStock(stockList[index]);
      // part.partId =
      //     "MNG_PRT_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}";
      // print("${stockList[index].stockID} ${part.partCondition}");
      return part;
    });

    // print(stock.stockID);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            StocksScreen(stockList: stockList, partList: partList)));
  }


}
