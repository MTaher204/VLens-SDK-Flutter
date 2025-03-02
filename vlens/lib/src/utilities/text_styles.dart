import 'dart:ui';
import 'colors.dart';

class CustomTextStyle {

  static TextStyle header = TextStyle(
    fontSize: 24,
    color: UIColors.teal,
    fontWeight: FontWeight.bold,
  );

  static TextStyle body = TextStyle(
      fontSize: 16,
      color: UIColors.stormy,
      fontWeight: FontWeight.w400
  );

  static TextStyle subHeader = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: UIColors.infoBlue900,
  );

  static TextStyle subBody =  TextStyle(
    fontSize: 14,
    color: UIColors.infoBlue500,
    fontWeight: FontWeight.w400,
  );
}