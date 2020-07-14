import 'dart:async';

import 'package:admin/models/language_model.dart';
import 'package:admin/models/model.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/services/database_service.dart';
import 'package:admin/services/impl/nosql_adapters.dart';
import 'package:admin/utils/dao.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/foundation.dart';


class CloudFirestoreService implements IDatabaseService {
  static const languages_col = "languages";
  static const questions_col = "questions";
  static const themes_col = "themes";

  @override IDao<LanguageModel> languagesDao;
  @override IDao<QuestionModel> questionsDao;
  @override IDao<ThemeModel> themesDao;

  LanguageAdapter languageAdapter;
  QuestionAdapter questionAdapter;
  ThemeAdapter themeAdapter;

  CloudFirestoreService() {
    this.languageAdapter = LanguageAdapter();
    this.questionAdapter = QuestionAdapter();
    this.themeAdapter = ThemeAdapter();
    this.languagesDao = FirestoreDao<LanguageModel>(collection: languages_col, adapter: languageAdapter);
    this.questionsDao = FirestoreDao<QuestionModel>(collection: questions_col, adapter: questionAdapter);
    this.themesDao = FirestoreDao<ThemeModel>(collection: themes_col, adapter: themeAdapter);
  }

  @override
  Future upgrade(int oldVersion, int newVersion) async {
    final Firestore _firestore = firestore();
    if (oldVersion == 1 && newVersion == 2) {
      var snapshot = await _firestore.collection(questions_col).get();
      WriteBatch batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        if (doc.get("entitled.res") == null) { // condition to check if the question is v1 or v2
          var question = V1FirestoreQuestionAdapter(id: doc.id, data: doc.data());
          var docRef = _firestore.collection(questions_col).doc(doc.id);
          batch.set(docRef, questionAdapter.to(question));
        }
      }
      batch.commit();
    } else {
      throw UpgradeOperationNotSupported();
    }
  }
}


class FirestoreDao<T extends Model> implements IDao<T> {
  final Firestore _firestore;

  final NoSqlAdapter adapter;
  final String collection;

  FirestoreDao({
    @required this.collection,
    @required this.adapter,
  }) : _firestore = firestore();

  @override
  Future<String> create(T model) async {
    var doc = await _firestore.collection(collection).add(adapter.to(model));
    return doc.id;
  }

  @override
  Future delete(T model) async {
    await _firestore.collection(collection).doc(model.id).delete();
  }

  @override
  Future<Map<String, T>> list() async {
    var snapshot = await _firestore.collection(collection).get();
    Map<String, T> models = Map();
    for (DocumentSnapshot docSnap in snapshot.docs) {
      try {
        models[docSnap.id] = adapter.from({'id': docSnap.id, ...docSnap.data()});
      }catch(e) {
        print(e.toString());
      }
    }
    return models;
  }

  @override
  Future update(T model) async {
    await _firestore.collection(collection).doc(model.id).set(adapter.to(model));
  }
}