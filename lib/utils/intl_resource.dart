import 'package:flutter/widgets.dart';

class IntlResource {
  String wikidataCode;
  Map<String, String> resource;
  String get defaultResource => resource['en'];

  IntlResource({
    this.wikidataCode,
    @required this.resource,
  });

  String operator [](String lang) {
    return resource.containsKey(lang) ? resource[lang] : defaultResource;
  }
}

