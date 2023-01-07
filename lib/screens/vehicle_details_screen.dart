import 'dart:convert';
import 'dart:io';
import 'package:breaker_pro/api/vehicle_repository.dart';
import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:breaker_pro/screens/drop_down_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:breaker_pro/dataclass/image_list.dart';
import 'package:breaker_pro/screens/allocate_parts_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_config.dart';
import '../dataclass/vehicle.dart';
import '../my_theme.dart';
import 'capture_screen.dart';
import 'main_dashboard.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({Key? key}) : super(key: key);

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  OutlineInputBorder border =
      OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.grey));
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
  TextEditingController transmissionController = TextEditingController();
  TextEditingController engineCodeController = TextEditingController();
  TextEditingController onSiteDateController = TextEditingController();
  TextEditingController mileageController = TextEditingController();
  TextEditingController costPriceController = TextEditingController();
  TextEditingController collectionDateController = TextEditingController();
  TextEditingController dePollutionDateController = TextEditingController();
  TextEditingController destructionDateController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController vehicleLocController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  TextEditingController demoController = TextEditingController();
  TextEditingController makeController = TextEditingController(text: "");
  TextEditingController modelController = TextEditingController(text: "");
  TextEditingController fuelController = TextEditingController();
  TextEditingController bodyStyleController = TextEditingController(text: "");
  TextEditingController colourController = TextEditingController();
  TextEditingController mnfYearController = TextEditingController();
  TextEditingController yearFromController = TextEditingController();
  TextEditingController yearToController = TextEditingController();
  TextEditingController engineController = TextEditingController();

  List<String> makeMenuItems = [];
  List<String> modelMenuItems = [];
  List<String> fuelMenuItems = [];
  List<String> bodyStyleMenuItems = [];
  List<String> colourMenuItems = [];
  List<String> yearsList = [];

  DateTime? destructionDate;
  DateTime? dePollutionDate;
  DateTime? collectionDate;
  DateTime? onSiteDate;

  @override
  void initState() {
    fetchSelectList();
    super.initState();
    int currentYear = DateTime.now().year;
    for (int i = 1980; i <= currentYear; i++) {
      yearsList.add(i.toString());
    }
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
                  customTextField("Colour", colorController)
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
                  customTextField("Make", makeController),
                  customTextField("Engine", engineController)
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
                            focusedBorder: border,
                          ),
                          controller:
                              TextEditingController(text: modelController.text),
                        )),
                  ],
                ),
              ),
              Row(
                children: [
                  customTextField("Style", bodyStyleController),
                  customTextField("Colour", colorController)
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
                            focusedBorder: border,
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
                            focusedBorder: border,
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
                            var image = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);

                            setState(() {
                              // images.add(image);
                              // images= pickedGallery.map((e) => File(e.path)).toList();
                              ImageList.vehicleImgList.add(image!.path);
                            });
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
                                              width: 9,
                                              height: 16,
                                              child: Image.file(File(ImageList
                                                  .vehicleImgList[index])),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: -5,
                                          right: -13,
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
                        'Breaking for Spares',
                        style: TextStyle(color: MyTheme.white, fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Vehicle vehicle = Vehicle();
                        vehicle.imgList = ImageList.vehicleImgList;
                        vehicle.registrationNumber =
                            regNoController.text.toString();
                        vehicle.stockReference =
                            stockRefController.text.toString();
                        vehicle.make = makeController.text.toString();
                        try {
                          vehicle.cc = int.parse(ccController.text.toString());
                        } catch (e) {
                          print("Failedd");
                        }

                        vehicle.model = modelController.text.toString();
                        vehicle.type = typeModelController.text.toString();
                        vehicle.fuel = fuelController.text.toString();
                        vehicle.bodyStyle = bodyStyleController.text.toString();
                        vehicle.vin = vinController.text.toString();
                        vehicle.colour = colorController.text.toString();
                        vehicle.transmission =
                            transmissionController.text.toString();
                        vehicle.engineCode =
                            engineCodeController.text.toString();
                        vehicle.manufacturingYear =
                            mnfYearController.text.toString();
                        vehicle.onSiteDate =
                            onSiteDateController.text.toString();
                        vehicle.fromYear = yearFromController.text.toString();
                        vehicle.toYear = yearToController.text.toString();
                        vehicle.ebayMake = makeController.text.toString();
                        vehicle.engineCapacity =
                            engineCodeController.toString();
                        vehicle.ebayModel = modelController.text.toString();
                        vehicle.ebayStyle = bodyStyleController.text.toString();
                        vehicle.colour = colorController.text.toString();
                        vehicle.mileage = mileageController.text.toString();
                        vehicle.costPrice = costPriceController.text.toString();
                        vehicle.collectiondate =
                            collectionDateController.text.toString();
                        vehicle.depollutiondate =
                            dePollutionDateController.text.toString();
                        vehicle.weight = weightController.text.toString();
                        vehicle.location = vehicleLocController.text.toString();
                        vehicle.commentDetails =
                            commentsController.text.toString();
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
        Vehicle vehicle = Vehicle();
        vehicle.imgList = ImageList.vehicleImgList;
        vehicle.registrationNumber = regNoController.text.toString();
        vehicle.stockReference = stockRefController.text.toString();
        vehicle.make = makeController.text.toString();
        try {
          vehicle.cc = int.parse(ccController.text.toString());
        } catch (e) {
          print("Failedd");
        }

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
        vehicle.ebayMake = makeController.text.toString();
        vehicle.engineCapacity = engineCodeController.toString();
        vehicle.ebayModel = modelController.text.toString();
        vehicle.ebayStyle = bodyStyleController.text.toString();
        vehicle.colour = colorController.text.toString();
        vehicle.mileage = mileageController.text.toString();
        vehicle.costPrice = costPriceController.text.toString();
        vehicle.collectiondate = collectionDateController.text.toString();
        vehicle.depollutiondate = dePollutionDateController.text.toString();
        vehicle.weight = weightController.text.toString();
        vehicle.location = vehicleLocController.text.toString();
        vehicle.commentDetails = commentsController.text.toString();

        PartsList.uploadVehicle = vehicle;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('uploadVehicle', true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => MainDashboard()));
      },
      child: const Text("OK"),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("OK to Add Breaking for Spares?"),
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
                focusedBorder: border,
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
                    focusedBorder: border,
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
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: border,
                  focusedBorder: border,
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
              child: TextField(
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
                      if (value['title'] == 'Make' &&
                          !(makeController.text == value['value'])) {
                        modelController.clear();
                        modelMenuItems = createMenuList(
                            value['value'], modelMenuItems, responseJson);
                      }
                      controller.text = value['value'];
                    });
                  });
                },
                decoration: InputDecoration(
                    enabledBorder: border,
                    focusedBorder: border,
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
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      ImageList.vehicleImgList.add(image!.path);
    });
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

  createMenuList(String title, List<String> menu, Map responseJson) {
    List l = responseJson[title];
    menu.clear();
    menu = List<String>.generate(l.length, (index) => l[index]);
    return menu;
  }

// Widget custom2TextField(String title, Widget name) {
//   return Container(
//       padding: containerEdgeInsetsGeometry,
//       width: MediaQuery.of(context).size.width / 2,
//       child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: textEdgeInsetsGeometry,
//               child: Text(
//                 title,
//                 style: textStyle,
//               ),
//             ),
//             TextField(
//                 onTap: () {
//                   setState(() {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => name));
//                   });
//                 },
//                 decoration: InputDecoration(
//                   // hintText: '${Constants().selectedItem}',
//                   enabledBorder: border,
//                   focusedBorder: border,
//                 )),
//           ]));
// }

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
}
