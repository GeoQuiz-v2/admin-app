import 'package:admin/models/database_wrapper.dart';
import 'package:admin/models/language_model.dart';
import 'package:admin/models/model.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/services/database_service.dart';
import 'package:admin/services/storage_service.dart';
import 'package:admin/utils/dao.dart';
import 'package:flutter/widgets.dart';

class DatabaseProvider extends ChangeNotifier {
  final IDatabaseService databaseService;
  final IStorageService storageService;

  DatabaseWrapper models;

  DatabaseProvider({
    @required this.databaseService, 
    @required this.storageService
  });

  init() async {
    var questions = {}; 
    var themes = await databaseService.themesDao.list();
    var languages = await databaseService.languagesDao.list();
    models = DatabaseWrapper(
      languages: languages,
      themes: themes,
      questions: questions
    );
    notifyListeners();
  }

  Future saveLanguage(LanguageModel model) async {
    _saveModelsWorker(model, models.languages, databaseService.languagesDao);
  }

  Future saveTheme(ThemeModel model) async {
    _saveModelsWorker(model, models.themes, databaseService.themesDao);
  }

  Future saveQuestion(QuestionModel model) async {
    _saveModelsWorker(model, models.questions, databaseService.questionsDao);
  }

  Future _saveModelsWorker(Model model, Map modelsMap, IDao dao) async {
    String modelId;
    if (model.id == null) {
      modelId = await dao.create(model);
    } else {
      await dao.update(model);
      modelId = model.id;
    }
    modelsMap[modelId] = model;
    notifyListeners();
  }
 
  Future publishDatabase() async {
    await storageService.publishDatabase(models);
  }
}