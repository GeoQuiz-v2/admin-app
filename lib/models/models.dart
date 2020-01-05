import 'package:flutter/foundation.dart';


class Language {
  String codeISO;

  Language(this.codeISO);
}


class QuizTheme {
  String rawSVG;
  String title;
  int color;
  ResourceType entitledType;
  String entitled;

  QuizTheme({@required this.rawSVG, @required this.title, @required this.color, @required this.entitled, @required this.entitledType});
  
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