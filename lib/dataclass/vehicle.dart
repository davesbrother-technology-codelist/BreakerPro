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

  Map<String, String> toJson() {
    return {
      "uniqueId": uniqueId.toString(),
      "vehicleId": vehicleId,
      "registrationNumber": registrationNumber,
      "stockReference": stockReference,
      "engineCapacity": engineCapacity,
      "fuel": fuel,
      "make": make,
      "model": model,
      "colour": colour,
      "bodyStyle": bodyStyle,
      "vin": vin,
      "manufacturingYear": manufacturingYear,
      "fromYear": fromYear,
      "toYear": toYear,
      "onSiteDate": onSiteDate,
      "mileage": mileage,
      "costPrice": costPrice,
      "commentDetails": commentDetails,
      "location": location,
      "type": type,
      "doors": doors,
      "transmission": transmission,
      "ebayMake": ebayMake,
      "ebayModel": ebayModel,
      "ebayColor": ebayColor,
      "ebayStyle": ebayStyle,
      "ebayEngine": ebayEngine,
      "collectiondate": collectiondate,
      "depollutiondate": depollutiondate,
      "coddate": coddate,
      "weight": weight,
      "uploadStatus": uploadStatus.toString(),
    };
  }
}
