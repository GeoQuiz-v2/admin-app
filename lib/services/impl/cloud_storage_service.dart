import 'dart:convert';

import 'package:admin/models/database_metadata.dart';
import 'package:admin/models/database_wrapper.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/services/storage_service.dart';
import 'package:firebase/firebase.dart';
import 'package:http/http.dart' as http;


class CloudStorageService implements IStorageService {
  StorageReference _firebaseStorage = storage().ref("");
  JsonDatabaseMetadataTransformer metadataTransformer = JsonDatabaseMetadataTransformer();
  JsonQuestionTransformer questionTransformer = JsonQuestionTransformer();
  JsonThemeTransformer themeTransformer = JsonThemeTransformer();
  static final String metadataFilename = "metadata";
  
  @override
  Future<DatabaseMetadata> retrieveDatabaseMetadata() async {
    var versionFileStorageRed = _firebaseStorage.child(metadataFilename);
    var fileURL = await versionFileStorageRed.getDownloadURL();
    var res = await http.get(fileURL);
    var metadata = jsonDecode(utf8.decode(res.bodyBytes));
    return metadataTransformer.fromMap(metadata);
  }

  @override
  Future<DatabaseMetadata> publishDatabase(DatabaseWrapper models) async {
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
    DatabaseMetadata databaseMetadata = DatabaseMetadata(
      version: 1,
      languages: models.languages.values.map((l) => l.isoCode2).toList()
    );
    try {
      var currentMetata = await retrieveDatabaseMetadata();
      databaseMetadata.version = currentMetata.version + 1;
    } catch (e) {
      print(e);
      print("No previous version exists");
    }
    print("Upload new database verison : $databaseMetadata");
    var versionFileRef = _firebaseStorage.child(metadataFilename);
    var metadata = jsonEncode(metadataTransformer.toMap(databaseMetadata));
    var taskUpdateDatabaseVersion = versionFileRef.putString(metadata); 
    await taskUpdateDatabaseVersion.future;
    return databaseMetadata;
  }

  List<Map<String, Object>> _serializeThemes(Iterable<ThemeModel> themes, String lang) {
    var themesJson = <Map<String,Object>>[];
    for (var theme in themes) {
      themesJson.add(themeTransformer.toMap(theme, lang));
    }
    return themesJson;
  }

  List<Map<String, Object>> _serializeQuestions(Iterable<QuestionModel> questions, String lang) {
    var questionsJson = <Map<String,Object>>[];
    for (var question in questions) {
      questionsJson.add(questionTransformer.toMap(question, lang));
    }
    return questionsJson;
  } 
}


class JsonDatabaseMetadataTransformer {
  DatabaseMetadata fromMap(Map<String, dynamic> data) {
    return DatabaseMetadata(
      languages: (data['languages'] as List).cast<String>(), 
      version: data['version']
    );
  }

  Map<String, dynamic> toMap(DatabaseMetadata model) {
    return {
      'version': model.version,
      'languages': model.languages
    };
  }
}


class JsonQuestionTransformer {
  Map<String, dynamic> toMap(QuestionModel model, String lang) {
    return {
      'id': model.id,
      'theme': model.theme,
      'entitled': model.entitled[lang],
      'entitled_type': model.entitledType?.label,
      'answers': model.answers?.map((a) => a[lang])?.toList(),
      'answers_type': model.answersType?.label,
      'difficulty': model.difficulty
    };
  }
}


class JsonThemeTransformer {
  Map<String, dynamic> toMap(ThemeModel model, String lang) {
    return {
      'id': model.id,
      'title': model.name[lang],
      'color': model.color,
      'entitled': model.entitled[lang],
      'order': model.priority,
      'icon': model.svgIcon,
    };
  }
}