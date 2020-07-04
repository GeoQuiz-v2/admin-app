import 'package:admin/models/model.dart';
import 'package:flutter/foundation.dart';

class LanguageModel extends Model {
  String isoCode2;

  LanguageModel({
    String id, 
    @required this.isoCode2
  }) : super(id);
}