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
import 'package:path/path.dart' as path;

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
  OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: MyTheme.materialColor));
  OutlineInputBorder redBorder =
      OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.red));
  List<String> partConditionItems = AppConfig.partConditionList;
  final List<String> postageItems = AppConfig.postageOptionsList;
  late List<bool> postageSelected =
      List.generate(postageItems.length, (index) => false);
  late Part part;
  bool isDefault = false;
  bool isEbay = false;
  bool isFeaturedWeb = false;
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
  TextEditingController ebayTitleEditingController =
      TextEditingController(text: "");
  TextEditingController partConditionController = TextEditingController();
  TextEditingController postageOptionsController = TextEditingController();

  @override
  void initState() {
    part = widget.part;
    if (part.ebayTitle.contains('[')) {
      print(part.ebayTitle);
      ebayTitleEditingController.text = part.generateEbayTitle(part.ebayTitle);
    } else {
      ebayTitleEditingController.text = part.ebayTitle;
    }

    super.initState();
    // ebayTitleEditingController.text =
    // part.ebayTitle.isEmpty ?
    //     "${PartsList.cachedVehicle!.ebayMake} ${PartsList.cachedVehicle!.ebayModel} ${part.partName} ${part.mnfPartNo}" : part.ebayTitle;
    formattedDate = '';
    partConditionController.text = part.partCondition;
    partLocEditingController.text = part.partLocation;
    warrantyEditingController.text = part.warranty.toInt().toString();
    salesPriceEditingController.text = part.salesPrice.toInt().toString();
    qtyEditingController.text = part.qty == -1 ? "1" : part.qty.toString();
    partDescEditingController.text = part.description;
    mnfPartNoEditingController.text = part.mnfPartNo;
    partCommentsEditingController.text = part.comments;
    postageOptionsController.text = part.postageOptions;
    ImageList.partImageList = List.from(part.imgList);
    isDefault = part.isDefault;
    isEbay = part.isEbay;
    isFeaturedWeb = part.isFeaturedWeb;

    for (int i = 0; i < postageItems.length; i++) {
      if (part.postageOptions.contains(postageItems[i])) {
        postageSelected[i] = true;
      }
      List l = part.postageOptionsCode.split(',');
      for (var code in l) {
        if (postageItems[i] == AppConfig.postageOptionsMap[code]) {
          print(AppConfig.postageOptionsMap[code]);
          postageSelected[i] = true;
        }
      }
    }
  }

  @override
  void dispose() {
    ImageList.partImageList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyTheme.materialColor,
          title: Text(
            'Customise Parts',
            style: TextStyle(color: MyTheme.white),
          ),
          bottom: PartNameBar(
            partName: part.partName,
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
                  custom2TextField(
                      "Warranty",
                      1 / 4,
                      TextInputType.numberWithOptions(decimal: true),
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
                  custom2TextField(
                      "Sales Price",
                      2 / 5,
                      TextInputType.numberWithOptions(decimal: true),
                      salesPriceEditingController),
                  custom2TextField(
                      "Cost Price",
                      2 / 5,
                      TextInputType.numberWithOptions(decimal: true),
                      costPriceEditingController),
                  custom2TextField(
                      "Qty",
                      1 / 5,
                      TextInputType.numberWithOptions(decimal: true),
                      qtyEditingController)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Checkbox(
                      value: isDefault,
                      activeColor: MyTheme.materialColor,
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
                      value: isEbay,
                      activeColor: MyTheme.materialColor,
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
                  )
                ],
              ),
              custom2TextField("Ebay Title", 1, TextInputType.text,
                  ebayTitleEditingController),
              Row(
                children: [
                  Checkbox(
                      value: isFeaturedWeb,
                      activeColor: MyTheme.materialColor,
                      onChanged: (value) async {
                        isFeaturedWeb = value!;
                        if (isFeaturedWeb) {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(1980),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                              formattedDate =
                                  DateFormat('dd/MM/yyyy').format(picked);
                            });
                          } else {
                            isFeaturedWeb = !isFeaturedWeb;
                          }
                        } else {
                          formattedDate = "";
                        }
                        setState(() {});
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
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: formattedDate == '' ? '' : formattedDate,
                            enabledBorder: border,
                            focusedBorder: focusedBorder),
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
                            final ImagePicker imagePicker = ImagePicker();
                            List<XFile> imageFileList = [];
                            List<XFile>? selectedImages =
                                await imagePicker.pickMultiImage();
                            if (selectedImages.isNotEmpty) {
                              imageFileList.addAll(selectedImages);
                            }
                            setState(() {
                              List<String> l = List.generate(
                                  imageFileList.length,
                                  (index) => imageFileList[index].path);
                              // int i = 1;
                              // for(XFile image in imageFileList){
                              //   File imgFile = File(image.path);
                              //   String dir = path.dirname(imgFile.path);
                              //   int count = PartsList.partCount;
                              //   String newPath = path.join(dir,
                              //       'IMGPRT${DateFormat('yyyyMMddHHmmss').format(DateTime.now().add(Duration(seconds: i)))}${count.toString().padLeft(4, '0')}$count${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
                              //   imgFile = imgFile.renameSync(newPath);
                              ImageList.partImageList.addAll(l);
                              //   i += 1;
                              // }
                            });
                            // XFile? image = await ImagePicker()
                            //     .pickImage(source: ImageSource.gallery);
                            //
                            // if (image != null) {
                            //   File imgFile = File(image.path);
                            //   print(imgFile.path);
                            //   String dir = path.dirname(imgFile.path);
                            //   setState(() {
                            //     int count = PartsList.partCount;
                            //     String newPath = path.join(dir,
                            //         'IMGPRT${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${count.toString().padLeft(4, '0')}$count${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
                            //     imgFile = imgFile.renameSync(newPath);
                            //     ImageList.partImageList.add(imgFile.path);
                            //   });
                            // }
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
                                              child: Image.file(
                                                File(ImageList
                                                    .partImageList[index]),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: -15,
                                          right: -15,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.cancel,
                                              color:
                                                  Colors.black.withOpacity(0.7),
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
              const SizedBox(
                height: 25,
              ),
              Container(
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

                    part.partCondition =
                        partConditionController.text.toString();
                    part.partLocation =
                        partLocEditingController.text.toString();
                    try {
                      part.warranty =
                          double.parse(warrantyEditingController.text);
                      part.salesPrice =
                          double.parse(salesPriceEditingController.text);
                      part.costPrice =
                          double.parse(costPriceEditingController.text);
                      part.qty = int.parse(qtyEditingController.text);
                    } catch (e) {
                      print("Failed to convert");
                    }
                    part.mnfPartNo = mnfPartNoEditingController.text.toString();
                    print(part.mnfPartNo);
                    part.description =
                        partDescEditingController.text.toString();

                    part.featuredWebDate = formattedDate;

                    part.comments =
                        partCommentsEditingController.text.toString();
                    part.postageOptions =
                        postageOptionsController.text.toString();
                    part.ebayTitle = ebayTitleEditingController.text.toString();
                    part.imgList = List.from(ImageList.partImageList);

                    part.isEbay = isEbay;
                    part.isFeaturedWeb = isFeaturedWeb;
                    part.isDefault = isDefault;
                    print(part.imgList);
                    print(part.ebayTitle);
                    String msg =
                        "\n\n\n\n**************** Inserting Part Details clicked ${DateFormat("hh:mm:ss yyyy/MM/dd").format(DateTime.now())} **************** \n\n";
                    msg += part.addLog();

                    final File file = File(
                        '${AppConfig.externalDirectory!.path}/${ApiConfig.baseQueryParams['username']}_${DateFormat("ddMMyy").format(DateTime.now())}.txt');
                    await file.writeAsString(msg, mode: FileMode.append);
                    Navigator.pop(context, part);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        "Save",
                        style: TextStyle(color: MyTheme.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
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
                  print(postageItems);
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
                      .push(createRoute(DropDownScreen(
                          dropDownItems: menuItems, title: title)))
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
                  focusedBorder: focusedBorder,
                  hintText: title == 'Postage Option' ?'Select Shipping Options':"",
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: MyTheme.grey,
                  )),
              controller: controller,
              maxLines: null,
            ),
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
                    enabledBorder: border,
                    focusedBorder: title == 'Ebay Title' &&
                            ebayTitleEditingController.text.length >= 80
                        ? redBorder
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
                  type: "Part",
                )))
        .then((value) => setState(() {}));
  }
}

class PartNameBar extends StatelessWidget implements PreferredSizeWidget {
  const PartNameBar({super.key, required this.partName});
  final String partName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Text(
          partName,
          style: const TextStyle(
              fontWeight: FontWeight.w400, fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(0, 35);
}
