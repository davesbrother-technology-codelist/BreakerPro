import 'package:flutter/material.dart';

Map<int, Color> materialColorMap = {
  50: const Color.fromRGBO(238, 180, 22, .1),
  100: const Color.fromRGBO(238, 180, 22, .2),
  200: const Color.fromRGBO(238, 180, 22, .3),
  300: const Color.fromRGBO(238, 180, 22, .4),
  400: const Color.fromRGBO(238, 180, 22, .5),
  500: const Color.fromRGBO(238, 180, 22, .6),
  600: const Color.fromRGBO(238, 180, 22, .7),
  700: const Color.fromRGBO(238, 180, 22, .8),
  800: const Color.fromRGBO(238, 180, 22, .9),
  900: const Color.fromRGBO(238, 180, 22, 1.0),
};

class MyTheme {
  static MaterialColor materialColor =
      MaterialColor(0xffeeb416, materialColorMap);
  static Color white = Colors.white;
  static Color blue = Colors.blue;
  static Color black = Colors.black;
  static Color black12 = Colors.black12;
  static Color black54 = Colors.black54;
  static Color grey = Colors.grey;
  static Color greenWhatsapp = const Color(0xFF3EA42E);
  static Color redLiveChat = const Color(0xFFFC6602);
}
