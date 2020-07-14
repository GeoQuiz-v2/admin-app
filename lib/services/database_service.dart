import 'package:admin/models/language_model.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/utils/dao.dart';

abstract class IDatabaseService {
  IDao<QuestionModel> get questionsDao;
  IDao<ThemeModel> get themesDao;
  IDao<LanguageModel> get languagesDao;

  Future upgrade(int oldVersion, int newVersion);
}

class UpgradeOperationNotSupported implements Exception {}