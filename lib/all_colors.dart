import 'package:flutter/material.dart';

final List<Color> myColors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
];
final List<Color> myColorsOpa = [
  Colors.red.withOpacity(0.5),
  Colors.pink.withOpacity(0.5),
  Colors.purple.withOpacity(0.5),
  Colors.deepPurple.withOpacity(0.5),
  Colors.indigo.withOpacity(0.5),
  Colors.blue.withOpacity(0.5),
  Colors.lightBlue.withOpacity(0.5),
  Colors.cyan.withOpacity(0.5),
  Colors.teal.withOpacity(0.5),
  Colors.green.withOpacity(0.5),
  Colors.lightGreen.withOpacity(0.5),
  Colors.lime.withOpacity(0.5),
  Colors.yellow.withOpacity(0.5),
  Colors.amber.withOpacity(0.5),
  Colors.orange.withOpacity(0.5),
  Colors.deepOrange.withOpacity(0.5),
  Colors.brown.withOpacity(0.5),
  Colors.grey.withOpacity(0.5),
  Colors.blueGrey.withOpacity(0.5),
];

List<Color> generateColorList(Color startColor, Color endColor, int steps) {
  final double stepR = (endColor.red - startColor.red) / (steps - 1);
  final double stepG = (endColor.green - startColor.green) / (steps - 1);
  final double stepB = (endColor.blue - startColor.blue) / (steps - 1);

  List<Color> colorList = [];
  for (int i = 0; i < steps; i++) {
    int red = (startColor.red + stepR * i).round();
    int green = (startColor.green + stepG * i).round();
    int blue = (startColor.blue + stepB * i).round();
    colorList.add(Color.fromRGBO(red, green, blue, 1));
  }

  return colorList;
}
