import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app_config.dart';
import '../dataclass/part.dart';
import '../my_theme.dart';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'capture_screen.dart';

class Customise extends StatefulWidget {
  const Customise({Key? key, required this.part}) : super(key: key);
  final Part part;

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
  List<String> partConditionList = [
    'BRAND NEW',
    'GOOD',
    'PERFECT',
    'POOR',
    'VERY GOOD',
    'WORN'
  ];
  List<DropdownMenuItem<String>> partConditionDropDownItems = [];
  late Part part;
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  DateTime? selectedDate;
  String formattedDate = '';
  List<File> images = [];

  TextEditingController partLocEditingController =
      TextEditingController(text: "");
  TextEditingController warrantyEditingController = TextEditingController();
  TextEditingController salesPriceEditingController = TextEditingController();
  TextEditingController costPriceEditingController = TextEditingController();
  TextEditingController qtyEditingController = TextEditingController(text: "1");
  TextEditingController partDescEditingController = TextEditingController();
  TextEditingController mnfPartNoEditingController = TextEditingController();
  TextEditingController partCommentsEditingController = TextEditingController();
  TextEditingController ebayTitleEditingController = TextEditingController();

  String? partConditionValue;
  String? postageOptionsValue;

  @override
  void initState() {
    part = widget.part;
    super.initState();
    ebayTitleEditingController.text = part.ebayTitle;
    for (String item in partConditionList) {
      partConditionDropDownItems.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }
    formattedDate = '';
  }

  @override
  void dispose() {
    ImageList.partImageList.clear();
    super.dispose();
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
              if (partLocEditingController.text.isNotEmpty ||
                  warrantyEditingController.text.isNotEmpty ||
                  salesPriceEditingController.text.isNotEmpty ||
                  costPriceEditingController.text.isNotEmpty ||
                  partDescEditingController.text.isNotEmpty ||
                  mnfPartNoEditingController.text.isNotEmpty ||
                  partCommentsEditingController.text.isNotEmpty ||
                  formattedDate != "" ||
                  partConditionValue != null ||
                  postageOptionsValue != null) {
                part.isSelected = true;
              }

              part.partCondition = partConditionValue.toString();
              part.defaultLocation = partLocEditingController.text.toString();
              try {
                part.warranty = double.parse(warrantyEditingController.text);
                part.salesPrice =
                    double.parse(salesPriceEditingController.text);
                part.costPrice = double.parse(costPriceEditingController.text);
                part.qty = int.parse(qtyEditingController.text);
                part.mnfPartNo = int.parse(mnfPartNoEditingController.text);
              } catch (e) {
                print("Failed to convert");
              }

              part.defaultDescription =
                  partDescEditingController.text.toString();

              part.comments = partCommentsEditingController.text.toString();
              part.postageOptions = postageOptionsValue.toString();
              part.ebayTitle = ebayTitleEditingController.text.toString();
              part.imgList = ImageList.partImageList;
              Navigator.pop(context, part);
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
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    part.partName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    customTextField("Part Condition", partConditionValue)
                  ],
                ),
                Row(
                  children: [
                    custom2TextField("Part Location", 3 / 4, TextInputType.text,
                        partLocEditingController),
                    custom2TextField("Warranty", 1 / 4, TextInputType.number,
                        warrantyEditingController)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Quantity In Stock',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    custom2TextField("Sales Price", 2 / 5, TextInputType.number,
                        salesPriceEditingController),
                    custom2TextField("Cost Price", 2 / 5, TextInputType.number,
                        costPriceEditingController),
                    custom2TextField("Qty", 1 / 5, TextInputType.number,
                        qtyEditingController)
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
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
                custom2TextField("Part Description", 1, TextInputType.text,
                    partDescEditingController),
                custom2TextField("Manufacturer Part no", 1, TextInputType.text,
                    mnfPartNoEditingController),
                custom2TextField("Part Comments", 1, TextInputType.text,
                    partCommentsEditingController),
                customTextField("Postage Option", postageOptionsValue),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
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
                custom2TextField("Ebay Title", 1, TextInputType.text,
                    ebayTitleEditingController),
                Row(
                  children: [
                    Checkbox(
                        value: isChecked3,
                        onChanged: (value) {
                          setState(() {
                            isChecked3 = value!;
                          });
                        }),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
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
                            if (picked != null && picked != selectedDate) {
                              setState(() {
                                selectedDate = picked;
                                formattedDate =
                                    DateFormat('dd/MM/yyyy').format(picked);
                              });
                            }
                          },
                          readOnly: true,
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
                              var image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);

                              setState(() {
                                // images= pickedGallery.map((e) => File(e.path)).toList();
                                print(image?.path);
                                ImageList.partImageList.add(image!.path);
                              });
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextField(String title, String? selectedItem) {
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
            items: partConditionDropDownItems,
            onChanged: (value) {
              setState(() {
                selectedItem = value;
                switch (title) {
                  case 'Part Condition':
                    {
                      partConditionValue = value;
                    }
                    break;
                  case 'Postage Option':
                    {
                      postageOptionsValue = value;
                    }
                    break;
                }
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

  Widget custom2TextField(String title, double n, TextInputType TType,
      TextEditingController? controller) {
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
                minLines: title == 'Part Description' ||
                        title == 'Part Comments' ||
                        title == 'Ebay Title'
                    ? 3
                    : 1,
                maxLines: title == 'Part Description' ||
                        title == 'Part Comments' ||
                        title == 'Ebay Title'
                    ? 5
                    : 1,
                controller: controller,
                keyboardType: TType,
                decoration: InputDecoration(
                    enabledBorder: border, focusedBorder: border))
          ]),
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
