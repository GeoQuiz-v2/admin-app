
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/models.dart';

class QuestionsProvider extends ChangeNotifier {

  fs.Firestore firestore = fb.firestore();

  final collectionThemes = "themes";
  final collectionQuestions = "questions";

  List<Language> supportedLanguage = [];
  List<QuizTheme> themes = [];
  List<Question> questions = [];

  Language _currentSelectedLanguage;

  Language get currentSelectedLanguage => _currentSelectedLanguage;
  set currentSelectedLanguage(l) {
    _currentSelectedLanguage = l;
    notifyListeners();
  }

  QuestionsProvider() {
    supportedLanguage = [Language("fr"), Language("en")];
    currentSelectedLanguage = supportedLanguage.first;
    init();
  }


  init() {
    firestore.collection(collectionThemes).onSnapshot.listen((querySnap) async {
      themes = [];
      for (fs.DocumentSnapshot docSnap in querySnap.docs) {
        try {
          themes.add(QuizTheme.fromJSON(id: docSnap.id, data: docSnap.data()));
        }catch(e) {print(e.toString());}
      }
      notifyListeners();
    });

    firestore.collection(collectionQuestions).onSnapshot.listen((querySnap) async {
      questions = [];
      for (fs.DocumentSnapshot docSnap in querySnap.docs) {
        try {
          questions.add(Question.fromJSON(id: docSnap.id, data: docSnap.data()));
        }catch(e) {print(e.toString());}
      }
      notifyListeners();
    });
  }
  

  Future<void> addSupportedLanguage(Language l) async {
    supportedLanguage.add(l);
    await Future.delayed(const Duration(seconds: 2), (){print("supported language added (debug)");});
    notifyListeners();
  }


  Future<void> addTheme(QuizTheme t) async {
    await firestore.collection(collectionThemes).add(t.toJSON());
  }

  Future<void> updateTheme(QuizTheme t) async {
    await firestore.collection(collectionThemes).doc(t.id).update(data: t.toJSON());
  }

  Future<void> removeTheme(QuizTheme t) async {
    await firestore.collection(collectionThemes).doc(t.id).delete();
  }

  Future<void> addQuestion(Question q) async {
    await firestore.collection(collectionQuestions).add(q.toJSON());
  }

  Future<void> updateQuestion(Question q) async {
    await firestore.collection(collectionQuestions).doc(q.id).update(data: q.toJSON());
  }

  Future<void> removeQuestion(Question q) async {
    await firestore.collection(collectionQuestions).doc(q.id).delete();
  }

}