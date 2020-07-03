import 'package:admin/utils/intl_resource.dart';
import 'package:flutter/foundation.dart';

class ThemeModel {
  String id;
  IntlResource name;
  IntlResource entitled;
  String svgIcon;
  int color;
  int priority;

  ThemeModel({
    this.id,
    @required this.svgIcon,
    @required this.name,
    @required this.color,
    @required this.entitled,
    @required this.priority
  })
}