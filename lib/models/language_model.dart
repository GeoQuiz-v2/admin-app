import 'package:admin/models/model.dart';
import 'package:flutter/foundation.dart';

class LanguageModel extends Model implements Comparable {
  String isoCode2;

  LanguageModel({
    String id, 
    @required this.isoCode2
  }) : super(id);

  @override
  int compareTo(other) {
    return other is LanguageModel ? isoCode2.compareTo(other.isoCode2) : -1;
  }


}