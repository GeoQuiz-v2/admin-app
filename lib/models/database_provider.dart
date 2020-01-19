
import 'dart:async';
import 'dart:html' as html;
import 'dart:io';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/env.dart';
import 'package:geoquizadmin/models/models.dart';

import 'dart:convert';

class DatabaseProvider extends ChangeNotifier {

  
  fs.Firestore _firestore = fb.firestore();

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
    await _firestore.collection(collectionThemes).add(t.toJSON());
  }

  Future<void> updateTheme(QuizTheme t) async {
    await _firestore.collection(collectionThemes).doc(t.id).update(data: t.toJSON());
  }

  Future<void> removeTheme(QuizTheme t) async {
    await _firestore.collection(collectionThemes).doc(t.id).delete();
  }

  Future<void> addQuestion(Question q) async {
    await _firestore.collection(collectionQuestions).add(q.toJSON());
  }

  Future<void> updateQuestion(Question q) async {
    await _firestore.collection(collectionQuestions).doc(q.id).update(data: q.toJSON());
  }

  Future<void> removeQuestion(Question q) async {
    await _firestore.collection(collectionQuestions).doc(q.id).delete();
  }

  Future<void> _initDatabaseVersion() async {
    fb.StorageReference _firebaseStorage = fb.storage().ref("");
    fb.StorageReference _ref = _firebaseStorage.child("version");
    String fileURL = (await _ref.getDownloadURL()).toString();
    html.HttpClient client;
    final html.Response downloadData = await html.get(fileURL);
    print("3");
    String contentFile = utf8.decode(downloadData.bodyBytes);
    print("4");
    currentDatabaseVersion = int.parse(contentFile);

    
    notifyListeners();
  }

  Future<void> publishDatabase() async {
    fb.StorageReference _firebaseStorage = fb.storage().ref("");
    currentDatabaseVersion = currentDatabaseVersion??0 + 1;
    fb.StorageReference _ref = _firebaseStorage.child("version");
    String a = "42";
    Future futureTask = _ref.putString(a).future; 
    futureTask.catchError((e) => print(e));
  }
}