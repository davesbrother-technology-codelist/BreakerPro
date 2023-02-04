class Stock {
  String stockID = "";
  String make = "";
  String model = "";
  String clientID = "";
  String partName = "";
  String year = "";
  String warranty = "";
  String reg = "";
  String price = "";
  String condition = "";
  String details = "";
  String partComments = "";
  String postageRate = "";
  String postageCode = "";
  String marketing = "";
  String vehicleId = "";
  String stockRef = "";
  String fuel = "";
  String bodyStyle = "";
  String vin = "";
  String colour = "";
  String manufacturingYear = "";
  String dateAdded = "";
  String mileage = "";
  String vehicleLocation = "";
  String vehicleCost = "";
  String vehicleDetails = "";
  String engine = "";
  String vehicleThumbnailURLList = "";
  String imageThumbnailURLList = "";
  String thatchamPartManufacturerNumber = "";
  String ebayTitle = "";
  String ebayNumber = "";

  fromJson(Map<String, dynamic> json) {
    stockID = json["StockID"];
    make = json["Make"];
    model = json["Model"];
    clientID = json["ClientID"];
    partName = json["PartName"];
    year = json["Year"];
    warranty = json["Warranty"];
    reg = json["Reg"];
    price = json["Price"];
    condition = json["Condition"];
    details = json["Details"];
    partComments = json["PartComments"];
    postageRate = json["PostageRate"];
    postageCode = json["PostageCode"];
    marketing = json["Marketting"];
    vehicleId = json["VehicleId"];
    stockRef = json["StockRef"];
    fuel = json["Fuel"];
    bodyStyle = json["BodyStyle"];
    vin = json["VIN"];
    colour = json["Colour"];
    manufacturingYear = json["Manufact_year"];
    dateAdded = json["DateAdded"];
    mileage = json["Mileage"];
    vehicleLocation = json["Vehlocation"];
    vehicleCost = json["Vehcost"];
    vehicleDetails = json["Vehdetails"];
    engine = json["Engine"];
    vehicleThumbnailURLList = json["VehiclethumbnailURLlist"];
    imageThumbnailURLList = json["ImageThumbnailURLList"];
    thatchamPartManufacturerNumber = json["Thatcham_PartManufacturerNumber"];
    ebayTitle = json["Ebay_Title"];
    ebayNumber = json["ebay_number"];
  }

  Map<String, dynamic> toJson(){
    return {
      "StockID":stockID,
      "Make":make,
      "Model":model,
      "ClientID":clientID,
      "PartName":partName,
      "Year":year,
      "Warranty":warranty,
      "Reg":reg,
      "Price":price,
      "Condition":condition,
      "Details":details,
      "PartComments":partComments,
      "PostageRate":postageRate,
      "PostageCode":postageCode,
      "Marketting":marketing,
      "VehicleId":vehicleId,
      "StockRef":stockRef,
      "Fuel":fuel,
      "BodyStyle":bodyStyle,
      "VIN":vin,
      "Colour":colour,
      "Manufact_year":manufacturingYear,
      "DateAdded":dateAdded,
      "Mileage":mileage,
      "Vehlocation":vehicleLocation,
      "Vehcost":vehicleCost,
      "Vehdetails":vehicleDetails,
      "Engine":engine,
      "VehiclethumbnailURLlist":vehicleThumbnailURLList,
      "ImageThumbnailURLList":imageThumbnailURLList,
      "Thatcham_PartManufacturerNumber":thatchamPartManufacturerNumber,
      "Ebay_Title":ebayTitle,
      "ebay_number":ebayNumber,
    };
  }
}
