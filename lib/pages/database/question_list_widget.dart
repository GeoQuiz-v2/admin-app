import 'package:admin/components/app_button.dart';
import 'package:admin/components/app_intl_resource_form_field.dart';
import 'package:admin/components/app_model_edition_dialog.dart';
import 'package:admin/components/app_model_listview.dart';
import 'package:admin/components/app_subtitle.dart';
import 'package:admin/components/app_window.dart';
import 'package:admin/models/language_model.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/pages/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';


class QuestionListWidget extends StatelessWidget {
  final Iterable<LanguageModel> supportedLanguages;
  final List<QuestionModel> questions;
  final ThemeModel selectedTheme;

  QuestionListWidget({
    Key key,
    @required this.selectedTheme,
    @required this.supportedLanguages,
    @required this.questions,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSubtitle(
          child: Text("Questions"),
          trailing: [
            AppButton(
              style: AppButtonStyle.ligth,
              onPressed: () {
                final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
                QuestionEditionDialog(
                  databaseProvider: databaseProvider,
                )..show(context);
              },
              child: Text("Add"),
            )
          ],
        ),
        AppModelListView<QuestionModel>(
          weights: [1,1,1,1,1,1],
          labels: [Text("Theme"), Text("Type"), Text("Entitled"), Text("Type"), Text("Answers"), Text("Difficulty")],
          models: questions,
          cellsBuilders: <Widget Function(QuestionModel)>[
            (question) => Text(question.entitledType.label),
            (question) => Text(question.entitledType.label),
            (question) => Text(question.entitledType.label),
            (question) => Text(question.entitledType.label),
            (question) => Text(question.entitledType.label),
            (question) => Text(question.entitledType.label),
          ],
        )
      ],
    );
  }
}


class QuestionEditionDialog extends AppModelEditionDialog {
  final ThemeModel selectedTheme;

  QuestionEditionDialog({
    Key key,
    QuestionModel inititalQuestion,
    this.selectedTheme,
    @required DatabaseProvider databaseProvider,
  }) : super(
    key: key,
    initialModel: inititalQuestion,
    databaseProvider: databaseProvider,
  );

  @override
  AppModelEditionDialogState createState() => _QuestionEditionDialogState();
}

class _QuestionEditionDialogState extends AppModelEditionDialogState {
  final _formKey = GlobalKey<FormState>();
  IntlResourceEditingController entitledController;

  @override
  QuestionEditionDialog get widget => super.widget as QuestionEditionDialog;

  @override
  void initState() {
    super.initState();
    var question = widget.initialModel as QuestionModel;
    entitledController = IntlResourceEditingController(resource: question?.entitled);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppWindow(
      title: Text("Question Edition"),
      bottom: AppButton(
        onPressed: save,
        child: Text("Save"),
      ),
      content: Column(
        children: [
          IntlResourceFormField(
            controller: entitledController,
            languages: widget.databaseProvider.languages.map((l) => l.isoCode2),
          )
        ],
      ),
    );
  }

  save() {
    if (_formKey.currentState.validate()) {
      var updatedQuestion = QuestionModel(
        id: widget.initialModel?.id,
        theme: widget.selectedTheme.id,
        entitledType: null,
        entitled: null,
        answersType: null,
        answers: null,
        difficulty: null,
      );
      widget.databaseProvider.saveQuestion(updatedQuestion).then((_) {
        dismiss();
      }).catchError((e) {
        print(e);
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString()),));
      });
    }
  }
}