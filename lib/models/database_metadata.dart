import 'package:flutter/foundation.dart';

class DatabaseMetadata {
  int version;
  List<String> languages;
  
  DatabaseMetadata({
    @required this.version,
    @required this.languages
  });

  @override
  String toString() => 'version: $version - languages: ${languages?.join(",")}';
}