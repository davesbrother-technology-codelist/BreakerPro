import 'package:breaker_pro/app_config.dart';
import 'package:flutter/material.dart';
import '../my_theme.dart';

class AspectRatioScreen extends StatefulWidget {
  const AspectRatioScreen({Key? key}) : super(key: key);

  @override
  State<AspectRatioScreen> createState() => _AspectRatioScreenState();
}

class _AspectRatioScreenState extends State<AspectRatioScreen> {
  String selected = "Default";
  List<String> aspectRatios = ["Default", "1:1", "4:3", "16:9"];

  @override
  void initState() {
    selected = AppConfig.imageAspectRatio;
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
            "Aspect Ratio",
            style: TextStyle(color: MyTheme.white),
          ),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: const Text('Select aspect ratio for capture images',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
            ),
            ListView.builder(
                itemExtent: 40,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: aspectRatios.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // dense: true,
                    visualDensity: VisualDensity(vertical: -4),
                    // minVerticalPadding: 0,
                    onTap: () {
                      setState(() {
                        selected = aspectRatios[index];
                      });
                    },
                    title: Row(
                      children: <Widget>[
                        Radio(
                          value: aspectRatios[index],
                          groupValue: selected,
                          onChanged: (value) {
                            setState(() {
                              selected = value.toString();
                            });
                          },
                        ),
                        Text(aspectRatios[index]),
                      ],
                    ),
                  );
                }),
            Container(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  AppConfig.imageAspectRatio = selected;
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
