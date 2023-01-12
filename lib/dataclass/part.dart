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
  int qty = 1;

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

  @HiveField(17)
  late List<String> imgList = [];

  bool forUpload = false;
  bool status = false;
  String partId = "";

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
    return Part(
        0,
        json["PartName"],
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
      "PartLocation": defaultLocation,
      "PartDescription": defaultDescription,
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
}
