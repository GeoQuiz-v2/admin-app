import 'package:admin/models/language.dart';
import 'package:admin/models/question.dart';
import 'package:admin/models/theme.dart';
import 'package:admin/services/database_service.dart';
import 'package:admin/utils/dao.dart';


class CloudFirestoreService implements IDatabaseService {
  @override
  final IDao<LanguageModel> languagesDao;

  @override
  final IDao<QuestionModel> questionsDao;

  @override
  final IDao<ThemeModel> themesDao;

  CloudFirestoreService() 
    : this.languagesDao = FirestoreDao<LanguageModel>("languages"),
      this.questionsDao = FirestoreDao<QuestionModel>("questions"),
      this.themesDao = FirestoreDao<ThemeModel>("themes");
}


class FirestoreDao<T> implements IDao<T> {
  String collection;

  FirestoreDao(this.collection);

  @override
  Future create(T model) {
    throw UnimplementedError();
  }

  @override
  Future delete(T model) {
    throw UnimplementedError();
  }

  @override
  Future<List<T>> list() {
    throw UnimplementedError();
  }

  @override
  Future update(T model) {
    throw UnimplementedError();
  }
}