import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/values.dart';

class SubTitle extends StatelessWidget {
  final Widget action;
  final String text;

  SubTitle(this.text, {this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Values.normalSpacing),
      child: Row(
        children: <Widget>[
          Text(
            text.toUpperCase(),
            style: TextStyle(fontSize: Values.pageSubtitle, fontWeight: Values.weightBlack),
          ),
          SizedBox(width: 20,),
          if (action != null)
            action,
        ],
      ),
    );
  }
}