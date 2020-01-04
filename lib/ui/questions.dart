import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/ui/widget/subtitle.dart';

class QuestionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SubTitle(
          "Supported languages",
          action: FlatButton.icon(
            textColor: AppColors.primary,
            label: Text("Add new supported language"),
            icon: Icon(Icons.add, color: AppColors.primary,),
            onPressed: () {},
          ),
        ),
        SupportedLanguageWidget(),

        SubTitle("Themes"),
        ThemeListWidget(),

        SubTitle(
          "Questions", 
          action: FlatButton.icon(
            textColor: AppColors.error,
            label: Text("Missing translation"),
            icon: Icon(Icons.warning, color: AppColors.error,),
            onPressed: () {},
          )
        ),
        QuestionListWidget(),
      ],
    );
  }
}

class SupportedLanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}


class ThemeListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}


class QuestionListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}