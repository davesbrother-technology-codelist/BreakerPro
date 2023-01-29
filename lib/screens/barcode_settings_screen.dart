import 'package:flutter/material.dart';
import '../app_config.dart';
import '../my_theme.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({Key? key}) : super(key: key);

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  String selected = "Qr code";
  List<String> barcodes = ["Qr code", "Lined"];

  @override
  void initState() {
    selected = AppConfig.barcode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
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
            "Barcode",
            style: TextStyle(color: MyTheme.white),
          ),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: const Text('Select the barcode type for camera scanner',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
            ),
            ListView.builder(
                itemExtent: 40,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: barcodes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // dense: true,
                    visualDensity: VisualDensity(vertical: -4),
                    // minVerticalPadding: 0,
                    onTap: () {
                      setState(() {
                        selected = barcodes[index];
                      });
                    },
                    title: Row(
                      children: <Widget>[
                        Radio(
                          value: barcodes[index],
                          groupValue: selected,
                          onChanged: (value) {
                            setState(() {
                              selected = value.toString();
                            });
                          },
                        ),
                        Text(barcodes[index]),
                      ],
                    ),
                  );
                }),
            Container(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  AppConfig.barcode = selected;
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ));
  }
}
