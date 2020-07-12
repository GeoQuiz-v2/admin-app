import 'package:admin/components/app_intl_resource_form_field.dart';
import 'package:admin/models/language_model.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/utils/intl_resource.dart';
import 'package:admin/utils/resource_type.dart';


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


class ThemeAdapter implements NoSqlAdapter<ThemeModel> {
  @override
  ThemeModel from(Map<String, Object> json) {
    var id = json['id'];
    var icon = json['icon'];
    var priority = json['order'];
    var color = json['color'];
    var name = IntlResourceAdapter().from(json['title']);
    var entitled = IntlResourceAdapter().from(json['entitled']);
    return ThemeModel(
      id: id, 
      svgIcon: icon, 
      priority: priority, 
      name: name, 
      color: color, 
      entitled: entitled
    );
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


class QuestionAdapter implements NoSqlAdapter<QuestionModel> {
  @override
  QuestionModel from(Map<String, Object> json) {
    var id = json['id'];
    var theme = json['theme'];
    var entitledType = ResourceType.fromLabel(json['entitledType']);
    var entitled = IntlResourceAdapter().from(json['entitled']);
    var answersType = ResourceType.fromLabel(json['answersType']);
    var answers = (json['answers'] as List)?.map((a) => IntlResourceAdapter().from(a))?.toList();
    var difficulty = json['difficulty'];
    return QuestionModel(
      id: id,
      theme: theme,
      entitledType: entitledType,
      entitled: entitled,
      answersType: answersType,
      answers: answers,
      difficulty: difficulty,
    );
  }

  @override
  Map<String, Object> to(QuestionModel model) {
    return {
      'theme': model.theme,
      'entitledType': model.entitledType?.label,
      'entitled': IntlResourceAdapter().to(model.entitled),
      'answersType': model.answersType?.label,
      'answers': model.answers?.map((a) => IntlResourceAdapter().to(a))?.toList(),
      'difficulty': model.difficulty
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