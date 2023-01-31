import 'package:breaker_pro/screens/postage_dropdown_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app_config.dart';
import '../my_theme.dart';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:intl/intl.dart';
import 'drop_down_screen.dart';

import 'package:breaker_pro/screens/make.dart';
import 'package:image_picker/image_picker.dart';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:breaker_pro/screens/allocate_parts_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dataclass/parts_list.dart';
import '../my_theme.dart';
import 'capture_screen.dart';
import 'package:breaker_pro/screens/main_dashboard.dart';
import 'package:path/path.dart' as path;


class ManageParts2 extends StatefulWidget {
  const ManageParts2({Key? key}) : super(key: key);

  @override
  State<ManageParts2> createState() => _ManageParts2State();
}

class _ManageParts2State extends State<ManageParts2> {
  final List<String> postageItems = AppConfig.postageOptionsList;
  late List<bool> postageSelected =
  List.generate(postageItems.length, (index) => false);
  EdgeInsetsGeometry textEdgeInsetsGeometry =
  const EdgeInsets.fromLTRB(0, 10, 10, 10);
  EdgeInsetsGeometry containerEdgeInsetsGeometry =
  const EdgeInsets.fromLTRB(10, 5, 10, 5);
  TextStyle textStyle = TextStyle(fontSize: 12, color: MyTheme.grey);
  OutlineInputBorder border =
  OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.grey));
  String? selectedItem;
  TextEditingController partConditionController = TextEditingController();
  TextEditingController fuelController = TextEditingController();
  List<String> fuelItems=['Diesel','LPG','Petrol'];

  List<String> partConditionItems = [
    'BRAND NEW',
    'GOOD',
    'PERFECT',
    'POOR',
    'VERY GOOD',
    'WORN'
  ];
  TextEditingController postageOptionsController = TextEditingController();

  List<DropdownMenuItem<String>> dropdownItems = [];
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  DateTime? selectedDate;
  String formattedDate = '';
  List<File> images = [];
  @override
  void initState() {
    super.initState();
    for (String item in partConditionItems) {
      dropdownItems.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }
    formattedDate = '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyTheme.materialColor,
          title: Text(
            'Manage Part',
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                'Breaking For Spares',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8,top: 8,bottom: 8,right: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "LAND ROVER RANGE ROVER SPORT HSE SILVER E6 6 DOHC",
                      style: TextStyle(
                          fontSize: 16,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      customDropDownField("Part Condition", partConditionItems,
                          partConditionController)
                    ],
                  ),
                  Row(
                    children: [
                      custom2TextField(
                          "Part Location", 3 / 4, TextInputType.text),
                      custom2TextField("Warranty", 1 / 4, TextInputType.number)
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
                        activeColor: MyTheme.materialColor,
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
                  // customTextField("Postage Option"),
                  customDropDownField(
                      "Postage Option", postageItems, postageOptionsController),
                  customDropDownField('Fuel', fuelItems, fuelController),
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
                        activeColor: MyTheme.materialColor,
                          value: isChecked2,
                          onChanged: (value) {
                            setState(() {
                              isChecked2 = value!;
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Image.asset("assets/ebay.png",scale: 12,)
                      )
                    ],
                  ),
                  custom2TextField("Ebay Title", 1, TextInputType.text),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        activeColor: MyTheme.materialColor,
                          value: isChecked3,
                          onChanged: (value) {
                            setState(() {
                              isChecked3 = value!;
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Print Label",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: ImageList.partImageList.isNotEmpty ? 210 : 80,
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
                                XFile? image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);

                                if (image != null) {
                                  File imgFile = File(image.path);
                                  print(imgFile.path);
                                  String dir = path.dirname(imgFile.path);
                                  setState(() {
                                    int count = PartsList.partCount;
                                    String newPath = path.join(dir,
                                        'IMGPRT${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${count.toString().padLeft(4, '0')}$count${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
                                    imgFile = imgFile.renameSync(newPath);
                                    ImageList.partImageList.add(imgFile.path);
                                  });
                                }
                                for (String img in ImageList.partImageList) {
                                  print(img);
                                }
                              },
                            ),
                          ],
                        ),
                        ImageList.partImageList.isNotEmpty
                            ? Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: 140,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: ImageList.partImageList.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AspectRatio(
                                          aspectRatio: AppConfig.aspectMap[
                                          AppConfig.imageAspectRatio],
                                          child: SizedBox(
                                            width: 9,
                                            height: 16,
                                            child: Image.file(File(ImageList
                                                .partImageList[index])),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -5,
                                        right: -13,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.black
                                                .withOpacity(0.7),
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              ImageList.partImageList
                                                  .removeAt(index);
                                              // part.imgList.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        )
                            : const SizedBox()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(

                          width: MediaQuery.of(context).size.width*0.6,
                          color: MyTheme.materialColor,
                          child: TextButton(
                            onPressed: (){},
                            child: Text('Delete',style: TextStyle(color: Colors.red),),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(

                          width: MediaQuery.of(context).size.width*0.3,
                          color: MyTheme.grey,
                          child: TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text('Re-Search',style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(

                          width: MediaQuery.of(context).size.width*0.6,
                          color: MyTheme.materialColor,
                          child: TextButton(
                            onPressed: (){},
                            child: Text('Upload',style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),

                    ],
                  )
                ],
                ),
              ),
            ),

          ],
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
  Widget customDropDownField(
      String title, List<String> menuItems, TextEditingController controller) {
    return Container(
      padding: containerEdgeInsetsGeometry,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: textEdgeInsetsGeometry,
            child: Text(
              title,
              style: textStyle,
            ),
          ),
          SizedBox(
              child: TextField(
                readOnly: true,
                onTap: () async {
                  if (title == "Postage Option") {
                    await Navigator.of(context)
                        .push(createRoute(PostageDropDownScreen(
                      dropDownItems: menuItems,
                      title: title,
                      selectedItems: postageSelected,
                    )))
                        .then((value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        String a = "";
                        value = value as List;
                        for (int i = 0; i < value.length; i++) {
                          if (value[i]) {
                            a += "${postageItems[i]} ,";
                          }
                        }
                        controller.text = a;
                      });
                    });
                  } else {
                    await Navigator.of(context)
                        .push(createRoute(
                        DropDownScreen(dropDownItems: menuItems, title: title)))
                        .then((value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        controller.text = value['value'];
                      });
                    });
                  }
                },
                decoration: InputDecoration(
                    enabledBorder: border,
                    focusedBorder: border,
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: MyTheme.grey,
                    )),
                controller: controller,
                maxLines: null,
              )),
        ],
      ),
    );
  }
  Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  openCamera() async {
    NavigatorState state = Navigator.of(context);
    final cameras = await availableCameras();
    state
        .push(MaterialPageRoute(
        builder: (context) => CaptureScreen(
          cameras: cameras,
          type: "Part",
        )))
        .then((value) => setState(() {}));
  }
}