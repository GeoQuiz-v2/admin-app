import 'package:admin/models/model.dart';
import 'package:admin/utils/intl_resource.dart';
import 'package:flutter/foundation.dart';

class ThemeModel extends Model {
  IntlResource name;
  IntlResource entitled;
  String svgIcon;
  int color;
  int priority;

  ThemeModel({
    String id,
    @required this.svgIcon,
    @required this.name,
    @required this.color,
    @required this.entitled,
    @required this.priority
  }) : super(id);
}