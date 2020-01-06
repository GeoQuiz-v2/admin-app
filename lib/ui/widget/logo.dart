import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/values.dart';



class AppLogo extends StatelessWidget {

  final double size;

  AppLogo({this.size});
  
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "GeoQuiz",
        style: Theme.of(context).textTheme.title.copyWith(fontSize: size??Theme.of(context).textTheme.title.fontSize, fontWeight: Values.weightMedium),
        children: [TextSpan(text: " Admin", style: TextStyle(color: Color(0xFF404040)))]
      ),
    );
  }
}