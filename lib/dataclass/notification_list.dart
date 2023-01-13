import 'package:breaker_pro/dataclass/part.dart';
import 'package:breaker_pro/dataclass/vehicle.dart';
import 'package:flutter/cupertino.dart';

class NotificationList extends ChangeNotifier {
  Vehicle? vehicle;
  List<Part> partList = [];
}
