import 'package:flutter/material.dart';

import '../my_theme.dart';

class PostageDropDownScreen extends StatefulWidget {
  const PostageDropDownScreen(
      {Key? key,
      required this.dropDownItems,
      required this.title,
      required this.selectedItems})
      : super(key: key);
  final List<String> dropDownItems;
  final String title;
  final List<bool> selectedItems;
  @override
  State<PostageDropDownScreen> createState() => _PostageDropDownScreenState();
}

class _PostageDropDownScreenState extends State<PostageDropDownScreen> {
  late final List<String> dropDownItems;
  late String? selectedOption;
  Map<String, String> map = {};

  @override
  void initState() {
    dropDownItems = widget.dropDownItems;
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
                  Navigator.pop(context, widget.selectedItems);
                },
              ),
            ),
            body: ListView.builder(itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(dropDownItems[index]),
                controlAffinity: ListTileControlAffinity.leading,
                value: widget.selectedItems[index],
                onChanged: (bool? value) {
                  setState(() {
                    widget.selectedItems[index] = value!;
                  });
                },
              );
            })));
  }
}
