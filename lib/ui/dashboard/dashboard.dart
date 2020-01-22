import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/dashboard/buttons.dart';




class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: Values.blockSpacing),
        DashboardButtons(),
      ],
    );
  }
}






