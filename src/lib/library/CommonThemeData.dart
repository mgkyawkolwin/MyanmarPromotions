import 'package:flutter/material.dart';

class CommonThemeData
{

  static const Color AppBarBackgroundColor = Colors.red;
  static Color AppBarForegroundColor = Colors.white;

  static MaterialStateProperty<Color> ButtonBackgroundColor = MaterialStateProperty.all(Colors.redAccent);
  static MaterialStateProperty<Color> ButtonForegroundColor = MaterialStateProperty.all(Colors.white);
  static MaterialStateProperty<Size> ButtonMinimumSize = MaterialStateProperty.all(Size.fromHeight(50));
}