import 'package:admin/models/language.dart';
import 'package:admin/models/question.dart';
import 'package:admin/models/theme.dart';
import 'package:flutter/foundation.dart';

class DatabaseWrapper {
  List<LanguageModel> languages;
  List<QuestionModel> questions;
  List<ThemeModel> themes;

  DatabaseWrapper({
    @required this.languages,
    @required this.questions,
    @required this.themes,
  })
}