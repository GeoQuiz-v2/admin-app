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

  final _formKey = new GlobalKey<FormState>();

  final answerControllers = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];
  final entitledController = TextEditingController();
  final entitledTypeController = TypePickerController();
  final answerTypesController = TypePickerController();
  final difficultyController = DifficultyPickerController();

  @override
  Widget build(BuildContext context) {
    return Form(
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

            ...List<int>.generate(answerControllers.length, (i) => i).map((i) => 
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: answerControllers.elementAt(i),
                  decoration: InputDecoration.collapsed(hintText: i == 0 ? "Correct answer" : ("Wrong answer #" + i.toString())),
                  validator: basicValidator,
                ),
              )
            ).toList(),

            DifficultyPicker(controller: difficultyController),

            ...getActionWidgets(context),
          ],
        ),

      ),
    );
  }


  List<Widget> getActionWidgets(context) {
    if (widget.question == null) {
      return [ButtonTheme(
        minWidth: 0,
        child: FlatButton(
          child: Text(inProgress ? "Loading..." : "Add"), 
          textColor: AppColors.primary,
          onPressed: inProgress ? null : () => onAddQuestion(context)
        ),
      )];
    } else {
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
  }

  onAddQuestion(context) {
    if (_formKey.currentState.validate()) {
      handleProviderFunction(Provider.of<QuestionsProvider>(context).addQuestion, null);
    }
  }

  onUpdateQuestion(context) {
    if (_formKey.currentState.validate()) {
      handleProviderFunction(Provider.of<QuestionsProvider>(context).updateQuestion, null);
    }
  }


  onDeleteQuestion(context) {
    handleProviderFunction(Provider.of<QuestionsProvider>(context).removeQuestion, null);
  }


  handleProviderFunction(Future Function(Question) function, Question q) {
    inProgress = true;
    function(q)
        .then((_) => null)
        .catchError((e) => SnackBarFactory())
        .whenComplete(() => inProgress = false);
  }
}

