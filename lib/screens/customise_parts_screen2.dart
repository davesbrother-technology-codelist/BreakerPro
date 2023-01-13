import 'package:breaker_pro/screens/postage_dropdown_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:intl/intl.dart';
import '../api/api_config.dart';
import '../app_config.dart';
import '../dataclass/part.dart';
import '../dataclass/parts_list.dart';
import '../my_theme.dart';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'capture_screen.dart';
import 'drop_down_screen.dart';

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
  List<String> partConditionItems = [
    'BRAND NEW',
    'GOOD',
    'PERFECT',
    'POOR',
    'VERY GOOD',
    'WORN'
  ];
  final List<String> postageItems = [
    'Old 24 hrs 6.00 + Collection Only 0.00',
    'Old 24 hrs 0.00 + Collection Only 0.00',
    '2-3 days 0.00 + Collection 0.00 + 24 Hrs 12.00',
    '2-3 days 0.00 + Collection 0.00 + 24 Hrs 18.00',
    '2-3 days 0.00 + Collection 0.00 + 24 Hrs 24.00',
    '2-3 days 0.00 + Collection 0.00 + 24 Hrs 28.00',
    '2-3 days 0.00 + Collection 0.00 + 24 Hrs 36.00',
    '2-3 days 0.00 + Collection 0.00 + 24 Hrs 40.00',
    '2-3 days 0.00 + Collection 0.00 + 24 Hrs 50.00',
    '2-3 days 0.00 + Collection 0.00 + 24 Hrs 6.00',
    '2-3 days 0.00 + Collection 0.00 + 24 Hrs 60.00',
    '2-3 days 0.00 + Collection 0.00 + 24 Hrs 9.60',
    'Old 2-3 days 0.00 + Collection Only 0.00',
    'Old 2-3 days 12.00 + Collection Only 0.00',
    'Old 2-3 days 18.00 + Collection Only 0.00',
    'Old 2-3 days 24.00 + Collection Only 0.00',
    'Old 2-3 days 36.00 + Collection Only 0.00',
    'Old 2-3 days 50.00 + Collection Only 0.00',
    'Old 2-3 days 6.00 + Collection Only 0.00 + Collection Only 0.00',
    'Old 2-3 days 60.00 + Collection Only 0.00',
    'Old 2-3 days 9.60 + Collection Only 0.00',
    'Old 24 hrs 12.00 + Collection Only 0.00',
    'Old 24 hrs 18.00 + Collection Only 0.00',
    'Old 24 hrs 36.00 + Collection Only 0.00',
    'Old 24 hrs 9.60 + Collection Only 0.00',
    'Old Collection Only 0.00'
  ];
  late List<bool> postageSelected =
      List.generate(postageItems.length, (index) => false);
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
  TextEditingController partConditionController = TextEditingController();
  TextEditingController postageOptionsController = TextEditingController();

  @override
  void initState() {
    part = widget.part;
    super.initState();
    ebayTitleEditingController.text =
        "${PartsList.uploadVehicle!.ebayMake} ${PartsList.uploadVehicle!.ebayModel} ${part.partName}";
    formattedDate = '';
    partConditionController.text = part.partCondition;
    // partLocEditingController.text = part.defaultLocation;
    // warrantyEditingController.text = part.warranty.toString();
    // salesPriceEditingController.text = part.salesPrice.toString();
    qtyEditingController.text = part.qty.toString();
    // partDescEditingController.text = part.defaultDescription;
    mnfPartNoEditingController.text = part.mnfPartNo;
    partCommentsEditingController.text = part.comments;
    postageOptionsController.text = part.postageOptions;

    ImageList.partImageList = part.imgList;
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
            onPressed: () async {
              if (partLocEditingController.text.isNotEmpty ||
                  warrantyEditingController.text.isNotEmpty ||
                  salesPriceEditingController.text.isNotEmpty ||
                  costPriceEditingController.text.isNotEmpty ||
                  partDescEditingController.text.isNotEmpty ||
                  mnfPartNoEditingController.text.isNotEmpty ||
                  partCommentsEditingController.text.isNotEmpty ||
                  formattedDate != "" ||
                  partConditionController.text.isNotEmpty ||
                  postageOptionsController.text.isNotEmpty) {
                part.forUpload = true;
              }

              part.partCondition = partConditionController.text.toString();
              part.defaultLocation = partLocEditingController.text.toString();
              try {
                part.warranty = double.parse(warrantyEditingController.text);
                part.salesPrice =
                    double.parse(salesPriceEditingController.text);
                part.costPrice = double.parse(costPriceEditingController.text);
                part.qty = int.parse(qtyEditingController.text);
                part.mnfPartNo = mnfPartNoEditingController.text.toString();
              } catch (e) {
                print("Failed to convert");
              }

              part.defaultDescription =
                  partDescEditingController.text.toString();

              part.comments = partCommentsEditingController.text.toString();
              part.postageOptions = postageOptionsController.text.toString();
              part.ebayTitle = ebayTitleEditingController.text.toString();
              part.imgList = List.from(ImageList.partImageList);
              print(part.imgList);
              await FlutterLogs.initLogs(
                  logLevelsEnabled: [
                    LogLevel.INFO,
                    LogLevel.WARNING,
                    LogLevel.ERROR,
                    LogLevel.SEVERE
                  ],
                  timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
                  directoryStructure: DirectoryStructure.SINGLE_FILE_FOR_DAY,
                  logTypesEnabled: [
                    "UPLOAD__${DateFormat("ddMMyy").format(DateTime.now())}",
                    "LOGGER${DateFormat("ddMMyy").format(DateTime.now())}",
                    "${ApiConfig.baseQueryParams['username']}_${DateFormat("ddMMyy").format(DateTime.now())}"
                  ],
                  logFileExtension: LogFileExtension.TXT,
                  logsWriteDirectoryName: "MyLogs",
                  logsExportDirectoryName: "MyLogs/Exported",
                  logsExportZipFileName:
                      "Logger${DateFormat('dd_MM_YYYY').format(DateTime.now())}",
                  debugFileOperations: true,
                  isDebuggable: true);

              String msg =
                  "\n\n\n\n**************** Inserting Part Details clicked ${DateFormat("hh:mm:ss yyyy/MM/dd").format(DateTime.now())} **************** \n\n";
              msg += part.addLog();
              FlutterLogs.logToFile(
                  logFileName:
                      "${ApiConfig.baseQueryParams['username']}_${DateFormat("ddMMyy").format(DateTime.now())}",
                  overwrite: false,
                  logMessage: msg);
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
                    // customTextField("Part Condition", partConditionValue)
                    customDropDownField("Part Condition", partConditionItems,
                        partConditionController)
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
                // customTextField("Postage Option", postageOptionsValue),
                customDropDownField(
                    "Postage Option", postageItems, postageOptionsController),
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
                )
              ],
            ),
          ),
        ),
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
