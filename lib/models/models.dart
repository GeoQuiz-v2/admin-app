import 'package:flutter/foundation.dart';


class Language {
  String codeISO;

  Language(this.codeISO);
}


class QuizTheme {
  String id;
  String rawSVG;
  String title;
  int color;
  String entitled;

  QuizTheme({this.id, @required this.rawSVG, @required this.title, @required this.color, @required this.entitled});

  QuizTheme.fromJSON({@required this.id, @required Map<String, Object> data}) {
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

class Question {
  ResourceType entitledType;
  String entitled;
  ResourceType answersType;
  List<String> answers;
  int difficulty;

  Question({@required this.entitledType, @required this.entitled, @required this.answers, @required this.answersType, @required this.difficulty});
  
}

enum ResourceType {
  IMAGE,
  TEXT,
  LOCATION,
}