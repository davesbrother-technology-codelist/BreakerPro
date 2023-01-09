import 'package:breaker_pro/my_theme.dart';
import 'package:breaker_pro/screens/scanPart.dart';
import 'package:flutter/material.dart';

import '../dataclass/parts_list.dart';

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
  late PartsList partsList;
  late Map responseJson;
  bool modelEnable = true;
  String? makeValue;
  String? modelValue;
  String? fuelValue;
  String? bodyStyleValue;
  String? colourValue;
  String? mnfYearValue;
  String? onSiteDateValue;
  String? yearFromValue;
  String? yearToValue;

  late List<DropdownMenuItem<String>> makeMenuItems = [];
  late List<DropdownMenuItem<String>> modelMenuItems = [];
  late List<DropdownMenuItem<String>> fuelMenuItems = [];
  late List<DropdownMenuItem<String>> bodyStyleMenuItems = [];
  late List<DropdownMenuItem<String>> colourMenuItems = [];
  late List<DropdownMenuItem<String>> yearMenuItems = [];

  late Widget model;
  String defaultvalue = "1024-";
  String def = "1024-";
  TextEditingController _controller = TextEditingController(text: "1024-");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(238, 180, 22, .8),
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
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: Center(
                        child: Image(
                      image: AssetImage("assets/ic_manage.png"),
                      height: 100,
                      width: 90,
                    )),
                  ),
                  Text(
                    "Manage Parts",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Part ID",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          color: Colors.grey,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _controller =
                                      TextEditingController(text: "1024-");
                                });
                              },
                              child: Text(
                                "Reset",
                                style: TextStyle(
                                    fontSize: 18, color: MyTheme.white),
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            width: 200,
                            color: MyTheme.materialColor,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Find",
                                  style: TextStyle(
                                      fontSize: 18, color: MyTheme.white),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 360,
                    color: MyTheme.materialColor,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ScanPart()));
                        },
                        child: Text(
                          "Scan Part",
                          style: TextStyle(fontSize: 18, color: MyTheme.white),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 360,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void advanceSearch(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              content: Container(
                width: MediaQuery.of(context).size.width * 2,
                child: Builder(builder: (context) {
                  return Scaffold(
                      appBar: AppBar(
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
                            Row(
                              children: [
                                customTextField("VPN"),
                                customTextField("Stock Reference")
                              ],
                            ),
                            Row(
                              children: [
                                customTextField("Make"),
                                customTextField("Model")
                              ],
                            ),
                            Row(
                              children: [
                                customTextField("Manufacture Year"),
                                // model,
                                customTextField("Part Name")
                              ],
                            ),
                            Row(
                              children: [
                                customTextField("Ebay Number"),
                                customTextField("Location")
                              ],
                            ),
                            Row(
                              children: [customTextField("Part Number")],
                            ),
                          ],
                        ),
                      ));
                }),
              ),
              actions: [
                Container(
                  width: 150,
                  color: Colors.grey,
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Reset",
                        style: TextStyle(fontSize: 18, color: MyTheme.white),
                      )),
                ),
                Container(
                    width: 150,
                    color: MyTheme.materialColor,
                    child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Find",
                          style: TextStyle(fontSize: 18, color: MyTheme.white),
                        )))
              ],
            ),
          );
        });
  }

  Widget customTextField(String title,
      {String? dropDownValue,
      List<DropdownMenuItem<String>>? menuItems,
      bool enable = true}) {
    return Container(
      padding: containerEdgeInsetsGeometry,
      width: MediaQuery.of(context).size.width / 2,
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
          SizedBox(
            height: 60,
            child: menuItems == null
                ? TextField(
                    decoration: InputDecoration(
                    enabledBorder: border,
                    focusedBorder: border,
                  ))
                : DropdownButtonFormField(
                    isExpanded: true,
                    menuMaxHeight: 300,
                    decoration: InputDecoration(
                        enabledBorder: border, focusedBorder: border),
                    value: dropDownValue,
                    items: menuItems,
                    onChanged: (String? newValue) {
                      // dropDownValue = newValue;
                      if (title == 'Make') {
                        setState(() {
                          dropDownValue = null;
                          modelValue = null;
                        });
                        // modelEnable = true;

                        setState(() {
                          modelMenuItems = createMenuList(newValue.toString(),
                              modelMenuItems, responseJson);
                        });
                        // model = modelField("Model",
                        //     dropDownValue: modelValue,
                        //     menuItems: modelMenuItems,
                        //     enable: modelEnable);
                        //
                        // print("Done");
                        // for (DropdownMenuItem<String> a in modelMenuItems) {
                        //   Text t = a.child as Text;
                        //   print("${a.value} ${t.data}");
                        // }

                        // setState(() {});
                      }

                      setState(() {
                        dropDownValue = newValue;
                      });
                    },
                  ),
          ),
        ],
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
}
