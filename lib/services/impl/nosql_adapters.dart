import 'package:admin/models/language.dart';
import 'package:admin/models/model.dart';
import 'package:admin/models/question.dart';
import 'package:admin/models/theme.dart';
import 'package:admin/utils/intl_resource.dart';


abstract class NoSqlAdapter<T extends Model> {
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
    var name = IntlResource(resource: json['entitled']);
    var entitled = IntlResource(resource: json['entitled']);
    return ThemeModel(id: id, svgIcon: icon, priority: priority, name: name, color: color, entitled: entitled);
  }

  @override
  Map<String, Object> to(ThemeModel model) {
    return {
      'entitled': model.entitled.resource,
      'icon': model.svgIcon,
      'order': model.priority,
      'title': model.name,
      'color': model.color
    };
  }
}