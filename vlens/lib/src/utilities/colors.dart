import 'package:flutter/material.dart';

class UIColors {
  static final primary = hexToColor('397374');
  static final stormy = hexToColor('4E5A78');
  static final infoBlue = hexToColor('88BBEE');
  static final infoBlue50 = hexToColor('EDF5FD');
  static final infoBlue500 = hexToColor('#376DA3');
  static final infoBlue900 = hexToColor('#204061');
  static final teal = hexToColor('#397374');
  static final scanFrame = hexToColor('#F6D47D');
  static final white10 = hexToColor('#FFFFFF1A');
  static final white50 = hexToColor('#FEFEFE');
  static final sandColor = hexToColor('##E0C172');
  static final teal200 = hexToColor('#A4BFBF');
  static final midnightBlue = hexToColor('#131722');
  static final indigo_50 = hexToColor('#1A172280');

}

Color hexToColor(String hexCode) {
  if (!hexCode.startsWith('#')) {
    hexCode = '#$hexCode';
  }
  hexCode = hexCode.replaceAll("#", "");
  if (hexCode.length == 6) {
    hexCode = "FF$hexCode";
  }
  try{
    return Color(int.parse(hexCode, radix: 16));
  }catch(e){
    return Colors.transparent;
  }

}


