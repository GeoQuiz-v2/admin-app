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
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title,
        content,
        bottom,
      ],
    );
  }
}