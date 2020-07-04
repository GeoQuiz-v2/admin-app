import 'package:admin/models/model.dart';
import 'package:admin/utils/intl_resource.dart';
import 'package:flutter/foundation.dart';

class QuestionModel extends Model {
  String id;
  String theme;
  ResourceType entitledType;
  IntlResource entitled;
  ResourceType answersType;
  List<IntlResource> answers;
  int difficulty;

  QuestionModel({
    String id,
    @required this.theme,
    @required this.entitledType,
    @required this.entitled,
    @required this.answersType,
    @required this.answers,
    @required this.difficulty,
  }) : super(id);
}