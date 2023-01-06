import 'package:breaker_pro/screens/customise_parts_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../my_theme.dart';
import 'package:breaker_pro/dataclass/image_list.dart';
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

class Customise extends StatefulWidget {
  const Customise({Key? key}) : super(key: key);

  @override
  State<Customise> createState() => _CustomiseState();
}

class _CustomiseState extends State<Customise> {
  EdgeInsetsGeometry textEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(0, 10, 10, 10);
  EdgeInsetsGeometry containerEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(10, 5, 10, 5);
  TextStyle textStyle = TextStyle(fontSize: 12, color: MyTheme.grey);
  OutlineInputBorder border =
      OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.grey));
  String? selectedItem;
  List<String> items = [
    'BRAND NEW',
    'GOOD',
    'PERFECT',
    'POOR',
    'VERY GOOD',
    'WORN'
  ];
  List<DropdownMenuItem<String>> dropdownItems = [];
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  DateTime? selectedDate;
  String formattedDate = '';
  List<File> images = [];
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    for (String item in items) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(item),
        value: item,
      ));
    }
    formattedDate = '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          color: MyTheme.materialColor,
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: MyTheme.white),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: MyTheme.materialColor,
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
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "ABS SENSOR (REAR DRIVER SIDE)",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [customTextField("Part Condition")],
                ),
                Row(
                  children: [
                    custom2TextField(
                        "Part Location", 3 / 4, TextInputType.text),
                    custom2TextField("Warranty", 1 / 4, TextInputType.number)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Quantity In Stock',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    custom2TextField(
                        "Sales Price", 2 / 5, TextInputType.number),
                    custom2TextField("Cost Price", 2 / 5, TextInputType.number),
                    custom2TextField("Qty", 1 / 5, TextInputType.number)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(
                        value: isChecked1,
                        onChanged: (value) {
                          setState(() {
                            isChecked1 = value!;
                          });
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Set Defaults",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    )
                  ],
                ),
                custom2TextField("Part Description", 1, TextInputType.text),
                custom2TextField("Manufacturer Part no", 1, TextInputType.text),
                custom2TextField("Part Comments", 1, TextInputType.text),
                customTextField("Postage Option"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Marketing',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        value: isChecked2,
                        onChanged: (value) {
                          setState(() {
                            isChecked2 = value!;
                          });
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Ebay",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    )
                  ],
                ),
                custom2TextField("Ebay Title", 1, TextInputType.text),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Featured Web",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: TextField(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(1980),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null && picked != selectedDate)
                              setState(() {
                                selectedDate = picked;
                                formattedDate =
                                    DateFormat('dd/MM/yyyy').format(picked);
                              });
                          },
                          decoration: InputDecoration(
                              hintText:
                                  formattedDate == '' ? '' : formattedDate,
                              enabledBorder: border,
                              focusedBorder: border),
                        )),
                      ),
                    )
                  ],
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
                          : SizedBox(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextField(String title) {
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
            value: selectedItem,
            items: dropdownItems,
            onChanged: (value) {
              setState(() {
                selectedItem = value;
              });
            },
            decoration: InputDecoration(
                hintText: selectedItem,
                enabledBorder: border,
                focusedBorder: border),
          ),
        ],
      ),
    );
  }

  Widget custom2TextField(String title, double n, TextInputType TType) {
    return Container(
      padding: containerEdgeInsetsGeometry,
      width: (MediaQuery.of(context).size.width) * n,
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
                keyboardType: TType,
                decoration: InputDecoration(
                    enabledBorder: border, focusedBorder: border))
          ]),
    );
  }

  openCamera() async {
    NavigatorState state = Navigator.of(context);
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    state
        .push(MaterialPageRoute(
            builder: (context) => CaptureScreen(
                  camera: firstCamera,
                )))
        .then((value) => setState(() {}));
  }
}
