import 'package:admin/models/database_wrapper.dart';
import 'package:admin/services/database_service.dart';
import 'package:admin/services/translation_service.dart';
import 'package:flutter/widgets.dart';

enum TranslationProviderState {
  idle,
  busy,
}

class TranslationProvider extends ChangeNotifier {
  final ITranslationService translationService;
  final IDatabaseService databaseService;

  TranslationProviderState _state = TranslationProviderState.idle;
  TranslationProviderState get state => _state;
  set state(TranslationProviderState newState) {
    _state = newState;
    notifyListeners();
  }

  TranslationProvider({
    @required this.translationService,
    @required this.databaseService,
  });

  Future generateTranslatation(DatabaseWrapper database) async {
    state = TranslationProviderState.busy;
    try {
      var languages = database.languages.values.map((e) => e.isoCode2).toList();
      for (var theme in database.themes.values) {
        await translationService.translate(theme.name, languages);
        await translationService.translate(theme.entitled, languages);
        databaseService.themesDao.update(theme);
      }
      for (var question in database.questions.values) {
        await translationService.translate(question.entitled, languages);
        for (var answer in question?.answers??[]) {
          await translationService.translate(answer, languages);
        } 
        databaseService.questionsDao.update(question);
      }
    } catch (err) {
      print(err);
    }
    state = TranslationProviderState.idle;
  }
}