import 'package:admin/components/app_model_edition_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ModelActionsWidget extends StatelessWidget {
  final AppModelEditionDialog dialog;
  final Function onDelete;

  ModelActionsWidget({
    Key key,
    this.dialog,
    this.onDelete
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: Icon(Icons.edit),
          onTap: () {
            dialog.show(context);
          }
        ),
        InkWell(
          child: Icon(Icons.delete),
          onTap: onDelete,
        )
      ],
    );
  }
}