import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/ui/widget/icon_button.dart';


class IntegerSelector extends FormField<int> {

  final IntegerSelectorController controller;
  
  IntegerSelector({@required this.controller}) : super(
    builder: (state) => _DifficultyPickerWidget(
      onIncrease : () {
        (state as _DifficultyPickerState).increase();
      },
      onDecrease: () {
        (state as _DifficultyPickerState).decrease();
      },
      controller: controller,
      state: state,
    ),
    validator: (_) => controller.value != null && controller.value >=1 && controller.value <= 5 ? null : "invalid"

  );

  @override
  FormFieldState<int> createState() {
    return _DifficultyPickerState();
  }
}


class _DifficultyPickerWidget extends StatefulWidget {


  final IntegerSelectorController controller;

  final Function onIncrease;
  final Function onDecrease;

  final _DifficultyPickerState state;


  _DifficultyPickerWidget({this.onIncrease, this.onDecrease, this.controller, this.state});

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
          children: [
            RoundedIconButton(
              icon: Icon(Icons.remove, size: iconSize, color: AppColors.textColorLight,), 
              onPressed: () {
                if (difficulty != null && difficulty > 0) {
                  setState(() => widget.onDecrease());
                }
              }
            ),
            Text(difficulty?.toString()??"?", style: TextStyle(color: difficulty == null ? AppColors.textColorLight : AppColors.textColor),),
            RoundedIconButton(
              icon: Icon(Icons.add, size: iconSize, color: AppColors.textColorLight,), 
              onPressed: () {
                setState(() => widget.onIncrease());
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
  IntegerSelector get widget => super.widget;




  @override
  void initState() {
    super.initState();
    setValue(widget.controller.value);
  }

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


class IntegerSelectorController {
  int value;

  IntegerSelectorController({int selectedValue}) : value = selectedValue;
}