import 'package:hive/hive.dart';

part 'part.g.dart';

@HiveType(typeId: 0)
class Part {
  @HiveField(0)
  late int id;

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
  late String partCondition;

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
  late int mnfPartNo = 0;

  @HiveField(17)
  late String comments;

  @HiveField(17)
  late List<String> imgList;

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
      "id": id.toString(),
      "partName": partName,
      "partType": partType,
      "predefinedList": predefinedList,
      "postageOptions": postageOptions,
      "defaultLocation": defaultLocation,
      "defaultDescription": defaultDescription,
      "postageOptionsCode": postageOptionsCode,
      "ebayTitle": ebayTitle,
      "isSelected": isSelected,
      "partCondition": partCondition,
      "warranty": warranty,
      "qty": qty,
      "salesPrice": salesPrice,
      "costPrice": costPrice,
      "isDefault": isDefault,
      "mnfPartNo": mnfPartNo,
      "comments": comments,
    };
  }
}
