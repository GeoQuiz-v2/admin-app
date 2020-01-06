import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/form_field.dart';


class FormDialog extends StatefulWidget {

  final String title;
  final String label;
  final Future<bool> Function(String) onSubmit;
  final String Function(String) validator;

  FormDialog({@required this.title, @required this.label, @required this.onSubmit, this.validator});

  
  @override
  _FormDialogState createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {

  bool inProgress = false;

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

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
            validator: widget.validator??((value) => value.isNotEmpty ? null : "2 characters only."),
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