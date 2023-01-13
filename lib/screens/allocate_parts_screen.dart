import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:breaker_pro/screens/addPart.dart';
import 'package:breaker_pro/screens/customise_parts_screen.dart';
import 'package:flutter/material.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:intl/intl.dart';
import '../api/api_config.dart';
import '../app_config.dart';
import '../dataclass/part.dart';
import '../dataclass/vehicle.dart';
import '../my_theme.dart';

class AllocatePartsScreen extends StatefulWidget {
  const AllocatePartsScreen({Key? key, required this.vehicle})
      : super(key: key);
  final Vehicle vehicle;

  @override
  State<AllocatePartsScreen> createState() => _AllocatePartsScreenState();
}

class _AllocatePartsScreenState extends State<AllocatePartsScreen> {
  EdgeInsetsGeometry textEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(0, 10, 10, 10);
  EdgeInsetsGeometry containerEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(10, 5, 10, 5);
  TextStyle textStyle = TextStyle(fontSize: 12, color: MyTheme.grey);
  OutlineInputBorder border =
      OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.grey));
  String? predefinedValue;
  String? partTypeValue;

  late List<String> preDefinedList;
  late List<String> partTypeList;

  List<DropdownMenuItem<String>> preDefinedDropDownItems = [];
  List<DropdownMenuItem<String>> partTypeDropDownItems = [];

  OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(width: 2, color: MyTheme.blue));
  late List<Part> partsList;
  bool selectAll = false;
  final double _headerHeight = 60.0;
  final double _bodyHeight = 300.0;
  String search = "";
  final BottomDrawerController _controller = BottomDrawerController();
  @override
  void initState() {
    partsList = List<Part>.from(PartsList.partList);
    fetchPartTypeList();
    fetchPreDefinedList();
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

  @override
  void dispose() {
    PartsList.partList = partsList;
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
            height: 50,
            color: MyTheme.materialColor,
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () {
                String msg =
                    "\n\n\n\n**************** Customize Parts clicked ${DateFormat("hh:mm:ss yyyy/MM/dd").format(DateTime.now())} **************** \nSelected Part Name: ";

                for (Part part in PartsList.selectedPartList) {
                  msg += "${part.partName.toString()} ,";
                }
                FlutterLogs.logToFile(
                    logFileName:
                        "${ApiConfig.baseQueryParams['username']}_${DateFormat("ddMMyy").format(DateTime.now())}",
                    overwrite: false,
                    logMessage: msg);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      CustomisePartsScreen(vehicle: widget.vehicle),
                ));
              },
              child: Text(
                "Customise Parts",
                style: TextStyle(color: MyTheme.white),
              ),
            ),
          ),
          appBar: AppBar(
            title: Text(
              'Allocate Parts',
              style: TextStyle(color: MyTheme.white),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: MyTheme.white),
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
                          p.isSelected = true;
                          PartsList.selectedPartList.add(p);
                          partsList.add(p);
                        });
                      }
                    });
                  },
                  icon: Icon(Icons.add_circle, color: MyTheme.white)),
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
                padding: const EdgeInsets.all(5),
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
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                    onTap: () async {
                      await openSelectAll(context);
                      setState(() {
                        for (Part part in partsList) {
                          part.isSelected = selectAll;
                        }
                        if (selectAll) {
                          PartsList.selectedPartList = partsList;
                        } else {
                          PartsList.selectedPartList = [];
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(value: selectAll, onChanged: (bool? value) {}),
                        const Text(
                          "Select All",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    )),
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
                          partsList[index].partType !=
                              partTypeValue.toString()) {
                        return const SizedBox.shrink();
                      }

                      if (search != "" &&
                          !partsList[index]
                              .partName
                              .toLowerCase()
                              .contains(search.toLowerCase())) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        height: 50,
                        color: Colors.white,
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: partsList[index].isSelected,
                          secondary: Text(partsList[index].id.toString()),
                          title: Text(partsList[index].partName),
                          onChanged: (bool? value) {
                            partsList[index].isSelected = value!;
                            if (value == true) {
                              PartsList.selectedPartList.add(partsList[index]);
                            } else {
                              PartsList.selectedPartList
                                  .remove(partsList[index]);
                            }
                            setState(() {});
                          },
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 60)
            ],
          ),
        ),
      ),
      _buildBottomDrawer(context),
    ]);
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

  fetchPartTypeList() {
    List<String> l =
        List.generate(partsList.length, (index) => partsList[index].partType);
    var seen = <String>{};
    partTypeList = l.where((part) => seen.add(part)).toList();
  }

  fetchPreDefinedList() {
    List<String> l = List.generate(
        partsList.length, (index) => partsList[index].predefinedList);
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

  openSelectAll(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget okButton = TextButton(
      onPressed: () {
        setState(() {
          selectAll = !selectAll;
        });
        Navigator.pop(context);
      },
      child: const Text("OK"),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Click OK to Select All Parts"),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
