import 'package:admin/models/database_wrapper.dart';
import 'package:admin/models/language_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/services/database_service.dart';
import 'package:admin/services/storage_service.dart';
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
    // var questions = await databaseService.questionsDao.list(); 
    var themes = await databaseService.themesDao.list();
    var languages = await databaseService.languagesDao.list();
    models = DatabaseWrapper(
      languages: languages,
      themes: themes,
      questions: null
    );
    notifyListeners();
  }

  Future saveLanguage(LanguageModel model) async {
    String modelId;
    if (model.id == null) {
      modelId = await databaseService.languagesDao.create(model);
    } else {
      await databaseService.languagesDao.update(model);
      modelId = model.id;
    }
    models.languages[modelId] = model;
    notifyListeners();
  }

  Future saveTheme(ThemeModel model) async {
    String modelId;
    if (model.id == null) {
      modelId = await databaseService.themesDao.create(model);
    } else {
      await databaseService.themesDao.update(model);
      modelId = model.id;
    }
    models.themes[modelId] = model;
    notifyListeners();
  }
}