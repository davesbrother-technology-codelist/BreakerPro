import 'package:breaker_pro/app_config.dart';
import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:flutter/material.dart';
import '../dataclass/part.dart';
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
  String? partTypeValue;
  TextEditingController partNameEditingController = TextEditingController();
  List<String> items = AppConfig.partTypeList;
  List<DropdownMenuItem<String>> dropdownItems = [];

  @override
  void initState() {
    super.initState();
    for (String item in items) {
      dropdownItems.add(DropdownMenuItem(
        value: item,
        child: Text(item),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomSheet: Container(
          color: MyTheme.materialColor,
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            onPressed: () {
              Part part = Part(0, partNameEditingController.text.toString().toUpperCase(),
                  partTypeValue.toString(), "", "", "", "", "", "[EBAY_MAKE] [EBAY_MODEL] [YEAR*] [PART NAME] [THATCHAM_PARTMANUFACTURERNUMBER]");
              part.isDefault = true;
              Navigator.pop(
                  context, part);

            },
            child: Text(
              "Save",
              style: TextStyle(color: MyTheme.white),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: MyTheme.materialColor,
          title: const Text("Add Part"),
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
            const SizedBox(
              height: 20,
            ),
            customTextField("Part Type"),
            custom2TextField("Part Name", 1, TextInputType.name),
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
            value: partTypeValue,
            items: dropdownItems,
            onChanged: (value) {
              setState(() {
                partTypeValue = value;
              });
            },
            decoration: InputDecoration(
                hintText: partTypeValue,
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
                textCapitalization: TextCapitalization.characters,
                controller: partNameEditingController,
                keyboardType: TType,
                decoration: InputDecoration(
                    enabledBorder: border, focusedBorder: border))
          ]),
    );
  }
}
