import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/models.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/ui/widget/icon_button.dart';




class TypePicker extends FormField<Type> {

  final List<Type> types;
  final TypePickerController controller;
  
  TypePicker({@required this.types,@required this.controller}) : super(
    builder: (state) => _TypePickerWidget(
      types: types,
      controller: controller,
      state: state,
      onSelect: (type) => (state as _TypePickerState).set(type),
    ),
    validator: (_) => controller.value != null ? null : "invalid"

  );

  @override
  FormFieldState<Type> createState() {
    return _TypePickerState();
  }
}


class _TypePickerWidget extends StatefulWidget {


  final TypePickerController controller;

  final Function(Type) onSelect;
  final List<Type> types;
  final _TypePickerState state;


  _TypePickerWidget({@required this.types, this.onSelect, this.controller, this.state});

  @override
  _TypePickerWidgetState createState() => _TypePickerWidgetState();
}


class _TypePickerWidgetState extends State<_TypePickerWidget> {

  Type get selectedType => widget.controller.value;
  set selectedType(t) => widget.controller.value = t;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          children: widget.types.map((t) => 
            RoundedIconButton(
              icon: Icon(t.icon, color: selectedType == t ? AppColors.primary : AppColors.textColorLight),
              onPressed: () {
                setState(() => selectedType = t);
                widget.onSelect(selectedType);
              },
            )
          ).toList(),
        ),
        if (widget.state.hasError)
          Text("Invalid", style: Theme.of(context).inputDecorationTheme.errorStyle,)
      ],
    );
  }
}


class _TypePickerState extends FormFieldState<Type> {

  @override
  void initState() {
    super.initState();
  }

  @override
  TypePicker get widget => super.widget;

  set(Type type) {
    widget.controller.value = type;
  }
}


class TypePickerController {
  Type value;

  TypePickerController({Type initialType}) : value = initialType;
}