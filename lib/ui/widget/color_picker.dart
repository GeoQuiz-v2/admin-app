import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:tinycolor/tinycolor.dart';

class ColorPicker extends StatefulWidget {

  final int color;
  final TextEditingController controller;

  ColorPicker({this.color, this.controller});

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  
  TextEditingController _colorController;


  @override
  void initState() {
    super.initState();
    _colorController = widget.controller??TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Values.radius),
        color: getBackgroundTextField(),
      ),
      padding: EdgeInsets.only(left: 12),
      child: Row(
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Values.radius), 
              color: getColor()??AppColors.textColorLight),
          ),
          SizedBox(child: SizedBox(width:Values.normalSpacing)),
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: _colorController,
              decoration: InputDecoration.collapsed(hintText: "Color"),
              style: TextStyle(color: getColor()??AppColors.textColor, fontSize: 14, fontWeight: Values.weightBold),
              validator: (intColor) => getColor() == null ? "Invalid color" : null,
              onChanged: (_) => setState(() => null),
            ),
          ),
        ],
      ),
    );
  }


  Color getBackgroundTextField() {
    Color c = getColor();
    if (c == null || TinyColor(c).getBrightness() < 170.0) {
      return Colors.transparent;
    }
    return Colors.black;
  }

  Color getColor() {
    if (widget.controller?.text?.length != 10)
      return null;
    try {
      Color c = Color(int.parse(widget.controller.text));
      return c;
    } catch (e) {
      return null;
    }
  }
}