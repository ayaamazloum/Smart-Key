import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/cupertino.dart';

Color primaryColor = HexColor('#53BC9D');
Color secondaryColor = HexColor('#373737');
Color tertiaryColor = HexColor('#FEDF57');

String apiUrl='http://192.168.0.107:8000/api';

double screenHeight (BuildContext context) {
  return MediaQuery.of(context).size.height;
}
double screenWidth (BuildContext context) {
  return MediaQuery.of(context).size.width;
}