import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/form_field.dart';
import 'package:geoquizadmin/ui/widget/icon_button.dart';




class TextFieldDialog extends FormField<String> {

  final String title;
  final String label;
  final Future<bool> Function(String) onSubmit;
  final String Function(String) customValidator;

  TextFieldDialog({@required IconData icon, @required this.title, @required this.label, @required this.onSubmit, this.customValidator, TextEditingController controller}) 
  : super(
      builder: (state) => 
        RoundedIconButton(
          icon: Icon(icon, color: state.hasError ? AppColors.error : AppColors.textColorLight),
          onPressed: () {
            showDialog(
              context: state.context,
              builder: (context) => FormDialog(
                label: label,
                title: title,
                controller: controller,
                onSubmit: (value) async => true,
              )
            );
          },
        ),
        validator: (_) {
          if (controller != null && customValidator != null) 
            return customValidator(controller.text);
          return null;
        },
        
  );

}


class FormDialog extends StatefulWidget {

  final String title;
  final String label;
  final Future<bool> Function(String) onSubmit;
  final String Function(String) validator;
  final TextEditingController controller;

  FormDialog({@required this.title, @required this.label, @required this.onSubmit, this.validator, this.controller});

  
  @override
  _FormDialogState createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {

  bool inProgress = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = widget.controller??TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: Theme.of(context).textTheme.headline,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Values.radius)),
      title: Text(widget.title),
      content: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: RoundedTextFormField(
            hint: widget.label,
            controller: _textController,
            validator: widget.validator??((value) => value.isNotEmpty ? null : "Invalid input"),
          )
        ),
      ),
      actions: <Widget>[
        if (!inProgress)
          FlatButton(
            child: Text("Cancel"), 
            onPressed: () => Navigator.pop(context)
          ),
          FlatButton(
            child: Text(inProgress ? "Loading" : "Submit"), 
            onPressed: inProgress ? null : () async {
              if (_formKey.currentState.validate()) {
                setState(() => inProgress = true);
                bool res = await widget.onSubmit(_textController.text);
                setState(() => inProgress = false);
                if (res) 
                  Navigator.pop(context);
              }
            }
          )
      ],
    );
  }
}