import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/models.dart';
import 'package:geoquizadmin/models/questions_provider.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/difficulty_picker.dart';
import 'package:geoquizadmin/ui/widget/subtitle.dart';
import 'package:geoquizadmin/ui/widget/type_picker.dart';
import 'package:geoquizadmin/ui/widget/utils.dart';
import 'package:provider/provider.dart';



class QuestionListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SubTitle(
          "Questions", 
          action: FlatButton.icon(
            textColor: AppColors.error,
            label: Text("Missing translation"),
            icon: Icon(Icons.warning, color: AppColors.error,),
            onPressed: () {},
          )
        ),
        QuestionItem(),
        Consumer<QuestionsProvider>(
          builder: (context, provider, _) => ListView.builder(
            shrinkWrap: true,
            itemCount: provider.questions == null ? 0 : min(provider.questions.length, 10),
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, position) => QuestionItem(question: provider.questions[position],),
          ),
        )
      ],
    );
  }
}

class QuestionItem extends StatefulWidget {

  final Question question;

  QuestionItem({this.question});

  @override
  _QuestionItemState createState() => _QuestionItemState();
}

class _QuestionItemState extends State<QuestionItem> {

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
  Widget build(BuildContext context) {
    resetForm();
    return Builder(
      builder: (context) => Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider))
          ),
          child: Row(
            children: <Widget>[
              TypePicker(
                types: [Types.imageType, Types.textType],
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
                types: [Types.imageType, Types.textType, Types.locationType],
                controller: answerTypesController,
              ),

              SizedBox(child: SizedBox(width: Values.normalSpacing,),),
              
              Expanded(
                flex: 7,
                child: Wrap(
                  children: List<int>.generate(answerControllers.length, (i) => i).map((i) => 
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: answerControllers.elementAt(i),
                          decoration: InputDecoration.collapsed(hintText: i == 0 ? "Correct answer" : ("Wrong answer #" + i.toString())),
                          validator: basicValidator,
                        ),
                      ),
                  ).toList(),
                )
              ),
              DifficultyPicker(controller: difficultyController),

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
    while (answerControllers.length < 4)
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
      InkWell(
        child: Icon(Icons.delete, color: AppColors.error),

        onTap: () => SnackBarFactory.showSuccessSnackbar(context: context, message: "Long click to delete the theme."),
        onLongPress: () => onDeleteQuestion(context),
      ),
      SizedBox(child: SizedBox(width: Values.normalSpacing)),
      InkWell(
        child: Icon(Icons.save, color: AppColors.primary),
        onTap:  () => onUpdateQuestion(context),
      ),
    ];
  }

  onAddQuestion(context) {
    print(entitledTypeController.value);
    if (_formKey.currentState.validate()) {
      handleProviderFunction(context, Provider.of<QuestionsProvider>(context, listen: false).addQuestion, getQuestionFromForm());
    }
  }

  onUpdateQuestion(context) {
    if (_formKey.currentState.validate()) {
      handleProviderFunction(context, Provider.of<QuestionsProvider>(context, listen: false).updateQuestion, getQuestionFromForm());
    }
  }


  onDeleteQuestion(context) {
    handleProviderFunction(context, Provider.of<QuestionsProvider>(context, listen: false).removeQuestion, widget.question);
  }

  Question getQuestionFromForm() {
    return Question(
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

