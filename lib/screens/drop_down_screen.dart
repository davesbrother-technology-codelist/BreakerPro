import 'package:flutter/material.dart';

import '../my_theme.dart';

class DropDownScreen extends StatefulWidget {
  const DropDownScreen(
      {Key? key, required this.dropDownItems, required this.title})
      : super(key: key);
  final List<String> dropDownItems;
  final String title;

  @override
  State<DropDownScreen> createState() => _DropDownScreenState();
}

class _DropDownScreenState extends State<DropDownScreen> {
  late final List<String> dropDownItems;
  late final List<Widget> d;
  late List<bool> selected;
  late String? selectedOption;
  Map<String, String> map = {};

  @override
  void initState() {
    dropDownItems = widget.dropDownItems;
    d = List<Widget>.generate(
        dropDownItems.length,
        (index) => ListTile(
              onTap: () {
                map['value'] = dropDownItems[index];
                map['title'] = widget.title;
                Navigator.pop(context, map);
              },
              title: Text(dropDownItems[index]),
            ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: MyTheme.materialColor,
              title: Text(widget.title),
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
              scrollDirection: Axis.vertical,
              child: Column(
                children: d,
              ),
            )));
  }
}
