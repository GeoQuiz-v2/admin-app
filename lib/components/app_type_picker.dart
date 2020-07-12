import 'package:admin/utils/resource_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';




class AppTypePicker extends FormField<Type> {

  final List<ResourceType> types;
  final TypePickerController controller;
  
  AppTypePicker({
    this.types,
    @required this.controller
  }) : 
  super(
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
  final Function(ResourceType) onSelect;
  final List<ResourceType> types;
  final _TypePickerState state;

  _TypePickerWidget({@required this.types, this.onSelect, this.controller, this.state});

  @override
  _TypePickerWidgetState createState() => _TypePickerWidgetState();
}


class _TypePickerWidgetState extends State<_TypePickerWidget> {
  ResourceType get selectedType => widget.controller.value;
  set selectedType(t) => widget.controller.value = t;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          children: widget.types.map((t) => 
            InkWell(
              child: Container(
                color: selectedType == t ? Colors.green : Colors.grey,
                child: Text(t.label),
              ),
              onTap: () {
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
  AppTypePicker get widget => super.widget;

  set(ResourceType type) {
    widget.controller.value = type;
  }
}


class TypePickerController {
  ResourceType value;

  TypePickerController({ResourceType initialType}) : value = initialType;
}