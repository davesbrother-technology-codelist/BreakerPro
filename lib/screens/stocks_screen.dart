import 'package:flutter/material.dart';

import '../dataclass/part.dart';
import '../dataclass/stock.dart';
import '../my_theme.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen(
      {Key? key, required this.stockList, required this.partList})
      : super(key: key);
  final List<Stock> stockList;
  final List<Part> partList;

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  late List<Part> partList;
  late List<Stock> stockList;

  @override
  void initState() {
    partList = widget.partList;
    stockList = widget.stockList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyTheme.materialColor,
          leading: Container(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          title: Text(
            "Stocks",
            style: TextStyle(color: MyTheme.white),
          ),
        ),
        body: ListView.separated(
          itemCount: partList.length,
          itemBuilder: (context, index) {
            Part part = partList[index];
            Stock stock = stockList[index];
            return Container(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                          child: Container(
                            height: 80,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                          child: Text(
                            part.partName,
                          ),
                        ),
                      ),
                    ],
                  ),
                  infoLine("Part Id", stock.stockID),
                  infoLine("Make", stock.make),
                  infoLine("Model", stock.model),
                  infoLine("Year", stock.year),
                  infoLine("Location", stock.vehicleLocation),
                  infoLine("Registration No", stock.reg),
                  infoLine("Price", stock.price),
                  infoLine("Stock Reference", stock.stockRef),
                  infoLine("Manufacture Year", stock.year),
                  infoLine("Marketing", stock.marketing),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              thickness: 2,
              color: MyTheme.materialColor,
            );
          },
        ),
      ),
    );
  }

  Widget infoLine(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 35,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
            child: Text(
              label,
              style: TextStyle(color: MyTheme.materialColor),
            ),
          ),
        ),
        Expanded(
          flex: 65,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
            child: Text(value),
          ),
        ),
      ],
    );
  }
}
