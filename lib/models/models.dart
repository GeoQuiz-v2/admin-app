import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class Language {
  String codeISO;

  Language(this.codeISO);
}


abstract class Model {
  String id;
  
  Model({@required this.id});
  
  Map<String, Object> toJSON();
}

class QuizTheme extends Model {
  String rawSVG;
  String title;
  int color;
  String entitled;

  QuizTheme({String id, @required this.rawSVG, @required this.title, @required this.color, @required this.entitled}) 
  : super(id: id);

  QuizTheme.fromJSON({String id, @required Map<String, Object> data}) : super(id: id) {
    this.rawSVG = data["icon"];
    this.title = data["title"];
    this.color = data["color"];
    this.entitled = data["entitled"];
  }

  Map<String, Object> toJSON() => {
    "icon": rawSVG,
    "title": title,
    "color": color,
    "entitled": entitled,
  };
  
}

class Question extends Model{
  Type entitledType;
  String entitled;
  Type answersType;
  List<String> answers;
  int difficulty;

  Question({String id, @required this.entitledType, @required this.entitled, @required this.answers, @required this.answersType, @required this.difficulty})
  : super(id: id);

  Question.fromJSON({String id, @required Map<String, Object> data}) : super(id: id) {
    this.entitled = data["entitled"] as String;
    this.entitledType = Types.fromLabel(data["entitled_type"]);
    this.answers = (data["answers"] as List<dynamic>).cast<String>();
    this.answersType = Types.fromLabel(data["answers_type"]);
    this.difficulty = data["difficlty"] as int;
  }

  @override
  Map<String, Object> toJSON() => {
    "entitled": entitled,
    "entitled_type": entitledType.label,
    "answers": answers,
    "answers_type": answersType.label,
    "difficlty": difficulty
  };
  
}


class Type {
  String label;
  IconData icon;

  Type({this.label, this.icon});
}


class Types {
  static var textType = Type(icon: Icons.title, label: "text");
  static var imageType = Type(icon: Icons.image, label: "image");
  static var locationType = Type(icon: Icons.location_on, label: "location");
  
  static Type fromLabel(String label) {
    switch (label) {
      case "text": return textType;
      case "image": return imageType;
      case "location": return locationType;
      default: return Type(label: label, icon: Icons.help_outline);
    }
  }
}
