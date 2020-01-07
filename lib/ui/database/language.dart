import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/models.dart';
import 'package:geoquizadmin/models/questions_provider.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/form_dialog.dart';
import 'package:geoquizadmin/ui/widget/subtitle.dart';
import 'package:provider/provider.dart';



class SupportedLanguageWidget extends StatelessWidget {
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
        Consumer<QuestionsProvider>(
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
        ),
      ],
    );
  }

  onAddSupportedLanguage(context) {
    showDialog(context: context, builder: (context) => AddSupportedLanguageDialog());
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
    return FormDialog(
      title: "Add supported language",
      label: "ISO Code 2",
      onSubmit: onSubmit,
    );
  }

  Future<bool> onSubmit(String isoCode) async {
    await Provider.of<QuestionsProvider>(context, listen: false).addSupportedLanguage(Language(isoCode));
    return true;
  }
}