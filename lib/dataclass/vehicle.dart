class Vehicle {
  int uniqueId = 0;
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
  int uploadStatus = 1;
  int cc = 0;
  List<String> imgList = [];
  String engineCode = "";

  Map<String, String> toJson() {
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
      "toYear": toYear,
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
      "Images": ""
    };
  }
}
