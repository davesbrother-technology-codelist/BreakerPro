import 'dart:convert';
import 'dart:io';
import 'package:exif/exif.dart';
import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:breaker_pro/screens/drop_down_screen.dart';
import 'package:breaker_pro/utils/main_dashboard_utils.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:breaker_pro/screens/allocate_parts_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_config.dart';
import '../dataclass/part.dart';
import '../dataclass/vehicle.dart';
import '../my_theme.dart';
import 'capture_screen.dart';
import 'main_dashboard.dart';
import 'package:path/path.dart' as path;

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({Key? key}) : super(key: key);

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  OutlineInputBorder border =
      OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.grey));
  OutlineInputBorder focusedBorder =
      OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.materialColor));
  TextStyle textStyle = TextStyle(fontSize: 17, color: MyTheme.grey);
  EdgeInsetsGeometry textEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(0, 10, 10, 10);
  EdgeInsetsGeometry containerEdgeInsetsGeometry =
      const EdgeInsets.fromLTRB(10, 5, 10, 5);
  late Map responseJson;

  TextEditingController regNoController = TextEditingController();
  TextEditingController stockRefController = TextEditingController();
  TextEditingController ccController = TextEditingController();
  TextEditingController typeModelController = TextEditingController();
  TextEditingController vinController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController colorEbayController = TextEditingController();
  TextEditingController transmissionController = TextEditingController();
  TextEditingController engineCodeController = TextEditingController(text: "");
  TextEditingController onSiteDateController = TextEditingController();
  TextEditingController mileageController = TextEditingController();
  TextEditingController costPriceController = TextEditingController();
  TextEditingController collectionDateController = TextEditingController();
  TextEditingController dePollutionDateController = TextEditingController();
  TextEditingController destructionDateController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController vehicleLocController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  TextEditingController makeController = TextEditingController(text: "");
  TextEditingController makeEbayController = TextEditingController(text: "");
  TextEditingController modelController = TextEditingController(text: "");
  TextEditingController modelEbayController = TextEditingController(text: "");
  TextEditingController fuelController = TextEditingController();
  TextEditingController bodyStyleController = TextEditingController(text: "");
  TextEditingController mnfYearController = TextEditingController();
  TextEditingController yearFromController = TextEditingController();
  TextEditingController yearToController = TextEditingController();
  TextEditingController engineEbayController = TextEditingController();
  TextEditingController styleEbayController = TextEditingController();

  List<String> makeMenuItems = [];
  List<String> modelMenuItems = [];
  List<String> fuelMenuItems = [];
  List<String> bodyStyleMenuItems = [];
  List<String> colourMenuItems = [];
  List<String> yearsList = [];

  bool recall = false;

  DateTime? destructionDate;
  DateTime? dePollutionDate;
  DateTime? collectionDate;
  DateTime? onSiteDate;
  Vehicle vehicle = Vehicle();

  @override
  void initState() {
    fetchSelectList();
    recall = PartsList.recall;
    super.initState();
    int currentYear = DateTime.now().year;
    for (int i = currentYear; i >= 1980; i--) {
      yearsList.add(i.toString());
    }
    if (PartsList.cachedVehicle != null) {
      PartsList.saveVehicle = true;
      Vehicle v = PartsList.cachedVehicle!;
      recall = v.recallID.isNotEmpty;
      regNoController.text = v.registrationNumber ?? "";
      stockRefController.text = v.stockReference ?? "";
      makeController.text = v.make ?? "";
      ccController.text = v.cc ?? "";
      modelController.text = v.model ?? "";
      typeModelController.text = v.type;
      fuelController.text = v.fuel ?? "";
      bodyStyleController.text = v.bodyStyle ?? "";
      vinController.text = v.vin ?? "";
      colorController.text = v.colour ?? "";
      transmissionController.text = v.transmission ?? "";
      engineCodeController.text = v.engineCode ?? "";
      mnfYearController.text = v.manufacturingYear ?? "";
      yearFromController.text = v.fromYear.isNotEmpty
          ? DateFormat("yyyy").parse(v.fromYear).year.toString()
          : "";
      yearToController.text = v.toYear.isNotEmpty
          ? DateFormat("yyyy").parse(v.toYear).year.toString()
          : "";
      makeEbayController.text = v.ebayMake ?? "";
      engineEbayController.text = v.ebayEngine ?? "";
      modelEbayController.text = v.ebayModel ?? "";
      styleEbayController.text = v.ebayStyle ?? "";
      colorEbayController.text = v.ebayColor ?? "";
      mileageController.text = v.mileage;
      costPriceController.text = v.costPrice;
      collectionDateController.text = v.collectiondate;
      dePollutionDateController.text = v.depollutiondate;
      destructionDateController.text = v.coddate;
      vehicleLocController.text = v.location;
      weightController.text = v.weight ?? "";
      commentsController.text = v.commentDetails ?? "";
      setState(() {});
    }

  }

  @override
  void dispose() {
    if (makeController.text.isNotEmpty && PartsList.saveVehicle) {
      print("Saving while dispose");
      saveVehicle();
    } else {
      ImageList.vehicleImgList = [];
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          title: Text(
            "Vehicle Details",
            style: TextStyle(color: MyTheme.white),
          ),
          elevation: 0,
          bottom: PreferredSize(
              preferredSize: recall ? Size.fromHeight(48) : Size.fromHeight(0),
              child: recall
                  ? Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.warning_outlined,
                              color: MyTheme.materialColor,
                            ),
                          ),
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Recalls are associated to this vehicle, please check the DVLA Safetly Recall site for more details",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : SizedBox()),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  customTextField("Registration Number", regNoController),
                  customTextField("Stock Reference", stockRefController)
                ],
              ),
              Row(
                children: [
                  customDropDownField("Make", makeMenuItems, makeController),
                  customTextField("CC", ccController, isDigit: true)
                ],
              ),
              Row(
                children: [
                  customDropDownField("Model", modelMenuItems, modelController),
                  customTextField("Type Model", typeModelController)
                ],
              ),
              Row(
                children: [
                  customDropDownField("Fuel", fuelMenuItems, fuelController),
                  customDropDownField(
                      "Body Style", bodyStyleMenuItems, bodyStyleController)
                ],
              ),
              Row(
                children: [
                  customTextField("VIN", vinController),
                  customDropDownField(
                      "Colour", colourMenuItems, colorController)
                ],
              ),
              Row(
                children: [
                  customTextField("Transmission", transmissionController),
                  customTextField("Engine Code", engineCodeController,
                      isDigit: true)
                ],
              ),
              Row(
                children: [
                  yearDropDownTextField(
                      "Manufacturing Year", yearsList, mnfYearController),
                  datePickerTextField(
                      "On Site Date", onSiteDateController, onSiteDate)
                  // customTextField("On Site Date",
                  //     dropDownValue: onSiteDateValue, menuItems: yearMenuItems)
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: yearDropDownTextField(
                          "Year Range", yearsList, yearFromController)),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      "To",
                      style: textStyle,
                    ),
                  ),
                  Expanded(
                      child:
                          yearDropDownTextField("", yearsList, yearToController)
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
                children: [
                  customTextField("Make", makeEbayController),
                  customTextField("Engine", engineEbayController)
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
                        "Model",
                        style: textStyle,
                      ),
                    ),
                    SizedBox(
                        height: 60,
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: border,
                            focusedBorder: focusedBorder,
                          ),
                          controller: TextEditingController(
                              text: modelEbayController.text),
                        )),
                  ],
                ),
              ),
              Row(
                children: [
                  customTextField("Style", styleEbayController),
                  customTextField("Colour", colorEbayController)
                ],
              ),
              Divider(
                thickness: 2,
                indent: 10,
                endIndent: 10,
                color: MyTheme.black,
                height: 10,
              ),
              Row(
                children: [
                  customTextField("Mileage", mileageController, isDigit: true),
                  customTextField("Cost Price", costPriceController,
                      isDigit: true)
                ],
              ),
              Row(
                children: [
                  datePickerTextField("Collection Date",
                      collectionDateController, collectionDate),
                  datePickerTextField("Depollution Date",
                      dePollutionDateController, dePollutionDate)
                ],
              ),
              Row(
                children: [
                  datePickerTextField("Destruction Date",
                      destructionDateController, destructionDate),
                  customTextField("Weight", weightController, isDigit: true)
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
                            focusedBorder: focusedBorder,
                          ),
                          controller: vehicleLocController,
                        )),
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
                            focusedBorder: focusedBorder,
                          ),
                          controller: commentsController,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                height: ImageList.vehicleImgList.isNotEmpty ? 210 : 80,
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
                            List<XFile> imageFileList=[];
                            List<XFile>? selectedImages = await imagePicker.pickMultiImage();
                            if(selectedImages.isNotEmpty){
                              imageFileList.addAll(selectedImages);
                            }
                            for (int i = 0; i < imageFileList.length; i++){
                              XFile image = imageFileList[i];
                              File imgFile = File(image.path);
                              imgFile = await FlutterExifRotation.rotateAndSaveImage(path: imgFile.path);
                              Map<String, IfdTag> data = await readExifFromBytes(await imgFile.readAsBytes());
                              print(data);
                              // imgFile = imgFile.renameSync(image.path.replaceAll('.jpg', '.png'));
                              imageFileList[i] = XFile(imgFile.path);
                            }
                            setState(() {
                              List<String> l = List.generate(imageFileList.length, (index) => imageFileList[index].path);
                              // int i = 1;
                              // for(XFile image in imageFileList){
                              //   File imgFile = File(image.path);
                              //     String dir = path.dirname(imgFile.path);
                              //       int count = PartsList.vehicleCount;
                              //       String newPath = path.join(dir,
                              //           'IMGVHC${DateFormat('yyyyMMddHHmmss').format(DateTime.now().add(Duration(seconds: i)))}${count.toString().padLeft(4, '0')}$count${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
                              //       imgFile = imgFile.renameSync(newPath);
                                    ImageList.vehicleImgList.addAll(l);
                              //       i += 1;
                              // }
                              saveVehicle();
                            });


                            // XFile? image = await ImagePicker()
                            //     .pickImage(source: ImageSource.gallery);

                            // if (image != null) {
                            //   File imgFile = File(image.path);
                            //   print(imgFile.path);
                            //   String dir = path.dirname(imgFile.path);
                            //   setState(() {
                            //     int count = PartsList.vehicleCount;
                            //     String newPath = path.join(dir,
                            //         'IMGVHC${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${count.toString().padLeft(4, '0')}$count${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
                            //     imgFile = imgFile.renameSync(newPath);
                            //     ImageList.vehicleImgList.add(imgFile.path);
                            //     saveVehicle();
                            //   });
                            // }
                            for (String img in ImageList.vehicleImgList) {
                              print(img);
                            }
                          },
                        ),
                      ],
                    ),
                    ImageList.vehicleImgList.isNotEmpty
                        ? Align(
                            alignment: Alignment.bottomLeft,
                            child: SizedBox(
                              height: 140,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: ImageList.vehicleImgList.length,
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
                                              child: Image.file(File(ImageList
                                                  .vehicleImgList[index]),fit: BoxFit.cover,),
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
                                                ImageList.vehicleImgList
                                                    .removeAt(index);
                                                saveVehicle();
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
              const SizedBox(height: 10),
              Container(
                height: 50,
                color: const Color.fromRGBO(238, 180, 22, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        openBreakingSparesDialog(context);
                      },
                      child: Text(
                        PartsList.isStockRef ? 'Update Breaker':'Breaking for Spares',
                        style: TextStyle(color: MyTheme.white, fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (makeController.text.isEmpty) {
                          return;
                        }
                        saveVehicle();
                        print("Passed ID" + vehicle.vehicleId);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AllocatePartsScreen(
                            vehicle: vehicle,
                          ),
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

  openBreakingSparesDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget okButton = TextButton(
      onPressed: () async {
        if(PartsList.isUploading){
          PartsList.newAdded = true;
          print("Set true");
        }
        await saveVehicle();
        makeController.clear();
        PartsList.saveVehicle = false;
        PartsList.uploadQueue.add(vehicle.vehicleId);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        PartsList.vehicleCount += 1;
        ImageList.vehicleImgList = [];
        PartsList.cachedVehicle = null;
        PartsList.recall = false;
        PartsList.isStockRef = false;
        prefs.setBool('uploadVehicle', true);
        await prefs.remove('vehicle');
        print("Cleared cache");
        MainDashboardUtils.titleList[0] = "Add & Manage Breaker";

        Box<Part> box = await Hive.openBox('partListBox');
        Box<Part> box1 = await Hive.openBox('selectPartListBox');
        await box.clear();
        await box1.clear();
        PartsList.selectedPartList = [];
        PartsList.partList = [];
        PartsList.uploadPartList = [];
        print("Upload Queue: ${PartsList.uploadQueue}");
        await prefs.setString(
            'uploadQueue', jsonEncode({'uploadQueue': PartsList.uploadQueue}));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => MainDashboard()),
            (Route route) => false);
      },
      child: const Text("OK"),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: PartsList.isStockRef ? const Text("Update Breaker") : const Text("OK to Add Breaking for Spares?"),
      actions: [
        cancelButton,
        okButton,
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

  saveVehicle() async {
    PartsList.saveVehicle = true;
    vehicle.imgList = List<String>.from(ImageList.vehicleImgList);
    vehicle.uploadVehicleImgListStatus = List.generate(vehicle.imgList.length, (index) => false);
    ImageList.uploadVehicleImgListStatus = List<bool>.from(vehicle.uploadVehicleImgListStatus);
    vehicle.registrationNumber = regNoController.text.toString();
    vehicle.stockReference = stockRefController.text.toString();
    vehicle.make = makeController.text.toString();
    vehicle.cc = ccController.text.toString();
    vehicle.model = modelController.text.toString();
    vehicle.type = typeModelController.text.toString();
    vehicle.fuel = fuelController.text.toString();
    vehicle.bodyStyle = bodyStyleController.text.toString();
    vehicle.vin = vinController.text.toString();
    vehicle.colour = colorController.text.toString();
    vehicle.transmission = transmissionController.text.toString();
    vehicle.engineCode = engineCodeController.text.toString();
    vehicle.manufacturingYear = mnfYearController.text.toString();
    vehicle.onSiteDate = onSiteDateController.text.toString();
    vehicle.fromYear = yearFromController.text.toString();
    vehicle.toYear = yearToController.text.toString();
    vehicle.ebayMake = makeEbayController.text.toString();
    vehicle.ebayModel = modelEbayController.text.toString();
    vehicle.ebayStyle = styleEbayController.text.toString();
    vehicle.colour = colorController.text.toString();
    vehicle.ebayColor = colorEbayController.text.toString();
    vehicle.mileage = mileageController.text.toString();
    vehicle.costPrice = costPriceController.text.toString();
    vehicle.collectiondate = collectionDateController.text.toString();
    vehicle.depollutiondate = dePollutionDateController.text.toString();
    vehicle.coddate = destructionDateController.text.toString();
    vehicle.weight = weightController.text.toString();
    vehicle.location = vehicleLocController.text.toString();
    vehicle.commentDetails = commentsController.text.toString();
    if(vehicle.vehicleId.isEmpty){
      vehicle.vehicleId =
      "VHC${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${PartsList.vehicleCount.toString().padLeft(4, '0')}";
    }


    PartsList.cachedVehicle = vehicle;
    String model = modelController.text.isEmpty ? "Model" : vehicle.model;
    MainDashboardUtils.titleList[0] = "Resume Work ( ${vehicle.make}-$model )";

    String vehicleString = jsonEncode(vehicle.toJson());
    await PartsList.prefs!.setString(vehicle.vehicleId, vehicleString);
    await PartsList.prefs!.setString('vehicle', vehicleString);
    print(PartsList.prefs!.getString(vehicle.vehicleId));

    print("Save Vehicle ${MainDashboardUtils.titleList[0]}");
    print("Save Vehicle ${PartsList.cachedVehicle!.imgList}");
    print("Save Vehicle ${vehicle.imgList}");
  }

  Widget datePickerTextField(
      String title, TextEditingController controller, DateTime? selectedDate) {
    if (title == 'On Site Date') {
      controller.text = DateFormat.yMd().format(DateTime.now());
    }
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
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                  controller.text = DateFormat.yMd().format(selectedDate!);
                });
              }
            },
            readOnly: true,
            controller: controller,
            decoration: InputDecoration(
                hintText: selectedDate == null ? "" : selectedDate.toString(),
                enabledBorder: border,
                focusedBorder: focusedBorder,
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: MyTheme.grey,
                )),
          ),
        ],
      ),
    );
  }

  Widget yearDropDownTextField(
      String title, List<String> yearItems, TextEditingController controller) {
    String label = '';
    if (title == 'Year Range') {
      label = 'Year From';
    } else if (title == '') {
      label = 'Year To';
    }
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
              child: TextField(
                readOnly: true,
                onTap: () async {
                  await Navigator.of(context)
                      .push(createRoute(DropDownScreen(
                          dropDownItems: yearItems, title: title)))
                      .then((value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      controller.text = value['value'];
                    });
                  });
                },
                decoration: InputDecoration(
                    enabledBorder: border,
                    focusedBorder: focusedBorder,
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    hintText: label),
                controller: controller,
              )),
        ],
      ),
    );
  }

  Widget customTextField(String title, controller, {bool isDigit = false}) {
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
              child:
              TextField(
                onChanged: (String? s) {
                  if (title == "CC" && s != null) {
                    setState(() {
                      engineEbayController.text = s;
                    });
                  }
                  if (title == "Type Model" && s != null) {
                    setState(() {
                      modelEbayController.text = "${modelController.text} $s";
                    });
                  }
                  if (makeController.text.isNotEmpty) {
                    saveVehicle();
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: border,
                  focusedBorder: focusedBorder,
                ),
                controller: controller,
                keyboardType:
                    isDigit ? TextInputType.number : TextInputType.text,
              )),
        ],
      ),
    );
  }

  Widget customDropDownField(
      String title, List<String> menuItems, TextEditingController controller) {
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
              child:
              TextField(
                readOnly: true,
                onTap: () async {
                  await Navigator.of(context)
                      .push(createRoute(DropDownScreen(
                          dropDownItems: menuItems, title: title)))
                      .then((value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      switch (value['title']) {
                        case 'Make':
                          {
                            makeEbayController.text = value['value'];
                          }
                          break;
                        case 'Model':
                          {
                            modelEbayController.text = value['value'] + " " + typeModelController.text;
                          }
                          break;
                        case 'Body Style':
                          {
                            styleEbayController.text = value['value'];
                          }
                          break;
                        case 'Colour':
                          {
                            colorEbayController.text = value['value'];
                          }
                          break;
                      }
                      if (value['title'] == 'Make' &&
                          !(makeController.text == value['value'])) {
                        modelController.clear();
                        modelMenuItems = createMenuList(
                            value['value'], modelMenuItems, responseJson);
                        modelEbayController.text = typeModelController.text;
                      }
                      controller.text = value['value'];

                      setState(() {
                        if (value['title'] == 'Make' ||
                            value['title'] == 'Model') {
                          saveVehicle();
                        }
                      });
                    });
                  });
                },
                decoration: InputDecoration(
                    enabledBorder: border,
                    focusedBorder: focusedBorder,
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: MyTheme.grey,
                    )),
                controller: controller,
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

  Future getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imgFile = File(image.path);
      print(imgFile.path);
      String dir = path.dirname(imgFile.path);
      setState(() {
        int count = PartsList.vehicleCount;
        String newPath = path.join(dir,
            'IMGVHC${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${count.toString().padLeft(4, '0')}$count${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg');
        imgFile = imgFile.renameSync(newPath);
        ImageList.vehicleImgList.add(imgFile.path);
      });
    }
    for (String img in ImageList.vehicleImgList) {
      print(img);
    }
  }

  openCamera() async {
    NavigatorState state = Navigator.of(context);
    final cameras = await availableCameras();
    state
        .push(MaterialPageRoute(
            builder: (context) => CaptureScreen(
                  cameras: cameras,
                  type: 'Vehicle',
                )))
        .then((value) => setState(() {
              saveVehicle();
            }));
  }

  fetchSelectList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String response = prefs.getString('selectList').toString();
    responseJson = jsonDecode(response);

    // for(var a in responseJson.keys){
    //   // if(a == "EBAYSTORECAT"){
    //   //   print(responseJson[a]);
    //   // }
    //   print(responseJson[a]);
    // }
    if (makeController.text.isNotEmpty) {
      modelMenuItems =
          createMenuList(makeController.text, modelMenuItems, responseJson);
    }
    makeMenuItems = createMenuList('MAKE', makeMenuItems, responseJson);
    fuelMenuItems = createMenuList('FUEL', fuelMenuItems, responseJson);
    bodyStyleMenuItems =
        createMenuList('STYLE', bodyStyleMenuItems, responseJson);
    colourMenuItems = createMenuList('COLOUR', colourMenuItems, responseJson);
    setState(() {});
  }

  createMenuList(String title, List<String> menu, Map responseJson) {
    List l = responseJson[title];
    menu.clear();
    menu = List<String>.generate(l.length, (index) => l[index]);
    return menu;
  }
}
