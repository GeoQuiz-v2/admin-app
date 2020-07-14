import 'dart:convert';

import 'package:admin/services/translation_service.dart';
import 'package:admin/utils/intl_resource.dart';
import 'package:http/http.dart' as http;


class WikiDataTranslationService extends ITranslationService {
  String graphQlApiEndpoint = "https://tptools.toolforge.org/wdql.php";

  @override
  Future translate(IntlResource resource, List<String> languages) async {
    if (resource.wikidataCode != null) {
      String query = '{item(id:"${resource.wikidataCode}"){labels{text,language},}}';
      String url = '$graphQlApiEndpoint?query=$query';
      var wikidataResponse = await http.get(url);
      var body = utf8.decode(wikidataResponse.bodyBytes);
      var decodedBody = jsonDecode(body);
      if (wikidataResponse.statusCode == 200 && decodedBody != null && decodedBody['data']['item'] != null) {
        var resourceTranslations = decodedBody['data']['item']['labels'] as List;
        for (var lang in languages) {
          if (lang != IntlResource.defaultLanguage) { // to not override the default language entry
            var translation = resourceTranslations.firstWhere((e) => e['language'] == lang);
            resource.resource[lang] = translation['text'];
          } 
        }
      } else {
        print("INVALID WIKICODE");
      }
    }
  }
}