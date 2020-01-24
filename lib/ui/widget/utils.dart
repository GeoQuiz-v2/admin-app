import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


String Function(String) basicValidator = (value) => value == null || value.isEmpty ? "Invalid" : null;

class BasicScrollWithoutGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}


// source : https://stackoverflow.com/questions/58360989/programmatically-lighten-or-darken-a-hex-color-in-dart
class ColorTransformation {
  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}


class SnackBarFactory {

  SnackBarFactory._();
  
  static showSuccessSnackbar({@required context, @required message}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      )
    );
  }

  static showErrorSnabar({@required context, @required message}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      )
    );
  }
}


/// As flutter_svg does NOT support web for now : https://github.com/dnfield/flutter_svg/issues/173
class SvgPictureForWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}