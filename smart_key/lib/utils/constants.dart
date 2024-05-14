import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/cupertino.dart';

Color primaryColor = HexColor('#53BC9D');
Color secondaryColor = HexColor('#373737');
Color tertiaryColor = HexColor('#FEDF57');
Color buttonPressColor = HexColor('#265849');

String apiUrl = 'http://192.168.1.5:8000/api';
String serverImagesUrl = 'http://192.168.1.5:8000/profile_pictures';
String streamUrl = 'http://192.168.1.17:81/stream';

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
