import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tinycolor/tinycolor.dart';


class ColorPicker extends FormField<int> {
  final ColorEditingController controller;

  static Color getBackgroundTextField(int value) {
    Color c = getColor(value);
    if (c == null || TinyColor(c).getBrightness() < 170.0) {
      return Colors.transparent;
    }
    return Colors.black;
  }

  static Color getColor(int value) {
    if (value.toString().length != 10) return null;
    try {
      Color c = Color(value);
      return c;
    } catch (e) {
      return null;
    }
  }

  ColorPicker({
    Key key,
    Function(int) validator,
    @required this.controller,
  }) : super(
    key: key,
    validator: validator,
    builder: (FormFieldState<int> field) {
      final state = (field as ColorPickerFormState);
      return Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(Values.radius),
          color: getBackgroundTextField(state.value),
        ),
        padding: EdgeInsets.only(left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(Values.radius), 
                    color: getColor(state.value)??Colors.black),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    // to not move the cursor at the begin of the text field when the field change
                    controller: state.hasChanged ? null : TextEditingController(text: controller.color?.toString()),
                    decoration: InputDecoration.collapsed(hintText: "Color"),
                    style: TextStyle(color: getColor(state.value)??Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                    onChanged: (newValue) {
                      try {
                        int newValueInt = int.parse(newValue);
                        controller.color = newValueInt;
                        state.didChange(newValueInt);
                        state.hasChanged = true;
                      } catch(_) {state.didChange(null);}
                    },
                  ),
                ),
              ],
            ),
            if (state.hasError)
              Text(state.errorText, style: Theme.of(state.context).inputDecorationTheme.errorStyle)
          ]
        ),
      );
    }
  );

  @override
  ColorPickerFormState createState() => ColorPickerFormState();
}


/// Juste a simple state with [hasChanged] attribute
/// Used in the [ColorPicker] controller propertie to prevent the cursor
/// to move at the start of the text field when it changed. 
class ColorPickerFormState extends FormFieldState<int> {
  bool hasChanged = false;
}


class ColorEditingController {
  int color;
  ColorEditingController({this.color});
}