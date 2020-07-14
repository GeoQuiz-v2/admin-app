import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';


class RandomColorGenerator {
  static List<Color> _colors = [
    Colors.red, Colors.teal, Colors.blue, Colors.brown, 
    Colors.cyan, Colors.green, Colors.indigo, Colors.lime, Colors.orange, 
    Colors.pink, Colors.purple
  ];
  static int _last = 0;
  
  static Color generate() {
    _last += 1;
    return _colors.elementAt(_last);
  }
}