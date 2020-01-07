
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/models.dart';
import 'package:geoquizadmin/models/questions_provider.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/form_dialog.dart';
import 'package:geoquizadmin/ui/widget/subtitle.dart';
import 'package:provider/provider.dart';

class ThemeListWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsProvider>(
      builder: (context, provider, _) => 
        Column(
          children: <Widget>[
            AddThemeForm(),
            ...provider.themes.map((t) => ThemeItem(theme: t)).toList()
          ],
        ),
    );
  }
}


class AddThemeForm extends StatefulWidget {
  @override
  _AddThemeFormState createState() => _AddThemeFormState();
}

class _AddThemeFormState extends State<AddThemeForm> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _svgController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _entitledController = TextEditingController();

  bool _inProgress = false;

  set inProgress(b) => setState(() => _inProgress = b);
  get inProgress => _inProgress;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SubTitle("Themes"),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider))
            ),
            child: Row(
              children: <Widget>[
                TextFieldDialog(
                  icon: Icons.image, 
                  title: "Theme svg icon",
                  label: "The icon svg source",
                  controller: _svgController,
                  onSubmit: null,
                  customValidator: (value) => value.isEmpty ? "Invalid input" : null,
                ),

                SizedBox(width: Values.normalSpacing,),

                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration.collapsed(hintText: "Title"),
                    validator: (value) => value.isEmpty ? "Invalid" : null,
                  )
                ),

                SizedBox(width: Values.normalSpacing,),

                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _entitledController,
                    decoration: InputDecoration.collapsed(hintText: "Entitled"),
                    validator: (value) => value.isEmpty ? "Invalid" : null,
                  ),
                ),

                Expanded(child: Container()),

                FlatButton(
                  child: Text(inProgress ? "Loading..." : "Add"), 
                  textColor: AppColors.primary,
                  onPressed: inProgress ? null : onSubmit
                ),
              ],
            )
          ),
        ]
      )
    );
  }

  

  onSubmit() {
    if (_formKey.currentState.validate()){
      inProgress = true;
      QuizTheme theme = QuizTheme(
        title: _titleController.text,
        entitled: _entitledController.text,
        color: null,
        rawSVG: _svgController.text,
      );
      Provider.of<QuestionsProvider>(context, listen: false).addTheme(theme)
        .then((_) {})
        .catchError((e) => {})
        .whenComplete(() => inProgress = false);
    }
  }
}


class ThemeItem extends StatelessWidget {

  final QuizTheme theme;

  ThemeItem({Key key, @required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(theme.title);
  }
}