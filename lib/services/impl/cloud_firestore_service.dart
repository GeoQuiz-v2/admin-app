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
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class CloudFirestoreService implements IDatabaseService {
  @override
  final IDao<LanguageModel> languagesDao;

  @override
  final IDao<QuestionModel> questionsDao;

  @override
  final IDao<ThemeModel> themesDao;

  CloudFirestoreService() 
    : this.languagesDao = FirestoreDao<LanguageModel>(collection: "languages", adapter: LanguageAdapter()),
      this.questionsDao = FirestoreDao<QuestionModel>(collection: "questions", adapter: QuestionAdapter()),
      this.themesDao = FirestoreDao<ThemeModel>(collection: "themes", adapter: ThemeAdapter());
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
  Future<Map<String, T>> list() {
    Completer<Map<String, T>> completer = Completer();
    StreamSubscription subscr;
    subscr = _firestore.collection(collection).onSnapshot.listen((querySnap) async {
      Map<String, T> models = Map();
      for (DocumentSnapshot docSnap in querySnap.docs) {
        try {
          models[docSnap.id] = adapter.from({'id': docSnap.id, ...docSnap.data()});
        }catch(e) {
          print(e.toString());
        }
      }
      completer.complete(models);
      subscr.cancel();
    });
    return completer.future;
  }

  @override
  Future update(T model) async {
    await _firestore.collection(collection).doc(model.id).set(adapter.to(model));
  }
}