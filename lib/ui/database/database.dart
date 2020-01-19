
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/ui/database/language.dart';
import 'package:geoquizadmin/ui/database/publish_database.dart';
import 'package:geoquizadmin/ui/database/questions.dart';
import 'package:geoquizadmin/ui/database/themes.dart';

class DatabaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PublishDatabase(),

        SupportedLanguageWidget(),

        ThemeListWidget(),

        QuestionListWidget(),
      ],
    );
  }
}