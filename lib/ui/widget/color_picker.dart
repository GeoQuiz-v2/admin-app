import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';

class ColorPicker extends StatefulWidget {

  final int color;
  final TextEditingController controller;

  ColorPicker({this.color, this.controller});

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {

  Color color;
  bool invalid = false;

  TextEditingController _colorController;

  @override
  void initState() {
    super.initState();
    _colorController = widget.controller??TextEditingController();
    if (widget.color != null) {
      updateColorIfPossible(widget.color.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Values.radius), 
            color: invalid ? AppColors.error : color??AppColors.textColorLight),
        ),
        SizedBox(child: SizedBox(width:Values.normalSpacing)),
        SizedBox(
          width: 100,
          child: TextFormField(
            controller: _colorController,
            decoration: InputDecoration.collapsed(hintText: "Color"),
            validator: (intColor) {
              updateColorIfPossible(intColor);
              return invalid || color == null ? "Invalid color" : null;
            },
            
            onChanged: updateColorIfPossible,
          ),
        ),
      ],
    );
  }

  updateColorIfPossible(String intColor) {
    try {
      Color c = Color(int.parse(intColor));
      setState(() {
        invalid = false;
        color = c;
      });
    } catch (e) {
      setState(() {
        invalid = true;
      });
    }
  }
}