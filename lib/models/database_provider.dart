import 'dart:async';
import 'dart:convert';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/models.dart';
import 'package:http/http.dart' as http;



class DatabaseProvider extends ChangeNotifier {

  static const DATABASE_VERSION_FILENAME = "version";
  static const DATABASE_CONTENT_FILENAME = "database.json";
  
  fs.Firestore _firestore = fb.firestore();
  fb.StorageReference _firebaseStorage = fb.storage().ref("");

  final collectionThemes = "themes";
  final collectionQuestions = "questions";

  List<Language> supportedLanguage = [];
  List<QuizTheme> themes = [];
  List<Question> questions = [];
  int currentDatabaseVersion;


  QuizTheme _currentSelectedTheme;
  Language _currentSelectedLanguage;

  Language get currentSelectedLanguage => _currentSelectedLanguage;
  set currentSelectedLanguage(l) {
    _currentSelectedLanguage = l;
    notifyListeners();
  }

  QuizTheme get currentSelectedTheme => _currentSelectedTheme;
  set currentSelectedTheme(t) {
    _currentSelectedTheme = t;
    notifyListeners();
  }

  DatabaseProvider() {
    supportedLanguage = [Language("fr"), Language("en")];
    currentSelectedLanguage = supportedLanguage.first;
    init();
  }


  init() {
    _firestore.collection(collectionThemes).onSnapshot.listen((querySnap) async {
      themes = [];
      for (fs.DocumentSnapshot docSnap in querySnap.docs) {
        try {
          themes.add(QuizTheme.fromJSON(id: docSnap.id, data: docSnap.data()));
        }catch(e) {print(e.toString());}
      }
      notifyListeners();
    });

    _firestore.collection(collectionQuestions).onSnapshot.listen((querySnap) async {
      questions = [];
      for (fs.DocumentSnapshot docSnap in querySnap.docs) {
        try {
          questions.add(Question.fromJSON(id: docSnap.id, data: docSnap.data()));
        }catch(e) {print(e.toString());}
      }
      notifyListeners();
    });

    _initDatabaseVersion();
  }
  

  Future<void> addSupportedLanguage(Language l) async {
    supportedLanguage.add(l);
    await Future.delayed(const Duration(seconds: 2), (){print("supported language added (debug)");});
    notifyListeners();
  }


  Future<void> addTheme(QuizTheme t) async {
    await _firestore.collection(collectionThemes).add(t.toJson());
  }

  Future<void> updateTheme(QuizTheme t) async {
    await _firestore.collection(collectionThemes).doc(t.id).update(data: t.toJson());
  }

  Future<void> removeTheme(QuizTheme t) async {
    await _firestore.collection(collectionThemes).doc(t.id).delete();
  }

  Future<void> addQuestion(Question q) async {
    await _firestore.collection(collectionQuestions).add(q.toJson());
  }

  Future<void> updateQuestion(Question q) async {
    await _firestore.collection(collectionQuestions).doc(q.id).update(data: q.toJson());
  }

  Future<void> removeQuestion(Question q) async {
    await _firestore.collection(collectionQuestions).doc(q.id).delete();
  }

  Future<void> _initDatabaseVersion() async {
    fb.StorageReference _ref = _firebaseStorage.child(DATABASE_VERSION_FILENAME);
    String fileURL = (await _ref.getDownloadURL()).toString();
    http.Response res = await http.get(fileURL);
    currentDatabaseVersion =  int.parse(res.body);
    
    notifyListeners();
  }

  Future<void> publishDatabase() async {
    var _refVersion = _firebaseStorage.child(DATABASE_VERSION_FILENAME);
    var _refDatabase = _firebaseStorage.child(DATABASE_CONTENT_FILENAME);

    var newVersion = (currentDatabaseVersion??0) + 1;
    var databaseJSON = Map<String, Object>();
    databaseJSON["themes"] = themes;
    databaseJSON["questions"] = questions;

    try {
      var taskUploadDatabaseContent = _refDatabase.putString(jsonEncode(databaseJSON));
      await taskUploadDatabaseContent.future;
    } catch(e) {print(e); return ;}
    try {
      var taskUpdateDatabaseVersion = _refVersion.putString(newVersion.toString()); 
      await taskUpdateDatabaseVersion.future;
    } catch(e) {print(e); return ;}

    currentDatabaseVersion = newVersion; 
    notifyListeners();
  }
}