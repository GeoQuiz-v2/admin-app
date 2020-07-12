import 'package:flutter/widgets.dart';

class AppWindow extends StatelessWidget {
  final Widget title;
  final Widget content;
  final Widget bottom;

  AppWindow({
    Key key,
    @required this.title,
    @required this.content,
    @required this.bottom,
  }) : super(key: key);
  
  double calculateWidth(context) {
    double maxWidth = 750;
    double availableWidth = MediaQuery.of(context).size.width - 60; // 60 = margin
    return availableWidth < maxWidth ? availableWidth : maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: calculateWidth(context),
      child: Column(
        children: [
          title,
          Expanded(child: SingleChildScrollView(child: content)),
          bottom,
        ],
      ),
    );
  }
}