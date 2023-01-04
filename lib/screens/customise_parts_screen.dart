import 'package:breaker_pro/api/api_config.dart';
import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:breaker_pro/dataclass/vehicle.dart';
import 'package:breaker_pro/screens/main_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:breaker_pro/screens/customise_parts_screen2.dart';
import '../dataclass/part.dart';
import '../my_theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'addPart.dart';

class CustomisePartsScreen extends StatefulWidget {
  const CustomisePartsScreen({Key? key}) : super(key: key);

  @override
  State<CustomisePartsScreen> createState() => _CustomisePartsScreenState();
}

class _CustomisePartsScreenState extends State<CustomisePartsScreen> {
  OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(width: 2, color: MyTheme.materialColor));
  OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(width: 2, color: MyTheme.blue));
  late List<Part> partsList;
  bool selectAll = false;
  @override
  void initState() {
    partsList = Provider.of<PartsList>(context, listen: false).partList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        color: MyTheme.materialColor,
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          onPressed: () {
            uploadParts();
            uploadVehicle();
          },
          child: Text(
            "Upload",
            style: TextStyle(color: MyTheme.white),
          ),
        ),
      ),
      appBar: AppBar(
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
        actions: [
          IconButton(
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPart()))

              },
              icon: Icon(
                Icons.add_circle,
                color: MyTheme.white,
              )),
          IconButton(
              onPressed: () => {},
              icon: Icon(
                Icons.filter_list,
                color: MyTheme.white,
              )),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: MyTheme.materialColor,
            padding: EdgeInsets.all(5),
            child: TextField(
              style: TextStyle(color: MyTheme.materialColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: MyTheme.white,
                border: border,
                focusedBorder: focusedBorder,
                enabledBorder: border,
                prefixIcon: Icon(
                  Icons.search,
                  color: MyTheme.black54,
                ),
                labelText: 'Type your keyword here',
                labelStyle: TextStyle(color: MyTheme.black54),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: partsList.length,
              controller: ScrollController(),
              separatorBuilder: (_, __) => const SizedBox(height: 5),
              itemBuilder: (context, index) => Container(
                height: 50,
                color: Colors.white,
                child: ListTile(
                  onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Customise()))
                  },
                  trailing: Text(partsList[index].id.toString()),
                  title: Text(partsList[index].partName),
                  // onChanged: (bool? value) {
                  //   partsList[index].isSelected = value!;
                  //   if (value == true) {
                  //     selectedPartsList.add(partsList[index]);
                  //   } else {
                  //     selectedPartsList.remove(partsList[index]);
                  //   }
                  //   setState(() {});
                  // },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uploadParts() async {
    for (Part part in partsList) {
      Map m = {...ApiConfig.baseQueryParams, ...part.toJson()};
      var r = await http.post(
        Uri.parse(ApiConfig.baseUrl + ApiConfig.apiSubmitParts),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(m),
      );

      print(r);
    }

    Fluttertoast.showToast(msg: "Parts Upload Successful");
  }

  Future<void> uploadVehicle() async {
    Map m = {...ApiConfig.baseQueryParams, ...Vehicle().toJson()};
    var r = await http.post(
      Uri.parse(
          "${ApiConfig.baseUrl}${ApiConfig.apiSubmitVehicle}?ClientID=${ApiConfig.baseQueryParams['clientid']}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(m),
    );

    print(r);

    Fluttertoast.showToast(msg: "Vehicle Upload Successful");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => MainDashboard()));
  }
}



