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
}