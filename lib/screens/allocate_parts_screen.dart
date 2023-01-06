import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:breaker_pro/screens/addPart.dart';
import 'package:breaker_pro/screens/customise_parts_screen.dart';
import 'package:flutter/material.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import '../dataclass/part.dart';
import '../my_theme.dart';
import 'main_dashboard.dart';

class AllocatePartsScreen extends StatefulWidget {
  const AllocatePartsScreen({Key? key}) : super(key: key);

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
  String? selectedItem1;
  String? selectedItem2;

  List<String> items1 = [
    '04-08 AUDI A4',
    'BODY PARTS',
    'ENGINE BAY',
    'FULL LIST',
    'INTERIOR',
    'LIGHTS',
    'MECHANICAL',
    'NISSAN MICRA 03-10',
    'RENAULT CLIO 05-09',
    'VOLVO S40 04-07',
    'VW PASSAT 01-05 EBAY',
    'VW PASSAT 05-10'
  ];
  List<String> items2 = [
    'INTERIOR',
    'MECHANICAL',
    'BODY PARTS',
    'ENGINE BAY',
    'WHEELS',
    'LIGHTS',
    'DASHBOARD BARE',
    'GLASS',
    'ELECTRICAL'
  ];
  List<DropdownMenuItem<String>> dropdownItems1 = [];
  List<DropdownMenuItem<String>> dropdownItems2 = [];

  OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(width: 2, color: MyTheme.blue));
  late List<Part> partsList;
  List<Part> selectedPartsList = [];
  bool selectAll = false;
  double _headerHeight = 60.0;
  double _bodyHeight = 180.0;
  BottomDrawerController _controller = BottomDrawerController();
  @override
  void initState() {
    partsList = PartsList.partList;
    super.initState();
    for (String item in items1) {
      dropdownItems1.add(DropdownMenuItem(
        child: Text(item),
        value: item,
      ));
    }
    for (String item in items2) {
      dropdownItems2.add(DropdownMenuItem(
        child: Text(item),
        value: item,
      ));
    }
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
                PartsList partsList = PartsList();
                PartsList.partList = selectedPartsList;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CustomisePartsScreen(),
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => MainDashboard()));
              },
            ),
            actions: [
              IconButton(
                  onPressed: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddPart()))
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
                padding: EdgeInsets.all(5),
                child: TextField(
                  style: TextStyle(color: MyTheme.materialColor),
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
                    labelText: 'Type your keyword here',
                    labelStyle: TextStyle(color: MyTheme.black54),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: CheckboxListTile(
                  tileColor: MyTheme.black12,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: selectAll,
                  title: const Text(
                    "Select All",
                    textAlign: TextAlign.left,
                  ),
                  onChanged: (bool? value) {
                    setState(() {
                      for (Part part in partsList) {
                        part.isSelected = value!;
                        selectAll = value;
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: partsList.length,
                  controller: ScrollController(),
                  separatorBuilder: (_, __) => const SizedBox(height: 5),
                  itemBuilder: (context, index) => Container(
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
                          selectedPartsList.add(partsList[index]);
                        } else {
                          selectedPartsList.remove(partsList[index]);
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
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
                _controller.close();
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
                _controller.close();
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
        width: double.infinity,
        height: _bodyHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Filter Option",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              customTextField(
                  "Pre Defined List", dropdownItems1, selectedItem1),
              customTextField("Part Type", dropdownItems2, selectedItem2)
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextField(String title,
      List<DropdownMenuItem<String>> dropdownItems, String? selectedItem1) {
    return Container(
      padding: containerEdgeInsetsGeometry,
      width: MediaQuery.of(context).size.width,
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
            value: selectedItem1,
            items: dropdownItems,
            onChanged: (value) {
              setState(() {
                selectedItem1 = value!;
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
}
