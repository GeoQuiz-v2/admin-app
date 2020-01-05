import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/models.dart';
import 'package:geoquizadmin/models/questions_provider.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/subtitle.dart';
import 'package:provider/provider.dart';


class QuestionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SubTitle(
          "Supported languages",
          first: true,
          action: FlatButton.icon(
            textColor: AppColors.primary,
            label: Text("Add new supported language"),
            icon: Icon(Icons.add, color: AppColors.primary,),
            onPressed: () => onAddSupportedLanguage(context),
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

  onAddSupportedLanguage(context) {
    showDialog(context: context, builder: (context) => AddSupportedLanguageDialog());
  }
}

class SupportedLanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsProvider>(
      builder: (context, provider, _) => DropdownButtonHideUnderline(
        child: Container(
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(Values.radius)),
          padding: EdgeInsets.only(left: 10),
          constraints: BoxConstraints(minWidth: 150),
          child: DropdownButton<Language>(
            value: provider.currentSelectedLanguage,
            items: provider.supportedLanguage.map((language) => 
              DropdownMenuItem<Language>(
                child: Text(language.codeISO),
                value: language,
              )
            ).toList(),
          onChanged: (l) => provider.currentSelectedLanguage = l,
          ),
        ),
      ),
    );
  }
}


class AddSupportedLanguageDialog extends StatefulWidget {
  @override
  _AddSupportedLanguageDialogState createState() => _AddSupportedLanguageDialogState();
}

class _AddSupportedLanguageDialogState extends State<AddSupportedLanguageDialog> {

  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add supported language"),
      content: TextField(
        decoration: InputDecoration(),
      ),
      actions: <Widget>[
        if (!inProgress)
          FlatButton(
            child: Text("Cancel"), 
            onPressed: () => Navigator.pop(context)
          ),
        FlatButton(
          child: Text(inProgress ? "Loading" : "Add"), 
          onPressed: inProgress ? null : () {
            setState(() => inProgress = true);
            Provider.of<QuestionsProvider>(context, listen: false).addSupportedLanguage(Language("es"))
              .then((_) => Navigator.pop(context))
              .whenComplete(() => setState(() => inProgress = false));
          }
        )
      ],
    );
  }
}



class ThemeListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider))
        ),
        child: Text("Monument")
      )]
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