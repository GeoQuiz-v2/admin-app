import 'package:flutter/widgets.dart';

class AppSubtitle extends StatelessWidget {

  final Text child;
  final List<Widget> trailing;

  AppSubtitle({
    Key key,
    @required this.child,
    this.trailing
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        child,
        ...trailing
      ],
    );
  }
}