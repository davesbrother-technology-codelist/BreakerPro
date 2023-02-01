class workOrder{
  String clientid='';
  String woType='';
  String woDateTime='';
  String woNumber='';
  String woStatus='';
  String woDetails='';
  String woCustomerDetails='';
  String woDeliveryDetails='';
  String woShippingDetails='';
  String woVehicleDetails='';
  String woPartId='';
  String woPartName='';
  String woPartLocation='';
  String woImageUrLs='';

  fromJson(Map<String, dynamic> json) {
    clientid= json["Clientid"];
    woType= json["WO_Type"];
    woDateTime= json["WO_DateTime"];
    woNumber= json["WO_Number"];
    woStatus= json["WO_Status"];
    woDetails= json["WO_Details"];
    woCustomerDetails= json["WO_CustomerDetails"];
    woDeliveryDetails= json["WO_DeliveryDetails"];
    woShippingDetails= json["WO_ShippingDetails"];
    woVehicleDetails= json["WO_VehicleDetails"];
    woPartId= json["WO_PartID"];
    woPartName=json["WO_PartName"];
    woPartLocation= json["WO_PartLocation"];
    woImageUrLs= json["WO_ImageURLs"];
  }
}