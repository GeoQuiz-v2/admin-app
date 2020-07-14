import 'package:flutter/widgets.dart';

class IntlResource {
  String wikidataCode;
  Map<String, String> resource;
  static String get defaultLanguage => 'en';
  String get defaultResource => resource[defaultLanguage];

  IntlResource({
    this.wikidataCode,
    @required this.resource,
  });

  String operator [](String lang) {
    return resource.containsKey(lang) ? resource[lang] : defaultResource;
  }
}

