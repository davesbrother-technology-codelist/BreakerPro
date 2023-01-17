import 'package:breaker_pro/api/api_config.dart';

import 'image_list.dart';

class Vehicle {
  String uniqueId = "0";
  String vehicleId = "";
  String registrationNumber = "";
  String stockReference = "";
  String engineCapacity = "";
  String fuel = "";
  String make = "";
  String model = "";
  String colour = "";
  String bodyStyle = "";
  String vin = "";
  String manufacturingYear = "";
  String fromYear = "";
  String toYear = "";
  String onSiteDate = "";
  String mileage = "";
  String costPrice = "";
  String commentDetails = "";
  String location = "";
  String type = "";
  String doors = "";
  String transmission = "";
  String ebayMake = "";
  String ebayModel = "";
  String ebayColor = "";
  String ebayStyle = "";
  String ebayEngine = "";
  String collectiondate = "";
  String depollutiondate = "";
  String coddate = "";
  String weight = "";
  String uploadStatus = "1";
  String cc = "0";
  List<String> imgList = [];
  String engineCode = "";

  Map<String, dynamic> toJson() {
    return {
      "uniqueId": uniqueId.toString(),
      "VehicleID": vehicleId,
      "Reg": registrationNumber,
      "StockRef": stockReference,
      "engineCapacity": engineCapacity,
      "Fuel": fuel,
      "Make": make,
      "Model": model,
      "Colour": colour,
      "BodyStyle": bodyStyle,
      "VIN": vin,
      "ManYear": manufacturingYear,
      "YearRange": '$fromYear-$toYear',
      "OnsiteDate": onSiteDate,
      "Mileage": mileage,
      "Cost": costPrice,
      "Details": commentDetails,
      "VehLocation": location,
      "type": type,
      "doors": doors,
      "transmission": transmission,
      "Ebay_Make": ebayMake,
      "Ebay_Model": ebayModel,
      "Ebay_Colour": ebayColor,
      "Ebay_Style": ebayStyle,
      "Ebay_CC": ebayEngine,
      "collectiondate": collectiondate,
      "depollutiondate": depollutiondate,
      "coddate": coddate,
      "weight": weight,
      "uploadStatus": uploadStatus.toString(),
      'VehCC': cc.toString(),
      "engine_code": engineCode,
      "Images": imgList
    };
  }

  Vehicle fromJson(Map<String, dynamic> json) {
    uniqueId = json["uniqueId"].toString();
    vehicleId = json["VehicleID"].toString();
    registrationNumber = json["Reg"].toString();
    stockReference = json["StockRef"].toString();
    engineCapacity = json["engineCapacity"].toString();
    fuel = json["Fuel"].toString();
    make = json["Make"].toString();
    model = json["Model"].toString();
    colour = json["Colour"].toString();
    bodyStyle = json["BodyStyle"].toString();
    vin = json["VIN"].toString();
    manufacturingYear = json["ManYear"].toString();
    onSiteDate = json["OnsiteDate"].toString();
    mileage = json["Mileage"].toString();
    costPrice = json["Cost"].toString();
    commentDetails = json["Details"].toString();
    location = json["VehLocation"].toString();
    type = json["type"].toString();
    doors = json["doors"].toString();
    transmission = json["transmission"].toString();
    ebayMake = json["Ebay_Make"].toString();
    ebayModel = json["Ebay_Model"].toString();
    ebayColor = json["Ebay_Colour"].toString();
    ebayStyle = json["Ebay_Style"].toString();
    ebayEngine = json["Ebay_CC"].toString();
    collectiondate = json["collectiondate"].toString();
    depollutiondate = json["depollutiondate"].toString();
    coddate = json["coddate"].toString();
    weight = json["weight"].toString();
    uploadStatus = json["uploadStatus"].toString();
    cc = json['VehCC'].toString();
    engineCode = json["engine_code"].toString();
    // imgList = List<String>.from(json["Images"].toString().split(','));
    return this;
  }

  String addLog() {
    String files = "";
    for (String image in ImageList.uploadVehicleImgList) {
      files += "${image.split("/").last} ,";
    }

    String m =
        "username:${ApiConfig.baseQueryParams['username']} \npassword:${ApiConfig.baseQueryParams['password']} \ndeviceid:${ApiConfig.baseQueryParams['deviceid']} \nSyncDeviceLists:${ApiConfig.baseQueryParams['SyncDeviceLists']} \nappversion:${ApiConfig.baseQueryParams['appversion']} \nosversion:${ApiConfig.baseQueryParams['osversion']} \ndevicename:${ApiConfig.baseQueryParams['devicename']} \nVehicleID:$vehicleId \nReg: $registrationNumber \nStockRef: $stockReference \nMake:$make \nModel:$model \nVehCC: $cc \nFuel:$fuel \nBodyStyle:$bodyStyle \nVIN: $vin \nColour:$colour \nManYear: $manufacturingYear \nYearRange: $fromYear-$toYear\nOnsiteDate:$onSiteDate \nMileage: $mileage \nVehLocation: $location \nCost: $costPrice \nDetails: $commentDetails \nImages: ${files} \nRecallID:  \ncollectiondate: $collectiondate \ndepollutiondate: $depollutiondate \ncoddate: $coddate \nweight:$weight\n";
    return m;
  }
}
