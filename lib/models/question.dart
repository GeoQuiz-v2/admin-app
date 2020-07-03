import 'package:admin/models/theme.dart';
import 'package:admin/utils/intl_resource.dart';
import 'package:flutter/foundation.dart';

class QuestionModel {
  String id;
  ThemeModel theme;
  ResourceType entitledType;
  IntlResource entitled;
  ResourceType answersType;
  List<IntlResource> answers;
  int difficulty;

  QuestionModel({
    this.id,
    @required this.theme,
    @required this.entitledType,
    @required this.entitled,
    @required this.answersType,
    @required this.answers,
    @required this.difficulty,
  })
}