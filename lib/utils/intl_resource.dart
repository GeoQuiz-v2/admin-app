import 'package:flutter/widgets.dart';

class IntlResource {
  String wikidataCode;
  Map<String, String> resource;

  IntlResource({
    this.wikidataCode,
    @required this.resource,
  });
}

enum ResourceType {
  image,
  text,
  geopoint,
}