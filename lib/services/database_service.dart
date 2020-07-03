import 'package:admin/models/language.dart';
import 'package:admin/models/question.dart';
import 'package:admin/models/theme.dart';
import 'package:admin/utils/dao.dart';

abstract class IDatabaseService {
  IDao<QuestionModel> get questionsDao;
  IDao<ThemeModel> get themesDao;
  IDao<LanguageModel> get languagesDao;
}

