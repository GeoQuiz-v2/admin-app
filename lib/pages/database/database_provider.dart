import 'package:admin/models/database_wrapper.dart';
import 'package:admin/models/language_model.dart';
import 'package:admin/models/model.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/services/database_service.dart';
import 'package:admin/services/storage_service.dart';
import 'package:admin/utils/dao.dart';
import 'package:flutter/widgets.dart';

enum DatabaseProviderState {
  idle,
  busy,
}


class DatabaseProvider extends ChangeNotifier {
  final IDatabaseService databaseService;
  final IStorageService storageService;

  DatabaseWrapper models;
  List<LanguageModel> get languages => models?.languages?.values?.toList();
  List<ThemeModel> get themes => models?.themes?.values?.toList();
  List<QuestionModel> get questions => models?.questions?.values?.where((q) => q.theme == selectedTheme?.id)?.toList();

  ThemeModel _selectedTheme;
  ThemeModel get selectedTheme => _selectedTheme;
  set selectedTheme(ThemeModel t) {
    _selectedTheme = t;
    notifyListeners();
  }

  DatabaseProviderState _state = DatabaseProviderState.idle;
  DatabaseProviderState get state => _state;
  set state(DatabaseProviderState newState) {
    _state = newState;
    notifyListeners();
  }

  DatabaseProvider({
    @required this.databaseService, 
    @required this.storageService,
  });

  load() async {
    state = DatabaseProviderState.busy;
    var questions = await databaseService.questionsDao.list();
    var themes = await databaseService.themesDao.list();
    var languages = await databaseService.languagesDao.list();
    models = DatabaseWrapper(
      languages: languages,
      themes: themes,
      questions: questions
    );
    state = DatabaseProviderState.idle;
  }

  Future saveLanguage(LanguageModel model) async {
    _saveModelWorker(model, models.languages, databaseService.languagesDao);
  }

  Future saveTheme(ThemeModel model) async {
    _saveModelWorker(model, models.themes, databaseService.themesDao);
  }

  Future saveQuestion(QuestionModel model) async {
    _saveModelWorker(model, models.questions, databaseService.questionsDao);
  }

  Future deleteLanguage(LanguageModel model) async {
    _deleteModelWorker(model, models.languages, databaseService.languagesDao);
  }

  Future deleteTheme(ThemeModel model) async {
    _deleteModelWorker(model, models.themes, databaseService.themesDao);
  }

  Future deleteQuestion(QuestionModel model) async {
    _deleteModelWorker(model, models.questions, databaseService.questionsDao);
  }


  Future _saveModelWorker(Model model, Map modelsMap, IDao dao) async {
    state = DatabaseProviderState.busy;
    String modelId;
    if (model.id == null) {
      modelId = await dao.create(model);
      model.id = modelId;
    } else {
      await dao.update(model);
      modelId = model.id;
    }
    modelsMap[modelId] = model;
    state = DatabaseProviderState.idle;
  }

  Future _deleteModelWorker(Model model, Map modelsMap, IDao dao) async {
    state = DatabaseProviderState.busy;
    dao.delete(model);
    modelsMap.remove(model.id);
    state = DatabaseProviderState.idle;
  }
 
  Future publishDatabase() async {
    state = DatabaseProviderState.busy;
    await storageService.publishDatabase(models);
    state = DatabaseProviderState.idle;
  }
}