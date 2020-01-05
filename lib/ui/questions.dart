import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/models.dart';
import 'package:geoquizadmin/models/questions_provider.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/dialog.dart';
import 'package:geoquizadmin/ui/widget/form_field.dart';
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

  final _formKey = GlobalKey<FormState>();
  final _codeISOController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: "Add supported language",
      content: Form(
        key: _formKey,
        child: RoundedTextFormField(
          hint: "ISO Code 2",
          controller: _codeISOController,
          validator: (value) => value.length == 2 ? null : "2 characters only.",
        ),
      ),
      onSubmit: onSubmit,
    );
  }

  Future<bool> onSubmit() async {
    if (_formKey.currentState.validate()) {
      await Provider.of<QuestionsProvider>(context, listen: false).addSupportedLanguage(Language(_codeISOController.text));
      return true;
    }
    return false;
  }
}



class ThemeListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider))
          ),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.image), 
                color: AppColors.textColorLight,
                onPressed: () {},
              ),
              SizedBox(width: Values.normalSpacing,),
              SizedBox(
                width: 200,
                child: TextFormField(decoration: InputDecoration.collapsed(hintText: "Title"),)
              ),
              SizedBox(width: Values.normalSpacing,),
              SizedBox(
                width: 300,
                child: TextFormField(decoration: InputDecoration.collapsed(hintText: "Entitled"),),
              ),
              Expanded(child: Container()),
              FlatButton(child: Text("Add"), onPressed: () {},)
            ],
          )
        )
      ]
    );
  }
}

class AddThemeIconDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
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