import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum AppButtonStyle {
  normal,
  primary,
  ligth,
}

class AppButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final AppButtonStyle style;

  Color backgroundColor(context) {
    switch (style) {
      case AppButtonStyle.primary: return Theme.of(context).colorScheme.primary;
      case AppButtonStyle.normal: return Theme.of(context).colorScheme.surface;
      case AppButtonStyle.ligth: return Colors.transparent;
      default: return Colors.transparent;
    }
  }

  Color textColor(context) {
    switch (style) {
      case AppButtonStyle.primary: return Theme.of(context).colorScheme.onPrimary;
      case AppButtonStyle.normal: return Theme.of(context).colorScheme.onSurface;
      default: return null;
    }
  }

  AppButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.style = AppButtonStyle.normal
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
      color: backgroundColor(context),
      textColor: textColor(context),
    );
  }
}