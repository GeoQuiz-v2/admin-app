import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class RoundedIconButton extends StatelessWidget {

  final Icon icon;
  final Function onPressed;
  final Function onLongPress;

  RoundedIconButton({@required this.icon, @required this.onPressed, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(99),      
      child: Padding(padding: EdgeInsets.all(5) ,child: icon),
      onTap: onPressed,
      onLongPress: onLongPress,
    );
  }
}