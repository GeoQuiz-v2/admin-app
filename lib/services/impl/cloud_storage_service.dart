import 'dart:convert';

import 'package:admin/models/database_wrapper.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/services/storage_service.dart';
import 'package:firebase/firebase.dart';
import 'package:http/http.dart' as http;


class CloudStorageService implements IStorageService {
  StorageReference _firebaseStorage = storage().ref();
  
  @override
  Future<int> retrieveDatabaseVersion() async {
    var versionFileStorageRed = _firebaseStorage.child("version");
    var fileURL = await versionFileStorageRed.getDownloadURL();
    var res = await http.get(fileURL);
    return int.parse(utf8.decode(res.bodyBytes));
  }

  @override
  Future<int> publishDatabase(DatabaseWrapper models) async {
    for (var lang in models.languages.values.map((l) => l.isoCode2).toList()) {
      try {
        var databaseFileName = '${database}_${lang}';
        var databaseFileRef = _firebaseStorage.child(databaseFileName);
        var databaseJson = {
          'themes': _serializeThemes(models.themes.values, lang),
          'questions':_serializeQuestions(models.questions.values, lang)
        };
        var taskUploadDatabaseContent = databaseFileRef.putString(jsonEncode(databaseJson));
        await taskUploadDatabaseContent.future;
      } catch (e) {
        print(e);
      }
    }
    var currentPublishedVersion = await retrieveDatabaseVersion();
    var newVersion = (currentPublishedVersion??0) + 1;
    var versionFileRef = _firebaseStorage.child("version");
    var taskUpdateDatabaseVersion = versionFileRef.putString(newVersion.toString()); 
    await taskUpdateDatabaseVersion.future;

    return newVersion;
  }

  List<Map<String, Object>> _serializeThemes(List<ThemeModel> themes, String lang) {
    var themesJson = <Map<String,Object>>[];
    for (var theme in themes) {
      themesJson.add({
        'title': theme.name.resource[lang],
        'color': theme.color,
        'entitled': theme.entitled.resource[lang],
        'order': theme.priority,
        'icon': theme.svgIcon,
      });
    }
    return themesJson;
  }

  List<Map<String, Object>> _serializeQuestions(List<QuestionModel> questions, String lang) {
    var questionsJson = <Map<String,Object>>[];
    for (var question in questions) {
      questionsJson.add({
        'id': question.id,
        'theme': question.theme,
        'entitled': question.entitled,
        'entitled_type': question.entitledType.label,
        'answers': question.answers,
        'answers_type': question.answersType.label,
        'difficulty': question.difficulty
      });
    }
    return questionsJson;
  } 
}