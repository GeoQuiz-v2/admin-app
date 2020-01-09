import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';

class DifficultyPicker extends FormField<int> {
  static final min = 1;
  static final max = 5;

  final DifficultyPickerController controller;
  
  DifficultyPicker({@required this.controller}) : super(
    builder: (state) => _DifficultyPickerWidget(
      onIncrease : () {
        (state as _DifficultyPickerState).increase();
      },
      onDecrease: () {
        (state as _DifficultyPickerState).decrease();
      },
      controller: controller,
      min: min,
      max: max,
      state: state,
    ),
    validator: (value) => value != null && value >=1 && value <= 5 ? null : "invalid"

  );

  @override
  FormFieldState<int> createState() {
    return _DifficultyPickerState();
  }
}


class _DifficultyPickerWidget extends StatefulWidget {

  final int min;
  final int max;

  final DifficultyPickerController controller;

  final Function onIncrease;
  final Function onDecrease;

  final _DifficultyPickerState state;


  _DifficultyPickerWidget({this.onIncrease, this.onDecrease, this.controller, this.min = 0, this.max = 100, this.state});

  @override
  _DifficultyPickerWidgetState createState() => _DifficultyPickerWidgetState();
}


class _DifficultyPickerWidgetState extends State<_DifficultyPickerWidget> {

  int get difficulty => widget.controller.value;
  final iconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            InkWell(
              child: Icon(Icons.remove, size: iconSize, color: AppColors.textColorLight,), 
              onTap: () {
                if (difficulty != null && difficulty > widget.min) {
                  setState(() => widget.onDecrease());
                }
              }
            ),
            Text(difficulty?.toString()??"?", style: TextStyle(fontSize: 16, color: difficulty == null ? AppColors.textColorLight : AppColors.textColor),),
            InkWell(
              child: Icon(Icons.add, size: iconSize, color: AppColors.textColorLight,), 
              onTap: () {
                if (difficulty == null || difficulty < widget.max) {
                  setState(() => widget.onIncrease());
                }
              }, 
            ),
          ]
        ),
        if (widget.state.hasError)
          Text("Invalid", style: Theme.of(context).inputDecorationTheme.errorStyle)
      ],
    );
  }
}


class _DifficultyPickerState extends FormFieldState<int> {

  @override
  DifficultyPicker get widget => super.widget;

  increase() {
    if (widget.controller.value == null)
      widget.controller.value = 1;
    else
      widget.controller.value++;
    this.setValue(widget.controller.value);
  }

  decrease() {
    if (widget.controller.value == null)
      widget.controller.value = 1;
    else
      widget.controller.value--;
    this.setValue(widget.controller.value);
  }
}


class DifficultyPickerController {
  int value;

  DifficultyPickerController({int selectedValues}) : value = selectedValues;
}