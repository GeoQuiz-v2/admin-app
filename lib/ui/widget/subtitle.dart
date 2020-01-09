import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/values.dart';

class SubTitle extends StatelessWidget {
  final Widget action;
  final String text;
  final bool first;

  SubTitle(this.text, {this.action, this.first = false});
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: first ? 0 : Values.blockSpacing, bottom: Values.normalSpacing),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.start,
        children: <Widget>[
          Text(
            text.toUpperCase(),
            style: TextStyle(fontSize: Values.pageSubtitle, fontWeight: Values.weightBold),
          ),
          SizedBox(width: 20,),
          if (action != null)
            action,
        ],
      ),
    );
  }
}