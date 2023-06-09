import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:breaker_pro/api/api_config.dart';
import 'package:breaker_pro/app_config.dart';
import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:breaker_pro/dataclass/vehicle.dart';
import 'package:breaker_pro/screens/main_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:breaker_pro/screens/customise_parts_screen2.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dataclass/image_list.dart';
import '../dataclass/part.dart';
import '../my_theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/main_dashboard_utils.dart';
import 'addPart.dart';

class CustomisePartsScreen extends StatefulWidget {
  const CustomisePartsScreen({Key? key, required this.vehicle})
      : super(key: key);
  final Vehicle vehicle;

  @override
  State<CustomisePartsScreen> createState() => _CustomisePartsScreenState();
}

class _CustomisePartsScreenState extends State<CustomisePartsScreen> {
  EdgeInsetsGeometry textEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(0, 10, 10, 10);
  EdgeInsetsGeometry containerEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(10, 5, 10, 5);
  TextStyle textStyle = TextStyle(fontSize: 12, color: MyTheme.grey);
  OutlineInputBorder border =
      OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.grey));
  String? predefinedValue;
  String? partTypeValue;
  String search = "";
  late List<String> preDefinedList;
  late List<String> partTypeList;

  List<DropdownMenuItem<String>> preDefinedDropDownItems = [];
  List<DropdownMenuItem<String>> partTypeDropDownItems = [];

  OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(width: 2, color: MyTheme.blue));
  late List<Part> partsList;
  List<Part> selectedPartsList = [];
  bool selectAll = false;
  final double _headerHeight = 60.0;
  final double _bodyHeight = 300.0;
  final BottomDrawerController _controller = BottomDrawerController();

  @override
  void initState() {
    PartsList.cachedVehicle = widget.vehicle;
    partsList = PartsList.selectedPartList;
    for (Part part in partsList) {
      part.partId =
          "PRT${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${PartsList.partCount.toString().padLeft(4, '0')}";
      PartsList.partCount += 1;
    }
    fetchPartType();
    fetchParType();
    super.initState();
    for (String item in preDefinedList) {
      preDefinedDropDownItems.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }
    for (String item in partTypeList) {
      partTypeDropDownItems.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }
  }

  savePart() async {
    try {
      Box<Part> box = await Hive.openBox('selectPartListBox');
      Map<dynamic, Part> boxMap = {
        for (var part in PartsList.selectedPartList) part.partName: part
      };
      if (box.isOpen) {
        box.putAll(boxMap);
        print("saved selectpartList");
        print(PartsList.partList[0].isSelected);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // savePart();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          _controller.close();
        },
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            color: MyTheme.materialColor,
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () {
                openUploadDialog(context);
              },
              child: Text(
                "Upload",
                style: TextStyle(color: MyTheme.white),
              ),
            ),
          ),
          appBar: AppBar(
            title: Text(
              'Customise Parts',
              style: TextStyle(color: MyTheme.white),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: MyTheme.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    await Navigator.push<Part>(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddPart()))
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          Part p = value;
                          p.isSelected = false;
                          // PartsList.selectedPartList.add(p);
                          partsList.add(p);
                        });
                      }
                    });
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: MyTheme.white,
                  )),
              IconButton(
                  onPressed: () => {_controller.open()},
                  icon: Icon(
                    Icons.filter_list,
                    color: MyTheme.white,
                  )),
            ],
          ),
          body: Column(
            children: [
              Container(
                color: MyTheme.materialColor,
                padding: EdgeInsets.all(5),
                child: TextField(
                  style: TextStyle(color: MyTheme.materialColor),
                  onChanged: (String? value) {
                    setState(() {
                      search = value ?? "";
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyTheme.white,
                    border: border,
                    focusedBorder: focusedBorder,
                    enabledBorder: border,
                    prefixIcon: Icon(
                      Icons.search,
                      color: MyTheme.black54,
                    ),
                    hintText: 'Type your keyword here',
                    hintStyle: TextStyle(color: MyTheme.black54),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: partsList.length,
                  controller: ScrollController(),
                  itemBuilder: (context, index) {
                    if (predefinedValue != null &&
                        !partsList[index]
                            .predefinedList
                            .contains(predefinedValue.toString())) {
                      return const SizedBox.shrink();
                    }
                    if (partTypeValue != null &&
                        partsList[index].partType != partTypeValue.toString()) {
                      return const SizedBox.shrink();
                    }
                    if (search != "" &&
                        !partsList[index]
                            .partName
                            .toLowerCase()
                            .contains(search.toLowerCase())) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: SizedBox(
                        height: 50,
                        child: ListTile(
                          tileColor: partsList[index].forUpload
                              ? Colors.amberAccent
                              : Colors.white,
                          onTap: () => {
                            Navigator.of(context)
                                .push<Part>(MaterialPageRoute(
                                    builder: (context) => Customise(
                                          part: partsList[index],
                                        )))
                                .then((value) {
                              setState(() {
                                if (value != null) {
                                  partsList[index] = value;
                                  savePart();
                                  print(partsList[index].imgList);
                                }
                              });
                            }),
                          },
                          trailing: Text(partsList[index].id.toString()),
                          title: Text(partsList[index].partName,),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 60)
            ],
          ),
        ),
      ),
      _buildBottomDrawer(context),
    ]);
  }

  Future<void> uploadParts() async {
    for (Part part in partsList) {
      Map m = {...ApiConfig.baseQueryParams, ...part.toJson()};
      var r = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.apiSubmitParts),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(m),
      );

      print(r);
    }

    Fluttertoast.showToast(msg: "Parts Upload Successful");
  }

  Future<void> uploadVehicle() async {
    Map m = {...ApiConfig.baseQueryParams, ...widget.vehicle.toJson()};
    var r = await http.post(
      Uri.parse(
          "${ApiConfig.baseUrl}${ApiConfig.apiSubmitVehicle}?ClientID=${ApiConfig.baseQueryParams['clientid']}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(m),
    );

    print(r);

    Fluttertoast.showToast(msg: "Vehicle Upload Successful");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => MainDashboard()));
  }

  openUploadDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget okButton = TextButton(
      onPressed: () async {
        if(PartsList.isUploading){
          PartsList.newAdded = true;
        }
        for (Part p in partsList) {
          if (p.forUpload) {
            PartsList.uploadPartList.add(p);
            print(p.imgList);
          }
        }
        Box<Part> box = await Hive.openBox('uploadPartListBox${widget.vehicle.vehicleId}');
        Map<dynamic, Part> boxMap = {
          for (var part in PartsList.uploadPartList) part.partName: part
        };
        if (box.isOpen) {
          await box.putAll(boxMap);
          print("saved uploadpartList");
        }
        await box.close();
        PartsList.uploadQueue.add(widget.vehicle.vehicleId);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('vehicle');
        MainDashboardUtils.titleList[0] = "Add & Manage Breaker";
        ImageList.vehicleImgList = [];
        PartsList.cachedVehicle = null;
        PartsList.recall = false;
        PartsList.isStockRef = false;
        PartsList.selectedPartList = [];
        Box<Part> box3 = await Hive.openBox('partListBox');
        Box<Part> box1 = await Hive.openBox('selectPartListBox');
        await box3.clear();
        await box1.clear();
        for(Part part in PartsList.partList){
          part.isSelected = false;
        }
        await PartsList.loadParts(
            ApiConfig.baseUrl + ApiConfig.apiPartList, ApiConfig.baseQueryParams);
        PartsList.uploadPartList = [];
        await prefs.setString(
            'uploadQueue', jsonEncode({'uploadQueue': PartsList.uploadQueue}));
        await prefs.setString(
            widget.vehicle.vehicleId, jsonEncode(widget.vehicle.toJson()));
        PartsList.saveVehicle = false;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => MainDashboard()),
            (Route route) => false);
      },
      child: const Text("OK"),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Are you sure you want to upload?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildBottomDrawer(BuildContext context) {
    return BottomDrawer(
      header: _buildBottomDrawerHead(context),
      body: _buildBottomDrawerBody(context),
      headerHeight: 0,
      drawerHeight: _bodyHeight,
      controller: _controller,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 60,
          spreadRadius: 0,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ],
    );
  }

  Widget _buildBottomDrawerHead(BuildContext context) {
    return Container(
      height: _headerHeight,
      child: Row(
        children: [
          Container(
            color: MyTheme.materialColor,
            width: MediaQuery.of(context).size.width / 3,
            child: TextButton(
              onPressed: () {
                setState(() {
                  predefinedValue = null;
                  partTypeValue = null;
                  _controller.close();
                });
              },
              child: Text(
                "ALL",
                style: TextStyle(color: MyTheme.white),
              ),
            ),
          ),
          Container(
            color: MyTheme.materialColor,
            width: MediaQuery.of(context).size.width / 3,
            child: TextButton(
              onPressed: () {
                setState(() {
                  print(predefinedValue);
                  _controller.close();
                });
              },
              child: Text(
                "APPLY FILTER",
                style: TextStyle(color: MyTheme.white),
              ),
            ),
          ),
          Container(
            color: MyTheme.materialColor,
            width: MediaQuery.of(context).size.width / 3,
            child: TextButton(
              onPressed: () {
                _controller.close();
              },
              child: Text(
                "CLOSE",
                style: TextStyle(color: MyTheme.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomDrawerBody(BuildContext context) {
    return Scaffold(
      body: Container(
        height: _bodyHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  "Filter Option",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              customTextField(
                  "Pre Defined List", preDefinedDropDownItems, predefinedValue),
              customTextField("Part Type", partTypeDropDownItems, partTypeValue)
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextField(String title,
      List<DropdownMenuItem<String>> dropdownItems, String? selectedItem1) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: textEdgeInsetsGeometry,
            child: Text(
              title,
              style: textStyle,
            ),
          ),
          DropdownButtonFormField(
            isExpanded: true,
            value: selectedItem1,
            items: dropdownItems,
            onChanged: (value) {
              setState(() {
                selectedItem1 = value;
                switch (title) {
                  case 'Pre Defined List':
                    {
                      predefinedValue = value;
                    }
                    break;
                  case 'Part Type':
                    {
                      partTypeValue = value;
                    }
                    break;
                }
              });
            },
            decoration: InputDecoration(
                hintText: selectedItem1,
                enabledBorder: border,
                focusedBorder: border),
          ),
        ],
      ),
    );
  }

  fetchPartType() {
    List<String> l = List.generate(PartsList.partList.length,
        (index) => PartsList.partList[index].partType);
    var seen = <String>{};
    partTypeList = l.where((part) => seen.add(part)).toList();
  }

  fetchParType() {
    List<String> l = List.generate(PartsList.partList.length,
        (index) => PartsList.partList[index].predefinedList);
    var seen = <String>{};
    var a = l.where((part) => seen.add(part)).toList();
    List<String> y = [];
    for (String b in a) {
      y.addAll(b.split(","));
    }
    var seenn = <String>{};
    List<String> an = y.where((part) => seenn.add(part)).toList();
    preDefinedList = an.sublist(2);
  }
}
