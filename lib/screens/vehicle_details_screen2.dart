import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:breaker_pro/screens/make.dart';
import 'package:image_picker/image_picker.dart';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:breaker_pro/screens/allocate_parts_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dataclass/parts_list.dart';
import '../my_theme.dart';
import 'capture_screen.dart';
import 'package:breaker_pro/screens/main_dashboard.dart';

// class Constants{
//   String selectedItem='';
// }
// Constants item=Constants();
class VehicleDetailsScreen2 extends StatefulWidget {
  const VehicleDetailsScreen2({Key? key}) : super(key: key);

  @override
  State<VehicleDetailsScreen2> createState() => _VehicleDetailsScreen2State();
}

class _VehicleDetailsScreen2State extends State<VehicleDetailsScreen2> {
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
  List<File> images = [];
  final ImagePicker _picker = ImagePicker();

  late String selectedYear1 = '1999';
  late String selectedYear2 = '2000';
  late String selectedYear3 = '2001';

  List<DropdownMenuItem<String>> years1 = [];

  DateTime? selectedDate1;
  DateTime? selectedDate2;
  DateTime? selectedDate3;
  DateTime? selectedDate4;

  late String formattedDate1;
  String? formattedDate2;
  late String formattedDate3;
  late String formattedDate4;

  @override
  void initState() {
    print(PartsList.partList.length);
    fetchSelectList();
    super.initState();
    formattedDate1 = '';
    formattedDate2 = '';
    formattedDate3 = '';
    formattedDate4 = '';

    int currentYear = DateTime.now().year;
    for (int i = 1980; i <= currentYear; i++) {
      years1.add(
        DropdownMenuItem(
          child: Text(i.toString()),
          value: i.toString(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    model = modelField("Model",
        dropDownValue: modelValue,
        menuItems: modelMenuItems,
        enable: modelEnable);
    return Scaffold(
        appBar: AppBar(
          leading: Container(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => MainDashboard()));
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          title: Text(
            "Vehicle Details",
            style: TextStyle(color: MyTheme.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  customTextField("Registration Number"),
                  customTextField("Stock Reference")
                ],
              ),
              Row(
                children: [
                  customTextField("Make",
                      dropDownValue: makeValue, menuItems: makeMenuItems),
                  // custom2TextField("Make",Make()),
                  customTextField("CC")
                ],
              ),
              Row(
                children: [
                  customTextField("Model",
                      dropDownValue: modelValue,
                      menuItems: modelMenuItems,
                      enable: modelEnable),
                  // model,
                  customTextField("Type Model")
                ],
              ),
              Row(
                children: [
                  customTextField("Fuel",
                      dropDownValue: fuelValue, menuItems: fuelMenuItems),
                  customTextField("Body Style",
                      dropDownValue: bodyStyleValue,
                      menuItems: bodyStyleMenuItems)
                ],
              ),
              Row(
                children: [customTextField("UIN"), customTextField("Colour")],
              ),
              Row(
                children: [
                  customTextField("Transmission"),
                  customTextField("Engine Code")
                ],
              ),
              Row(
                children: [
                  // customTextField("Manufacturing Year",
                  //     dropDownValue: mnfYearValue, menuItems: yearMenuItems),
                  custom31TextField(
                      "Manufacturing Year", selectedYear1, years1),
                  custom4D4TextField("On Site Date")
                  // customTextField("On Site Date",
                  //     dropDownValue: onSiteDateValue, menuItems: yearMenuItems)
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child:
                          custom31TextField("Year Range", selectedYear2, years1)
                      // customTextField("Year Range",
                      //     dropDownValue: yearFromValue,
                      //     menuItems: yearMenuItems)

                      ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      "To",
                      style: textStyle,
                    ),
                  ),
                  Expanded(child: custom31TextField("", selectedYear3, years1)
                      // customTextField("",
                      //     dropDownValue: yearToValue, menuItems: yearMenuItems)
                      )
                ],
              ),
              Divider(
                thickness: 2, // thickness of the line
                indent: 10, // empty space to the leading edge of divider.
                endIndent:
                    10, // empty space to the trailing edge of the divider.
                color:
                    MyTheme.black, // The color to use when painting the line.
                height: 10, // The divider's height extent.
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Web Fields",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Row(
                children: [customTextField("Make"), customTextField("Engine")],
              ),
              Container(
                padding: containerEdgeInsetsGeometry,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: textEdgeInsetsGeometry,
                      child: Text(
                        "Model",
                        style: textStyle,
                      ),
                    ),
                    SizedBox(
                        height: 60,
                        child: TextField(
                            decoration: InputDecoration(
                          enabledBorder: border,
                          focusedBorder: border,
                        ))),
                  ],
                ),
              ),
              Row(
                children: [customTextField("Style"), customTextField("Colour")],
              ),
              Divider(
                thickness: 2, // thickness of the line
                indent: 10, // empty space to the leading edge of divider.
                endIndent:
                    10, // empty space to the trailing edge of the divider.
                color:
                    MyTheme.black, // The color to use when painting the line.
                height: 10, // The divider's height extent.
              ),
              Row(
                children: [
                  customTextField("Mileage"),
                  customTextField("Cost Price")
                ],
              ),
              Row(
                children: [
                  custom4D3TextField("Collection Date"),
                  custom4D2TextField("Depollution Date")
                ],
              ),
              Row(
                children: [
                  custom4D1TextField("Destruction Date"),
                  customTextField("Weight")
                ],
              ),
              Container(
                padding: containerEdgeInsetsGeometry,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: textEdgeInsetsGeometry,
                      child: Text(
                        "Vehicle Location",
                        style: textStyle,
                      ),
                    ),
                    SizedBox(
                        height: 60,
                        child: TextField(
                            decoration: InputDecoration(
                          enabledBorder: border,
                          focusedBorder: border,
                        ))),
                  ],
                ),
              ),
              Container(
                padding: containerEdgeInsetsGeometry,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: textEdgeInsetsGeometry,
                      child: Text(
                        "Enter comments",
                        style: textStyle,
                      ),
                    ),
                    SizedBox(
                        height: 100,
                        child: TextField(
                            minLines: 3,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: "Enter Comments",
                              enabledBorder: border,
                              focusedBorder: border,
                            ))),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                height: ImageList.imgList.isNotEmpty ? 200 : 80,
                color: MyTheme.black12,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: MyTheme.black,
                            size: 30,
                          ),
                          label: Text(
                            'Capture',
                            style:
                                TextStyle(color: MyTheme.black, fontSize: 20),
                          ),
                          onPressed: openCamera,
                        ),
                        TextButton.icon(
                          icon: Icon(
                            Icons.photo,
                            color: MyTheme.black,
                            size: 30,
                          ),
                          label: Text('Gallery',
                              style: TextStyle(
                                  color: MyTheme.black, fontSize: 20)),
                          onPressed: () async {
                            // List<XFile> pickedGallery= (await _picker.pickMultiImage());
                            var image = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);

                            setState(() {
                              // images.add(image);
                              // images= pickedGallery.map((e) => File(e.path)).toList();
                              ImageList.imgList.add(image!.path);
                            });
                          },
                        ),
                      ],
                    ),
                    ImageList.imgList.isNotEmpty
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: ImageList.imgList.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Stack(
                                        // alignment: Alignment.bottomLeft,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Image.file(
                                              File(ImageList.imgList[index]),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.all(0),
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              setState(() {
                                                ImageList.imgList
                                                    .removeAt(index);
                                              });
                                            },
                                          ),
                                        ]),
                                  );
                                }),
                          )
                        : SizedBox()
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                color: const Color.fromRGBO(238, 180, 22, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Breaking for Spares',
                        style: TextStyle(color: MyTheme.white, fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AllocatePartsScreen(),
                        ));
                      },
                      child: Text(
                        'Allocate Parts',
                        style: TextStyle(color: MyTheme.white, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget custom2TextField(String title, Widget name) {
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
              TextField(
                  onTap: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => name));
                    });
                  },
                  decoration: InputDecoration(
                    // hintText: '${Constants().selectedItem}',
                    enabledBorder: border,
                    focusedBorder: border,
                  )),
            ]));
  }

  Widget custom4D4TextField(String title) {
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
          TextField(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate4 ?? DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != selectedDate4)
                setState(() {
                  selectedDate4 = picked;
                });
            },
            decoration: InputDecoration(
              hintText: selectedDate4 == '' ? '' : selectedDate4.toString(),
              enabledBorder: border,
              focusedBorder: border,
            ),
          ),
        ],
      ),
    );
  }

  Widget custom4D3TextField(String title) {
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
          TextField(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate3 ?? DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != selectedDate3)
                setState(() {
                  selectedDate3 = picked;
                });
            },
            decoration: InputDecoration(
              hintText: selectedDate3 == '' ? '' : selectedDate3.toString(),
              enabledBorder: border,
              focusedBorder: border,
            ),
          ),
        ],
      ),
    );
  }

  Widget custom4D2TextField(String title) {
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
          TextField(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate2 ?? DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != selectedDate2)
                setState(() {
                  selectedDate2 = picked;
                });
            },
            decoration: InputDecoration(
              hintText: selectedDate2 == '' ? '' : selectedDate2.toString(),
              enabledBorder: border,
              focusedBorder: border,
            ),
          ),
        ],
      ),
    );
  }

  Widget custom4D1TextField(String title) {
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
          TextField(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate1 ?? DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != selectedDate1)
                setState(() {
                  selectedDate1 = picked;
                });
            },
            decoration: InputDecoration(
              hintText: selectedDate1 == '' ? '' : selectedDate1.toString(),
              enabledBorder: border,
              focusedBorder: border,
            ),
          ),
        ],
      ),
    );
  }

  Widget custom31TextField(
      String title, String selectedYear, List<DropdownMenuItem<String>> year) {
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
          DropdownButtonFormField(
            isExpanded: true,
            menuMaxHeight: 300,
            value: selectedYear,
            items: year,
            onChanged: (value) {
              setState(() {
                selectedYear = value!;
              });
            },
            decoration: InputDecoration(
              hintText: selectedYear,
              enabledBorder: border,
              focusedBorder: border,
            ),
          ),
        ],
      ),
    );
  }

  // Widget custom32TextField(String title,String selectedYear) {
  //   return Container(
  //     padding: containerEdgeInsetsGeometry,
  //     width: MediaQuery.of(context).size.width / 2,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Padding(
  //           padding: textEdgeInsetsGeometry,
  //           child: Text(
  //             title,
  //             style: textStyle,
  //           ),
  //         ),
  //
  //         DropdownButtonFormField(
  //           isExpanded: true,
  //           menuMaxHeight: 300,
  //           value: selectedYear,
  //           items: years3,
  //           onChanged: (value) {
  //             setState(() {
  //               selectedYear = value!;
  //             });
  //           },
  //           decoration: InputDecoration(
  //             hintText: selectedYear,
  //             enabledBorder: border,
  //             focusedBorder: border,
  //           ),
  //         ),
  //
  //
  //       ],
  //     ),
  //   );
  // }
  // Widget custom33TextField(String title,String selectedYear) {
  //   return Container(
  //     padding: containerEdgeInsetsGeometry,
  //     width: MediaQuery.of(context).size.width / 2,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Padding(
  //           padding: textEdgeInsetsGeometry,
  //           child: Text(
  //             title,
  //             style: textStyle,
  //           ),
  //         ),
  //
  //         DropdownButtonFormField(
  //           isExpanded: true,
  //           menuMaxHeight: 300,
  //           value: selectedYear,
  //           items: years2,
  //           onChanged: (value) {
  //             setState(() {
  //               selectedYear = value!;
  //             });
  //           },
  //           decoration: InputDecoration(
  //             hintText: selectedYear,
  //             enabledBorder: border,
  //             focusedBorder: border,
  //           ),
  //         ),
  //
  //
  //       ],
  //     ),
  //   );
  // }
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

  Future getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      ImageList.imgList.add(image!.path);
    });
  }

  Widget modelField(String title,
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
                    // disabledHint: Text(dropDownValue.toString()),
                    onChanged: enable
                        ? (String? newValue) {
                            setState(() {
                              dropDownValue = newValue ?? "";
                            });
                          }
                        : null,
                  ),
          ),
        ],
      ),
    );
  }

  openCamera() async {
    NavigatorState state = Navigator.of(context);
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    state
        .push(MaterialPageRoute(
            builder: (context) => CaptureScreen(
                  cameras: cameras,
                )))
        .then((value) => setState(() {}));
  }

  fetchSelectList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String response = prefs.getString('selectList').toString();
    responseJson = jsonDecode(response);
    makeMenuItems = createMenuList('MAKE', makeMenuItems, responseJson);
    fuelMenuItems = createMenuList('FUEL', fuelMenuItems, responseJson);
    bodyStyleMenuItems =
        createMenuList('STYLE', bodyStyleMenuItems, responseJson);
    colourMenuItems = createMenuList('COLOUR', colourMenuItems, responseJson);
    setState(() {});
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
