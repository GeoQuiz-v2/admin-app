
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/models.dart';

class QuestionsProvider extends ChangeNotifier {

  List<Language> supportedLanguage;
  List<QuizTheme> themes;
  List<Question> questions;

  Language _currentSelectedLanguage;

  Language get currentSelectedLanguage => _currentSelectedLanguage;
  set currentSelectedLanguage(l) {
    _currentSelectedLanguage = l;
    notifyListeners();
  }

  QuestionsProvider() {
    supportedLanguage = [Language("fr"), Language("en")];
    currentSelectedLanguage = supportedLanguage.first;
  }
  

  Future<void> addSupportedLanguage(Language l) async {
    supportedLanguage.add(l);
    await Future.delayed(const Duration(seconds: 2), (){print("ok");});
    notifyListeners();
  }


  addTheme() {

  }

  updateTheme() {

  }

  removeTheme() {

  }

  addQuestion() {

  }

  updateQuestion() {

  }

  removeQuestion() {

  }

}