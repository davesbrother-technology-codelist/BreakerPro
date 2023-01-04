import 'package:flutter/material.dart';
import '../my_theme.dart';


class AddPart extends StatefulWidget {
  const AddPart({Key? key}) : super(key: key);

  @override
  State<AddPart> createState() => _AddPartState();
}

class _AddPartState extends State<AddPart> {
  EdgeInsetsGeometry textEdgeInsetsGeometry =
  const EdgeInsets.fromLTRB(0, 10, 10, 10);
  EdgeInsetsGeometry containerEdgeInsetsGeometry =
  const EdgeInsets.fromLTRB(10, 5, 10, 5);
  TextStyle textStyle = TextStyle(fontSize: 12, color: MyTheme.grey);
  OutlineInputBorder border =
  OutlineInputBorder(borderSide: BorderSide(width: 2, color: MyTheme.grey));
  String? selectedItem;
  List<String> items = [
    'INTERIOR',
    'MECHANICAL',
    'BODY PARTS',
    'ENGINE BAY',
    'WHEELS',
    'LIGHTS',
    'DASHBOARD BARE',
    'GLASS',
    'ELECTRICAL'
  ];
  List<DropdownMenuItem<String>> dropdownItems = [];
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  DateTime? selectedDate;
  String formattedDate = '';

  @override

  void initState() {
    super.initState();
    for (String item in items) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(item),
        value: item,
      ));
    }
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
           Navigator.pop(context);
           },


            child: Text(
              "Save",
              style: TextStyle(color: MyTheme.white),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: MyTheme.materialColor,
          title: Text("Add Part"),
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
          children: [
            SizedBox(
              height: 20,
            ),
customTextField("Part Type"),
            custom2TextField("Part Name", 1, TextInputType.text)
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
}
