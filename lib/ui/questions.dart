import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/ui/widget/subtitle.dart';

class QuestionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SubTitle("Supported languages"),

        SubTitle("Themes"),

        SubTitle(
          "Questions", 
          action: FlatButton.icon(
            icon: Icon(Icons.warning),
            label: Text("Missing translation"),
            onPressed: () {},
          )
        )
      ],
    );
  }
}