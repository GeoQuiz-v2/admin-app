import 'package:admin/models/language_model.dart';
import 'package:admin/models/model.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/utils/intl_resource.dart';


abstract class NoSqlAdapter<T> {
  T from(Map<String, Object> json);
  Map<String, Object> to(T model);
}


class LanguageAdapter implements NoSqlAdapter<LanguageModel> {
  @override
  LanguageModel from(Map<String, Object> json) {
    var id = json['id'];
    var iso2 = json['iso2'];
    return LanguageModel(id: id, isoCode2: iso2);
  }

  @override
  Map<String, Object> to(LanguageModel model) {
    return {
      'iso2': model.isoCode2,
    };
  }
}


class QuestionAdapter implements NoSqlAdapter<QuestionModel> {
  @override
  QuestionModel from(Map<String, Object> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, Object> to(QuestionModel model) {
    throw UnimplementedError();
  }
}


class ThemeAdapter implements NoSqlAdapter<ThemeModel> {
  @override
  ThemeModel from(Map<String, Object> json) {
    var id = json['id'];
    var icon = json['icon'];
    var priority = json['order'];
    var color = json['color'];
    var name = IntlResourceAdapter().from(json['title']);
    var entitled = IntlResourceAdapter().from(json['entitled']);
    var a = ThemeModel(id: id, svgIcon: icon, priority: priority, name: name, color: color, entitled: entitled);
    return a;
  }

  @override
  Map<String, Object> to(ThemeModel model) {
    return {
      'entitled': IntlResourceAdapter().to(model.entitled),
      'icon': model.svgIcon,
      'order': model.priority,
      'title': IntlResourceAdapter().to(model.name),
      'color': model.color
    };
  }
}


class IntlResourceAdapter implements NoSqlAdapter<IntlResource> {
  @override
  IntlResource from(Map<String, Object> data) {
    var res = (data['res'] as Map).cast<String, String>();
    var wikiCode = data['wikiCode'];
    return IntlResource(resource: res, wikidataCode: wikiCode);
  }

  @override
  Map<String, Object> to(IntlResource model) {
    return {
      'res': model.resource,
      'wikiCode': model.wikidataCode
    };
  }
}