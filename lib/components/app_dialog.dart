import 'package:flutter/widgets.dart';

class AppDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final Widget bottom;

  AppDialog({
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