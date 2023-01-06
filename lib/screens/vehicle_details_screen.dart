import 'dart:convert';
import 'dart:io';
import 'package:breaker_pro/api/vehicle_repository.dart';
import 'package:breaker_pro/dataclass/parts_list.dart';
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
  bool modelEnable = false;

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

  String? makeValue;
  String? modelValue;
  String? fuelValue;
  String? bodyStyleValue;

  String? mnfYearValue;
  String? yearFromValue;
  String? yearToValue;

  late List<DropdownMenuItem<String>> makeMenuItems = [];
  late List<DropdownMenuItem<String>> modelMenuItems = [];
  late List<DropdownMenuItem<String>> fuelMenuItems = [];
  late List<DropdownMenuItem<String>> bodyStyleMenuItems = [];
  late List<DropdownMenuItem<String>> colourMenuItems = [];
  late List<DropdownMenuItem<String>> yearMenuItems = [];

  List<DropdownMenuItem<String>> yearsList = [];
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
      yearsList.add(
        DropdownMenuItem(
          value: i.toString(),
          child: Text(i.toString()),
        ),
      );
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
                  customTextField("Registration Number",
                      controller: regNoController),
                  customTextField("Stock Reference",
                      controller: stockRefController)
                ],
              ),
              Row(
                children: [
                  customTextField("Make",
                      dropDownValue: makeValue, menuItems: makeMenuItems),
                  // custom2TextField("Make",Make()),
                  customTextField("CC", controller: ccController)
                ],
              ),
              Row(
                children: [
                  customTextField("Model",
                      dropDownValue: modelValue,
                      menuItems: modelMenuItems,
                      enable: modelEnable),
                  // model,
                  customTextField("Type Model", controller: typeModelController)
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
                children: [
                  customTextField("VIN", controller: vinController),
                  customTextField("Colour", controller: colorController)
                ],
              ),
              Row(
                children: [
                  customTextField("Transmission",
                      controller: transmissionController),
                  customTextField("Engine Code",
                      controller: engineCodeController)
                ],
              ),
              Row(
                children: [
                  // customTextField("Manufacturing Year",
                  //     dropDownValue: mnfYearValue, menuItems: yearMenuItems),
                  yearDropDownTextField(
                      "Manufacturing Year", mnfYearValue, yearsList),
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
                          "Year Range", yearFromValue, yearsList)
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
                  Expanded(
                      child: yearDropDownTextField("", yearToValue, yearsList)
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
                  customTextField("Make",
                      controller: TextEditingController(text: makeValue)),
                  customTextField("Engine")
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
                          controller: TextEditingController(text: modelValue),
                        )),
                  ],
                ),
              ),
              Row(
                children: [
                  customTextField("Style",
                      controller: TextEditingController(text: bodyStyleValue)),
                  customTextField("Colour", controller: colorController)
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
              Row(
                children: [
                  customTextField("Mileage", controller: mileageController),
                  customTextField("Cost Price", controller: costPriceController)
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
                  customTextField("Weight", controller: weightController)
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
                        vehicle.make = makeValue.toString();
                        try {
                          vehicle.cc = int.parse(ccController.text.toString());
                        } catch (e) {
                          print("Failedd");
                        }

                        vehicle.model = modelValue.toString();
                        vehicle.type = typeModelController.text.toString();
                        vehicle.fuel = fuelValue.toString();
                        vehicle.bodyStyle = bodyStyleValue.toString();
                        vehicle.vin = vinController.text.toString();
                        vehicle.colour = colorController.text.toString();
                        vehicle.transmission =
                            transmissionController.text.toString();
                        vehicle.engineCode =
                            engineCodeController.text.toString();
                        vehicle.manufacturingYear = mnfYearValue.toString();
                        vehicle.onSiteDate =
                            onSiteDateController.text.toString();
                        vehicle.fromYear = yearFromValue.toString();
                        vehicle.toYear = yearToValue.toString();
                        vehicle.ebayMake = makeValue.toString();
                        vehicle.engineCapacity =
                            engineCodeController.toString();
                        vehicle.ebayModel = modelValue.toString();
                        vehicle.ebayStyle = bodyStyleValue.toString();
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
        vehicle.make = makeValue.toString();
        try {
          vehicle.cc = int.parse(ccController.text.toString());
        } catch (e) {
          print("Failedd");
        }

        vehicle.model = modelValue.toString();
        vehicle.type = typeModelController.text.toString();
        vehicle.fuel = fuelValue.toString();
        vehicle.bodyStyle = bodyStyleValue.toString();
        vehicle.vin = vinController.text.toString();
        vehicle.colour = colorController.text.toString();
        vehicle.transmission = transmissionController.text.toString();
        vehicle.engineCode = engineCodeController.text.toString();
        vehicle.manufacturingYear = mnfYearValue.toString();
        vehicle.onSiteDate = onSiteDateController.text.toString();
        vehicle.fromYear = yearFromValue.toString();
        vehicle.toYear = yearToValue.toString();
        vehicle.ebayMake = makeValue.toString();
        vehicle.engineCapacity = engineCodeController.toString();
        vehicle.ebayModel = modelValue.toString();
        vehicle.ebayStyle = bodyStyleValue.toString();
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
            ),
          ),
        ],
      ),
    );
  }

  Widget yearDropDownTextField(
      String title, String? selectedYear, List<DropdownMenuItem<String>> year) {
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
          DropdownButtonFormField(
            isExpanded: true,
            menuMaxHeight: 300,
            value: selectedYear,
            items: year,
            onChanged: (value) {
              setState(() {
                selectedYear = value!;
                switch (title) {
                  case 'Year Range':
                    {
                      yearFromValue = value;
                    }
                    break;
                  case '':
                    {
                      yearToValue = value;
                    }
                    break;
                  case 'Manufacturing Year':
                    {
                      mnfYearValue = value;
                    }
                    break;
                }
              });
            },
            decoration: InputDecoration(
              hintText: selectedYear ?? label,
              enabledBorder: border,
              focusedBorder: border,
            ),
          ),
        ],
      ),
    );
  }

  Widget customTextField(String title,
      {String? dropDownValue,
      List<DropdownMenuItem<String>>? menuItems,
      bool enable = true,
      TextEditingController? controller}) {
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
                    ),
                    controller: controller,
                  )
                : DropdownButtonFormField(
                    isExpanded: true,
                    menuMaxHeight: 300,
                    decoration: InputDecoration(
                        enabledBorder: border, focusedBorder: border),
                    value: dropDownValue,
                    items: menuItems,
                    onChanged: (String? newValue) {
                      if (title == 'Make') {
                        setState(() {
                          dropDownValue = null;
                          modelValue = null;
                          modelMenuItems.clear();
                        });

                        setState(() {
                          modelMenuItems = createMenuList(newValue.toString(),
                              modelMenuItems, responseJson);
                        });
                      }

                      setState(() {
                        dropDownValue = newValue;
                        switch (title) {
                          case 'Make':
                            {
                              makeValue = newValue;
                            }
                            break;

                          case 'Model':
                            {
                              modelValue = newValue;
                            }
                            break;
                          case 'Fuel':
                            {
                              fuelValue = newValue;
                            }
                            break;
                          case 'Body Style':
                            {
                              bodyStyleValue = newValue;
                            }
                            break;
                        }
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
      ImageList.vehicleImgList.add(image!.path);
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

  createMenuList(
      String title, List<DropdownMenuItem<String>> menu, Map responseJson) {
    List l = responseJson[title];
    menu.clear();
    menu = List<DropdownMenuItem<String>>.generate(
        l.length,
        (index) => DropdownMenuItem(
            value: l[index].toString(), child: Text(l[index])));
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
