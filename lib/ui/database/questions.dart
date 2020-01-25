import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/models.dart';
import 'package:geoquizadmin/models/database_provider.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/difficulty_picker.dart';
import 'package:geoquizadmin/ui/widget/icon_button.dart';
import 'package:geoquizadmin/ui/widget/subtitle.dart';
import 'package:geoquizadmin/ui/widget/type_picker.dart';
import 'package:geoquizadmin/ui/widget/utils.dart';
import 'package:provider/provider.dart';



class QuestionListWidget extends StatefulWidget {
  @override
  _QuestionListWidgetState createState() => _QuestionListWidgetState();
}

class _QuestionListWidgetState extends State<QuestionListWidget> {

  final questionsPerPage = 10;
  int pageNumber = 1;
  bool onlyQuestionsWithProblems = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {

        String currentSelectedThemeId = provider.currentSelectedTheme?.id;
        int problems = 0;
        List<Question> questions = [];
        if (currentSelectedThemeId != null) {
          List<Question> allQuestions = provider.questions.where((q) => q.themeId == currentSelectedThemeId ).toList();
          List<Question> questionWithProblems = allQuestions.where((q) => q.incorrectQuestionFormat).toList();
          problems = questionWithProblems.length;
          questions = onlyQuestionsWithProblems ? questionWithProblems : allQuestions;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SubTitle(
              "Questions", 
              action: problems == 0 ? null : FlatButton.icon(
                textColor: onlyQuestionsWithProblems ? AppColors.onError : AppColors.error,
                label: Text("Problems ($problems)"),
                icon: Icon(Icons.warning, color: onlyQuestionsWithProblems ? AppColors.onError : AppColors.error),
                onPressed: onProblemsButtonClick,
                color: onlyQuestionsWithProblems ? AppColors.error : Colors.transparent,
              )
            ),
            if (currentSelectedThemeId != null)
              child,
            currentSelectedThemeId == null 
            ? Text("Select a theme to view questions.", style: TextStyle(color: AppColors.textColorLight))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: questions == null ? 0 : min(questions.length, 10),
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, position) => QuestionItem(question: questions[position],),
              ),
            SizedBox(height: Values.normalSpacing),
            Row(
              children: List.generate((questions.length / questionsPerPage).ceil(), (i) => i + 1).map((i) => 
                pageNumberWidget(i)
              ).toList(),
            )
          ],
        );
      },
      child: QuestionItem(),
    );
  }

  Widget pageNumberWidget(int i) => Container(
    width: 30.0,
    height: 30.0,
    decoration: BoxDecoration(
      color: i == pageNumber ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: () => setState(() => this.pageNumber = i),
        child: Center(child: Text(i.toString(), style: TextStyle(color: i == pageNumber ? AppColors.onPrimary : AppColors.onSurface),),)
      ),
      color: Colors.transparent,
    ),
  );

  onProblemsButtonClick() {
    setState(() {
      onlyQuestionsWithProblems = !onlyQuestionsWithProblems;
    });
  }
}

class QuestionItem extends StatefulWidget {

  final Question question;

  QuestionItem({this.question});

  @override
  _QuestionItemState createState() => _QuestionItemState();
}

class _QuestionItemState extends State<QuestionItem> {

  final minumumNumberOfQuestions = 4;
  bool _inProgress = false;

  set inProgress(b) => setState(() => _inProgress = b);
  get inProgress => _inProgress;

  final _formKey = GlobalKey<FormState>();

  TextEditingController entitledController;
  TypePickerController entitledTypeController;
  List<TextEditingController> answerControllers;
  TypePickerController answerTypesController;
  DifficultyPickerController difficultyController;

  @override
  void initState() {
    super.initState();
    resetForm();
  }


  @override
  Widget build(BuildContext context) {
    // resetForm();
    return Builder(
      builder: (context) => Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider))
          ),
          child: Row(
            children: <Widget>[
              TypePicker(
                types: [Types.image, Types.text],
                controller: entitledTypeController,
              ),

              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: entitledController,
                  decoration: InputDecoration.collapsed(hintText: "Entitled"),
                  validator: basicValidator,
                ),
              ),

              SizedBox(child: SizedBox(width: Values.normalSpacing,),),

              TypePicker(
                types: [Types.image, Types.text, Types.location],
                controller: answerTypesController,
              ),

              SizedBox(child: SizedBox(width: Values.normalSpacing,),),
              
              Expanded(
                flex: 7,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [...List<int>.generate(answerControllers.length, (i) => i).map((i) => 
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: answerControllers.elementAt(i),
                          decoration: InputDecoration.collapsed(hintText: i == 0 ? "Correct answer" : ("Wrong answer #" + i.toString())),
                          validator: basicValidator,
                        ),
                      ),
                    ).toList(),
                    RoundedIconButton(
                      icon: Icon(Icons.remove, color: AppColors.textColorLight),
                      onPressed: answerControllers.length <= minumumNumberOfQuestions ? null : () => setState(() => answerControllers.removeLast()),
                    ),
                    RoundedIconButton(
                      icon: Icon(Icons.add, color: AppColors.textColorLight),
                      onPressed: () => setState(() => answerControllers.add(TextEditingController())),
                    )
                  ],
                )
              ),
              DifficultyPicker(controller: difficultyController),

              SizedBox(width: 10),

              if (widget.question?.incorrectQuestionFormat == true)
                RoundedIconButton(
                  icon: Icon(Icons.warning, color: AppColors.error),
                  onPressed: () {},
                ),
              
              ...getActionWidgets(context)
            ],
          ),

        ),
      ),
    );
  }

  resetForm() {
    _formKey.currentState?.reset();
    entitledController = TextEditingController();
    entitledTypeController = TypePickerController();
    answerControllers = List<TextEditingController>();
    answerTypesController = TypePickerController();
    difficultyController = DifficultyPickerController();

    entitledController.text = widget.question?.entitled;
    entitledTypeController.value = widget.question?.entitledType;
    answerTypesController.value = widget.question?.answersType;
    difficultyController.value = widget.question?.difficulty;
    answerControllers = [];
    widget.question?.answers?.forEach((q) => answerControllers.add(TextEditingController(text: q)));
    while (answerControllers.length < minumumNumberOfQuestions)
      answerControllers.add(TextEditingController());
  }


  List<Widget> getActionWidgets(context) {
    if (inProgress)
      return [SizedBox(height: 24, width: 24, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))];

    if (widget.question == null)
      return [ButtonTheme(
        minWidth: 0,
        child: FlatButton(
          child: Text("Add"), 
          textColor: AppColors.primary,
          onPressed: () => onAddQuestion(context)
        ),
      )];

    return [
      RoundedIconButton(
        icon: Icon(Icons.delete, color: AppColors.error),
        onPressed: () => SnackBarFactory.showSuccessSnackbar(context: context, message: "Long click to delete the theme."),
        onLongPress: () => onDeleteQuestion(context),
      ),
      RoundedIconButton(
        icon: Icon(Icons.save, color: AppColors.primary),
        onPressed:  () => onUpdateQuestion(context),
      ),
    ];
  }

  onAddQuestion(context) {
    print(entitledTypeController.value);
    if (_formKey.currentState.validate()) {
      handleProviderFunction(context, Provider.of<DatabaseProvider>(context, listen: false).addQuestion, getQuestionFromForm());
    }
  }

  onUpdateQuestion(context) {
    if (_formKey.currentState.validate()) {
      handleProviderFunction(context, Provider.of<DatabaseProvider>(context, listen: false).updateQuestion, getQuestionFromForm());
    }
  }


  onDeleteQuestion(context) {
    handleProviderFunction(context, Provider.of<DatabaseProvider>(context, listen: false).removeQuestion, widget.question);
  }

  Question getQuestionFromForm() {
    return Question(
      themeId: Provider.of<DatabaseProvider>(context, listen: false).currentSelectedTheme.id,
      id: widget.question?.id,
      entitled: entitledController.text,
      entitledType: entitledTypeController.value,
      answers: answerControllers.map((c) => c.text).toList(),
      answersType: answerTypesController.value,
      difficulty: difficultyController.value
    );
  }


  handleProviderFunction(context, Future Function(Question) function, Question q) {
    inProgress = true;
    function(q)
        .then((_) => SnackBarFactory.showSuccessSnackbar(context: context, message: "Success."))
        .catchError((e) => SnackBarFactory.showErrorSnabar(context: context, message: e.toString()))
        .whenComplete(() {resetForm(); inProgress = false;});
  }
}

