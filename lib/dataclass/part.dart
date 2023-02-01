import 'package:breaker_pro/dataclass/parts_list.dart';
import 'package:breaker_pro/dataclass/stock.dart';
import 'package:hive/hive.dart';

part 'part.g.dart';

@HiveType(typeId: 0)
class Part {
  @HiveField(0)
  late int id = 0;

  @HiveField(1)
  late String partName;

  @HiveField(2)
  late String partType;

  @HiveField(3)
  late String predefinedList;

  @HiveField(4)
  late String postageOptions;

  @HiveField(5)
  late String defaultLocation;

  @HiveField(6)
  late String defaultDescription;

  @HiveField(7)
  late String postageOptionsCode;

  @HiveField(8)
  late String ebayTitle;

  @HiveField(9)
  bool isSelected = false;

  @HiveField(10)
  late String partCondition = "";

  @HiveField(11)
  double warranty = 0;

  @HiveField(12)
  int qty = 0;

  @HiveField(13)
  late double salesPrice = 0;

  @HiveField(14)
  late double costPrice = 0;

  @HiveField(15)
  late bool isDefault = false;

  @HiveField(16)
  late String mnfPartNo = "";

  @HiveField(17)
  late String comments = "";

  @HiveField(18)
  late List<String> imgList = [];

  @HiveField(19)
  late String partLocation = "";

  @HiveField(20)
  late String description = "";

  @HiveField(21)
  bool forUpload = false;

  @HiveField(22)
  String status = "Uploading";

  @HiveField(23)
  bool isEbay = false;

  @HiveField(24)
  bool isFeaturedWeb = false;

  @HiveField(25)
  String featuredWebDate = "";

  @HiveField(26)
  String partId = "";

  @HiveField(27)
  bool isUploaded = false;

  @HiveField(28)
  bool hasPrintLabel = false;

  @HiveField(29)
  bool isDelete = false;

  Part(
      this.id,
      this.partName,
      this.partType,
      this.predefinedList,
      this.postageOptions,
      this.defaultLocation,
      this.defaultDescription,
      this.postageOptionsCode,
      this.ebayTitle);

  static Part fromJson(Map<String, dynamic> json) {
    String name = json["PartName"];
    name = name.replaceAll("&amp;", "&");
    return Part(
        0,
        name,
        json["PartType"],
        json["PredefinedLists"],
        json["PostageOptions"],
        json["DefaultLocation"],
        json["DefaultDescription"],
        json["PostageOptionsCode"],
        json["EbayTitle"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "PartID": partId,
      "PartName": partName,
      "PartType": partType,
      "PostageRate": postageOptions,
      "PartLocation": isDefault ? defaultLocation : partLocation,
      "PartDescription": isDefault ? defaultDescription : description,
      "PostageCode": postageOptionsCode,
      "Ebay_Title": ebayTitle,
      "PartCondition": partCondition,
      "warranty": warranty.toString(),
      "Qty": qty.toString(),
      "PartSellPrice": salesPrice.toString(),
      "costPrice": costPrice.toString(),
      "ManPartNo": mnfPartNo,
      "PartComments": comments,
      "status": status.toString()
    };
  }

  Map<String, dynamic> toStockJson(Stock stock) {
    return {
      "PartID": partId,
      "BPPartID": stock.stockID,
      "PartName": partName,
      "PartType": partType,
      "PartSellPrice": salesPrice.toString(),
      "PartCondition": partCondition,
      "PartLocation": isDefault ? defaultLocation : partLocation,
      "PartDescription": isDefault ? defaultDescription : description,
      "PartComments": comments,
      "Marketing": isEbay ? "Ebay," : "",
      "PartImageFiles": "",
      "PostageRate": postageOptions,
      "PostageCode": postageOptionsCode,
      "Qty": qty.toString(),
      "ManPartNo": mnfPartNo,
      "Images": "",
      "PrintLabel": hasPrintLabel ? "1" : "0",
      "warranty": warranty.toString(),
      "Ebay_Title": ebayTitle,
      "status": status.toString(),
      "DeletePart": isDelete ? "1" : "0"
    };
  }

  static Part fromStock(Stock stock) {
    Part part = Part(0, stock.partName, "", "", "", "", stock.details,
        stock.postageCode, stock.ebayTitle);
    part.partCondition = stock.condition;
    part.warranty = stock.warranty != "" ? double.parse(stock.warranty) : 0;
    part.salesPrice = stock.price != "" ? double.parse(stock.price) : 0;
    part.comments = stock.partComments;
    part.mnfPartNo = stock.thatchamPartManufacturerNumber;
    part.defaultDescription = stock.details;

    return part;
  }

  String addLog() {
    String m =
        "PartID : $partId\nPartName : $partName\nPartType : $partType\nSellPrice : $salesPrice\nCostPrice : $costPrice\nQuantity : $costPrice\nCondition : $costPrice\nLocation : ${isDefault ? defaultLocation : partLocation}\nDescription : ${isDefault ? defaultDescription : description}\nSetDefault : $isDefault\nComment : $comments\nPostageOptions : $postageOptions\nPostageCode: $postageOptionsCode\nEbay : $isEbay\nImage Name : $imgList\nmanPartNo : $mnfPartNo\nFeatured Web : $isFeaturedWeb\nFeatured Web Date : $featuredWebDate\n";

    return m;
  }

  String addStockLog(Stock stock) {
    String m =
        "PartID : $partId\nBPPartID: ${stock.stockID}\nPartName : $partName\nPartType : $partType\nPartSellPrice : $salesPrice\nPartCondition : $costPrice\nPartLocation : ${isDefault ? defaultLocation : partLocation}\nPartDescription : ${isDefault ? defaultDescription : description}\nPartComments : $comments\nMarketing: ${isEbay ? "Ebay," : ""}\nPartImageFiles: $imgList\nPostageRate : $postageOptions\nPostageCode: $postageOptionsCode\nQty : $costPrice\nManPartNo : $mnfPartNo\nPrintLabel: ${hasPrintLabel ? "1" : "0"}\nDeletePart: ${isDelete ? "1" : "0"}\n";

    return m;
  }
}
