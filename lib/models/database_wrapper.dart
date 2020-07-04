import 'package:admin/models/language_model.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:flutter/foundation.dart';

class DatabaseWrapper {
  Map<String, LanguageModel> languages;
  Map<String, QuestionModel> questions;
  Map<String, ThemeModel> themes;

  DatabaseWrapper({
    @required this.languages,
    @required this.questions,
    @required this.themes,
  });
}