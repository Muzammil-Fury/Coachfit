import 'package:flutter/material.dart';

class ColorUtils {

  static Color getDynamicBackgroundColor(String char) {
    int charInt = char.codeUnitAt(0);
    const List<Color> colors = [
      Colors.amber,
      Colors.blue,
      Colors.brown,
      Colors.cyan,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.green,
      Colors.indigo,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.lime,
      Colors.orange,
      Colors.pink,
      Colors.purple,
      Colors.red,
      Colors.teal,    
      Colors.yellow,
    ];
    int colorInt = charInt % colors.length; 
    return colors[colorInt];
  }

  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }    


}