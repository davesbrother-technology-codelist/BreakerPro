import 'dart:convert';

import 'package:breaker_pro/api/manage_part_repository.dart';
import 'package:breaker_pro/screens/postage_dropdown_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';
import '../api/api_config.dart';
import '../app_config.dart';
import '../dataclass/part.dart';
import '../dataclass/parts_list.dart';
import '../dataclass/stock.dart';
import '../my_theme.dart';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'capture_screen.dart';
import 'drop_down_screen.dart';
import 'package:path/path.dart' as path;

class ManageParts2 extends StatefulWidget {
  const ManageParts2({Key? key, required this.part, required this.stock})
      : super(key: key);
  final Part part;
  final Stock stock;

  @override
  State<ManageParts2> createState() => _ManageParts2State();
}

class _ManageParts2State extends State<ManageParts2> {
  EdgeInsetsGeometry textEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(0, 10, 10, 10);
  EdgeInsetsGeometry containerEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(10, 5, 10, 5);
  TextStyle textStyle = TextStyle(fontSize: 12, color: MyTheme.grey);
  OutlineInputBorder border =
      OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.grey));
  OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: MyTheme.materialColor));
  OutlineInputBorder ebayBorder =
      OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.red));
  List<String> partConditionItems = AppConfig.partConditionList;
  final List<String> postageItems = AppConfig.postageOptionsList;
  List<String> fuelItems = AppConfig.fuelItems;
  late List<bool> postageSelected =
      List.generate(postageItems.length, (index) => false);

  late List onLineImageList;
  late Part part;
  late Stock stock;
  bool isDefault = false;
  bool isEbay = false;
  bool hasPrintLabel = false;
  List<File> images = [];

  TextEditingController partLocEditingController =
      TextEditingController(text: "");
  TextEditingController warrantyEditingController = TextEditingController();
  TextEditingController salesPriceEditingController = TextEditingController();
  TextEditingController costPriceEditingController = TextEditingController();
  TextEditingController qtyEditingController = TextEditingController();
  TextEditingController partDescEditingController = TextEditingController();
  TextEditingController mnfPartNoEditingController = TextEditingController();
  TextEditingController partCommentsEditingController = TextEditingController();
  TextEditingController ebayTitleEditingController = TextEditingController();
  TextEditingController partConditionController = TextEditingController();
  TextEditingController postageOptionsController = TextEditingController();
  TextEditingController fuelController = TextEditingController();

  @override
  void initState() {
    addLog();
    part = widget.part;
    stock = widget.stock;
    super.initState();
    ebayTitleEditingController.text = part.ebayTitle;
    partConditionController.text = part.partCondition;
    partLocEditingController.text = part.partLocation;
    warrantyEditingController.text = part.warranty.toInt().toString();
    salesPriceEditingController.text = part.salesPrice.toInt().toString();
    qtyEditingController.text = part.qty == -1 ? "1" : part.qty.toString();
    partDescEditingController.text = part.description;
    mnfPartNoEditingController.text = part.mnfPartNo;
    partCommentsEditingController.text = part.comments;
    postageOptionsController.text = part.postageOptions;
    fuelController.text = stock.fuel;
    isEbay = part.isEbay;
    if (stock.imageThumbnailURLList.isNotEmpty) {
      ImageList.managePartImageList = stock.imageThumbnailURLList.split(',');
    }

    print(ImageList.managePartImageList.isEmpty);

    for (int i = 0; i < postageItems.length; i++) {
      if (part.postageOptions.contains(postageItems[i])) {
        postageSelected[i] = true;
        postageOptionsController.text += "${postageItems[i]},";
      }
      List l = part.postageOptionsCode.split(',');
      for (var code in l) {
        if (postageItems[i] == AppConfig.postageOptionsMap[code]) {
          print(AppConfig.postageOptionsMap[code]);
          if (!postageOptionsController.text.contains(postageItems[i])) {
            postageOptionsController.text += "${postageItems[i]},";
          }
          postageSelected[i] = true;
        }
      }
    }
  }

  @override
  void dispose() {
    ImageList.managePartImageList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Center(
                child: Text(
                  part.partName,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "${stock.make} ${stock.model}",
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: const [
            //     Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Text(
            //         'Quantity In Stock',
            //         style: TextStyle(color: Colors.grey, fontSize: 20),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                custom2TextField("Sales Price", 2 / 5, TextInputType.number,
                    salesPriceEditingController),
                custom2TextField("Cost Price", 2 / 5, TextInputType.number,
                    costPriceEditingController),
                custom2TextField(
                    "Qty", 1 / 5, TextInputType.number, qtyEditingController)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Checkbox(
                    activeColor: MyTheme.materialColor,
                    value: isDefault,
                    onChanged: (value) {
                      setState(() {
                        isDefault = value!;
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
            customDropDownField("Fuel", fuelItems, fuelController),
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
                    activeColor: MyTheme.materialColor,
                    value: isEbay,
                    onChanged: (value) {
                      setState(() {
                        isEbay = value!;
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
                ),
                stock.ebayNumber.isNotEmpty
                    ? Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () async {
                                await launchUrl(
                                    Uri.parse(
                                        "https://www.ebay.com/itm/${stock.ebayNumber}"),
                                    mode: LaunchMode.externalApplication);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.arrowUpRightFromSquare,
                                    size: 18,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Text(
                                      stock.ebayNumber,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
            custom2TextField("Ebay Title", 1, TextInputType.text,
                ebayTitleEditingController),
            Row(
              children: [
                Checkbox(
                    activeColor: MyTheme.materialColor,
                    value: hasPrintLabel,
                    onChanged: (value) async {
                      hasPrintLabel = value!;
                      setState(() {});
                    }),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Text(
                    "Print Label",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              height: ImageList.managePartImageList.isNotEmpty ? 210 : 80,
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
                          style: TextStyle(color: MyTheme.black, fontSize: 20),
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
                            style:
                                TextStyle(color: MyTheme.black, fontSize: 20)),
                        onPressed: () async {
                          // List<XFile> pickedGallery= (await _picker.pickMultiImage());
                          final ImagePicker imagePicker = ImagePicker();
                          List<XFile> imageFileList = [];
                          List<XFile>? selectedImages =
                              await imagePicker.pickMultiImage();
                          if (selectedImages.isNotEmpty) {
                            imageFileList.addAll(selectedImages);
                          }
                          setState(() {
                            List<String> l = List.generate(imageFileList.length,
                                (index) => imageFileList[index].path);
                            // for (XFile image in imageFileList) {
                            //   File imgFile = File(image.path);
                            //   String dir = path.dirname(imgFile.path);
                            //   int count = PartsList.partCount;
                            //   String newPath = path.join(dir,
                            //       'IMGPRT${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${count.toString().padLeft(4, '0')}$count${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
                            //   imgFile = imgFile.renameSync(newPath);
                            ImageList.managePartImageList.addAll(l);
                            // }
                          });
                          for (String img in ImageList.managePartImageList) {
                            print(img);
                          }
                        },
                      ),
                    ],
                  ),
                  ImageList.managePartImageList.isNotEmpty
                      ? Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: 140,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: ImageList.managePartImageList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AspectRatio(
                                          aspectRatio: AppConfig.aspectMap[
                                              AppConfig.imageAspectRatio],
                                          child: SizedBox(
                                            child: ImageList
                                                    .managePartImageList[index]
                                                    .contains('http')
                                                ? Image.network(
                                                    ImageList
                                                            .managePartImageList[
                                                        index],
                                                    fit: BoxFit.fill,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return const SizedBox();
                                                    },
                                                  )
                                                : Image.file(
                                                    File(ImageList
                                                            .managePartImageList[
                                                        index]),
                                                    fit: BoxFit.fill,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -15,
                                        right: -15,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.cancel,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                ImageList.managePartImageList
                                                    .removeAt(index);
                                                // part.imgList.removeAt(index);
                                              });
                                            },
                                          ),
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
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10.0, 15, 10),
                    child: Container(
                      color: MyTheme.materialColor,
                      child: TextButton(
                        onPressed: () {
                          openDeleteDialog(context);
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(color: MyTheme.red, fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 5, 10),
                    child: Container(
                      color: MyTheme.grey,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Re-Search",
                          style: TextStyle(color: MyTheme.white, fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5.0, 15, 10),
                    child: Container(
                      color: MyTheme.materialColor,
                      child: TextButton(
                        onPressed: () {
                          upload();
                        },
                        child: Text(
                          "Upload",
                          style: TextStyle(color: MyTheme.white, fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  openDeleteDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget logoutButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        part.isDelete = true;
        upload();
      },
      child: const Text("YES"),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Are you sure you want to delete stock?"),
      actions: [
        cancelButton,
        logoutButton,
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
                onChanged: (String s) {
                  if (title == 'Ebay Title') {
                    setState(() {});
                  }
                },
                onSubmitted: (String? s) {
                  if (title == 'Manufacturer Part no' && s != null) {
                    setState(() {
                      // mnfPartNoEditingController.text = "";
                      ebayTitleEditingController.text += s;
                    });
                  }
                },
                keyboardType: TType,
                decoration: InputDecoration(
                    enabledBorder: title == 'Ebay Title' &&
                            ebayTitleEditingController.text.length >= 80
                        ? ebayBorder
                        : border,
                    focusedBorder: title == 'Ebay Title' &&
                            ebayTitleEditingController.text.length >= 80
                        ? ebayBorder
                        : focusedBorder))
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
                  type: "ManagePart",
                )))
        .then((value) => setState(() {}));
  }

  upload() async {
    part.partCondition = partConditionController.text.toString();
    part.partLocation = isDefault
        ? part.defaultLocation
        : partLocEditingController.text.toString();
    try {
      part.warranty = double.parse(warrantyEditingController.text);
      part.salesPrice = double.parse(salesPriceEditingController.text);
      part.costPrice = double.parse(costPriceEditingController.text);
      part.qty = int.parse(qtyEditingController.text);
    } catch (e) {
      print("Failed to convert");
    }
    part.mnfPartNo = mnfPartNoEditingController.text.toString();
    part.description = isDefault
        ? part.defaultDescription
        : partDescEditingController.text.toString();

    part.comments = partCommentsEditingController.text.toString();
    part.postageOptions = postageOptionsController.text.toString();
    part.ebayTitle = isEbay ? ebayTitleEditingController.text.toString() : "";
    for (String img in ImageList.managePartImageList) {
      if (!img.contains('http')) {
        part.imgList.add(img);
      }
    }
    part.isEbay = isEbay;
    part.hasPrintLabel = hasPrintLabel;
    part.isDefault = isDefault;
    // String msg =
    //     "\n\n\n\n**************** Inserting Part Details clicked ${DateFormat("hh:mm:ss yyyy/MM/dd").format(DateTime.now())} **************** \n\n";
    // msg += part.addLog();
    // final File file = File(
    //     '${AppConfig.externalDirectory!.path}/${ApiConfig.baseQueryParams['username']}_${DateFormat("ddMMyy").format(DateTime.now())}.txt');
    // await file.writeAsString(msg, mode: FileMode.append);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getStringList('uploadManagePartQueue') == null){
      await prefs.setStringList('uploadManagePartQueue', [part.partId]);
    }
    else{
      List<String> l = prefs.getStringList('uploadManagePartQueue')!;
      l.add(part.partId);
      await prefs.setStringList('uploadManagePartQueue', l);
    }
    await prefs.setString(part.partId, jsonEncode(stock.toJson()));
    Box<Part> box = await Hive.openBox('manageParts');
    await box.put(part.partId, part);
    await box.close();
    ManagePartRepository.uploadPart(part, stock);
    Navigator.pop(context, {"part": part, "stock": stock});
  }

  Future<void> addLog() async {
    final File file = File(
        '${AppConfig.externalDirectory!.path}/UPLOAD_MANAGE_PARTS${DateFormat("ddMMyy").format(DateTime.now())}.txt');
    await file.writeAsString(
        "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())}: Manage Part Details Screen ${widget.part.partName}, ${widget.stock.stockID}\n",
        mode: FileMode.append);
  }
}
