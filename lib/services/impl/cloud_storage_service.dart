import 'dart:convert';

import 'package:admin/models/database_wrapper.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/services/storage_service.dart';
import 'package:firebase/firebase.dart';
import 'package:http/http.dart' as http;


class CloudStorageService implements IStorageService {
  StorageReference _firebaseStorage = storage().ref("");
  
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
        var databaseFileName = 'database_$lang';
        print("Upload $databaseFileName");
        var databaseFileRef = _firebaseStorage.child(databaseFileName);
        var databaseJson = {
          'themes': _serializeThemes(models.themes.values, lang),
          'questions':_serializeQuestions(models.questions.values, lang)
        };
        var taskUploadDatabaseContent = databaseFileRef.putString(jsonEncode(databaseJson));
        await taskUploadDatabaseContent.future;
        print("Upload of $databaseFileName finished");
      } catch (e) {
        print(e);
        if (e is FirebaseError)
          print(e.serverResponse);
      }
    }
    int newVersion = 1;
    try {
      var currentPublishedVersion = await retrieveDatabaseVersion();
      newVersion = currentPublishedVersion + 1;
    } catch (e) {
      print(e);
      print("No previous version exists");
    }
    print("Upload new database verison : $newVersion");
    var versionFileRef = _firebaseStorage.child("version");
    var taskUpdateDatabaseVersion = versionFileRef.putString(newVersion.toString()); 
    await taskUpdateDatabaseVersion.future;

    return newVersion;
  }

  List<Map<String, Object>> _serializeThemes(Iterable<ThemeModel> themes, String lang) {
    var themesJson = <Map<String,Object>>[];
    for (var theme in themes) {
      themesJson.add({
        'title': theme.name[lang],
        'color': theme.color,
        'entitled': theme.entitled[lang],
        'order': theme.priority,
        'icon': theme.svgIcon,
      });
    }
    return themesJson;
  }

  List<Map<String, Object>> _serializeQuestions(Iterable<QuestionModel> questions, String lang) {
    var questionsJson = <Map<String,Object>>[];
    for (var question in questions) {
      questionsJson.add({
        'id': question.id,
        'theme': question.theme,
        'entitled': question.entitled[lang],
        'entitled_type': question.entitledType.label,
        'answers': question.answers.map((a) => a[lang]).toList(),
        'answers_type': question.answersType.label,
        'difficulty': question.difficulty
      });
    }
    return questionsJson;
  } 
}