import 'package:flutter/material.dart';
import 'vehicle_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dataclass/parts_list.dart';
import 'dart:convert';

// class Make extends StatefulWidget {
//   const Make({Key? key}) : super(key: key);
//
//   @override
//   State<Make> createState() => _MakeState();
// }
//
// class _MakeState extends State<Make> {
//   late PartsList partsList;
//   late Map responseJson;
//   bool modelEnable = true;
//   String? makeValue;
//   String? modelValue;
//   String? fuelValue;
//   String? bodyStyleValue;
//   String? colourValue;
//   String? mnfYearValue;
//   String? onSiteDateValue;
//   String? yearFromValue;
//   String? yearToValue;
//   List l=[];
//   List<String> _items =  [];
//
//
//   late List<DropdownMenuItem<String>> makeMenuItems = [];
//   late List<DropdownMenuItem<String>> modelMenuItems = [];
//   late List<DropdownMenuItem<String>> fuelMenuItems = [];
//   late List<DropdownMenuItem<String>> bodyStyleMenuItems = [];
//   late List<DropdownMenuItem<String>> colourMenuItems = [];
//   late List<DropdownMenuItem<String>> yearMenuItems = [];
//
//   fetchSelectList() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String response = prefs.getString('selectList').toString();
//     responseJson = jsonDecode(response);
//
//     makeMenuItems = createMenuList('MAKE', makeMenuItems, responseJson);
//
//     fuelMenuItems = createMenuList('FUEL', fuelMenuItems, responseJson);
//     bodyStyleMenuItems =
//         createMenuList('STYLE', bodyStyleMenuItems, responseJson);
//     colourMenuItems = createMenuList('COLOUR', colourMenuItems, responseJson);
//     setState(() {});
//   }
//
//   createMenuList(
//       String title, List<DropdownMenuItem<String>> menu, Map responseJson) {
//     l = responseJson[title];
//     menu = List<DropdownMenuItem<String>>.generate(
//         l.length,
//             (index) => DropdownMenuItem(
//             value: l[index].toString(), child: Text(l[index])));
//     // for (var a in menu) {
//     //   print(a);
//     // }
//     return menu;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Select Make"),
//         ),
//         body: ListView.builder(
//         itemCount: _items.length,
//     itemBuilder: (context, index) {
//     return ListTile(
//     title: Text('${_items[index]}'),
//     onTap: () {
// Constants().selectedItem=_items[index];
// Navigator.push(context, MaterialPageRoute(builder: (context)=>VehicleDetailsScreen()));
//     },
//     );
//
//       },
//     )));
//   }
//
//
//
// }
