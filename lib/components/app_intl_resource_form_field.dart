import 'package:admin/utils/intl_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class IntlResourceFormField extends FormField<IntlResource> {
  final IntlResourceEditingController controller;

  IntlResourceFormField({
    Key key,
    Function(IntlResource resource) validator,
    @required List<String> languages,
    @required this.controller,
  }) : super(
    key: key,
    validator: validator,
    builder: (FormFieldState<IntlResource> field) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(flex: 1, child: Text("WikiCode")),
              Expanded(
                flex: 10,
                child: TextField(
                  controller: TextEditingController(
                    text: controller.resource.wikidataCode??"",
                  ),
                  onChanged: (v) => controller.resource.wikidataCode = v,
                ),
              )
            ],
          ),
          ...languages.map((l) => Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(l)
              ),
              Expanded(
                flex: 10,
                child: TextField(
                  controller: TextEditingController(
                    text: controller.resource.resource[l]??"",
                  ),
                  onChanged: (v) {
                    controller.resource.resource[l] = v;
                  },
                ),
              ),
            ],
          )).toList(),
        ]
      );
    }
  );

  @override
  _IntlResourceFormFieldState createState() => _IntlResourceFormFieldState();
}


class _IntlResourceFormFieldState extends FormFieldState<IntlResource> {
  @override
  IntlResourceFormField get widget => super.widget as IntlResourceFormField;

  @override
  void initState() {
    super.initState();
    if (widget.controller.resource == null) {
      widget.controller.resource = IntlResource(resource: {});
    }
    if (widget.controller.resource.resource == null) {
      widget.controller.resource.resource = {};
    }
  }
}


class IntlResourceEditingController {
  IntlResource resource;
  IntlResourceEditingController({this.resource});
}