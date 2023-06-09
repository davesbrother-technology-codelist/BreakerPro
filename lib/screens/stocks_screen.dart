import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/stock_repository.dart';
import '../app_config.dart';
import '../dataclass/part.dart';
import '../dataclass/stock.dart';
import '../my_theme.dart';
import '../utils/auth_utils.dart';
import 'manage_parts2.dart';

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
    return  Scaffold(
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
            List imgList = stock.imageThumbnailURLList.split(',');
            String img = imgList.isNotEmpty ? imgList.first :"";
            return GestureDetector(
              onTap: () async {
                print(part.toStockJson(stock));
                final File file = File(
                    '${AppConfig.externalDirectory!.path}/UPLOAD_MANAGE_PARTS${DateFormat("ddMMyy").format(DateTime.now())}.txt');
                await file.writeAsString(
                    "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())}: onStockSelected ${part.partName}, ${stock.stockID}\n",
                    mode: FileMode.append);
                await findStockFromID(stock.stockID);
              },
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
                            child: Image.network(
                              img,
                              errorBuilder:
                                  (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                          child: Text(
                            part.partName,
                            style: TextStyle(color: MyTheme.materialColor,fontSize: 17.5),
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
                  infoLine("Manufacture Year", stock.manufacturingYear),
                  stock.ebayNumber.isEmpty?
                  infoLine("Marketing", stock.marketing):
                  infoLine2("Marketing", stock.marketing,stock),
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
      );

  }


  Future<void> findStockFromID(String stockID) async {
    final File file = File(
        '${AppConfig.externalDirectory!.path}/UPLOAD_MANAGE_PARTS${DateFormat("ddMMyy").format(DateTime.now())}.txt');

    AuthUtils.showLoadingDialog(context);
    Map<String, dynamic> queryParams = {
      "clientid": AppConfig.clientId,
      "username": AppConfig.username,
      "stockid": stockID,
      "searchby": "part"
    };
    List? responseList = await StockRepository.findStock(queryParams);
    Navigator.pop(context);
    if (responseList == null) {
      await file.writeAsString(
          "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())}: onStockSelected Part Not Found (or not synced)\n",
          mode: FileMode.append);
      Fluttertoast.showToast(msg: "Part Not Found (or not synced)");
      return;
    }
    Stock stock = Stock();
    stock.fromJson(responseList[0]);
    Part part = Part.fromStock(stock);
    part.partId =
    "MNG_PRT_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}";
    print(stock.stockID);
    await file.writeAsString(
        "\n${DateFormat("dd/MM/yy hh:mm:ss").format(DateTime.now())}: onStockSelected Part Found ${part.partName}, ${stock.stockID}\n",
        mode: FileMode.append);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ManageParts2(part: part, stock: stock)));
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
  Widget infoLine2(String label, String value, Stock stock) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(value)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        await launchUrl(
                            Uri.parse(
                                "https://www.ebay.com/itm/${stock.ebayNumber}"),
                            mode: LaunchMode.externalApplication);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.arrowUpRightFromSquare,size: 12,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(stock.ebayNumber,style: TextStyle(fontSize: 12),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Expanded(
        //   flex: 15,
        //   child: Align(
        //     alignment: Alignment.centerRight,
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 8.0),
        //       child: GestureDetector(
        //         onTap: () async {
        //           await launchUrl(Uri.parse("https://www.ebay.com/itm/${stock.ebayNumber}"),mode: LaunchMode.externalApplication);
        //         },
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.end,
        //           children: [
        //             FaIcon(FontAwesomeIcons.arrowUpRightFromSquare,size: 12,),
        //             Expanded(
        //               child: Padding(
        //                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
        //                 child: Text(stock.ebayNumber,style: TextStyle(fontSize: 12),),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
