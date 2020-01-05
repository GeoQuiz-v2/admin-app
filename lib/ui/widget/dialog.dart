import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/values.dart';


class AppDialog extends StatefulWidget {

  final String title;
  final Widget content;
  final Future<bool> Function() onSubmit;

  AppDialog({@required this.title, @required this.content, @required this.onSubmit});

  
  @override
  _AppDialogState createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {

  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: Theme.of(context).textTheme.headline,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Values.radius)),
      title: Text(widget.title),
      content: widget.content,
      actions: <Widget>[
        if (!inProgress)
          FlatButton(
            child: Text("Cancel"), 
            onPressed: () => Navigator.pop(context)
          ),
          FlatButton(
            child: Text(inProgress ? "Loading" : "Submit"), 
            onPressed: inProgress ? null : () async {
              setState(() => inProgress = true);
              bool res = await widget.onSubmit();
              setState(() => inProgress = false);
              if (res) 
                Navigator.pop(context);
            }
          )
      ],
    );
  }
}