
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/models.dart';
import 'package:geoquizadmin/models/questions_provider.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/form_dialog.dart';
import 'package:geoquizadmin/ui/widget/subtitle.dart';
import 'package:geoquizadmin/ui/widget/utils.dart';
import 'package:provider/provider.dart';

class ThemeListWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsProvider>(
      builder: (context, provider, _) => 
        Column(
          children: <Widget>[
            SubTitle("Themes"),
            ThemeItem(),
            if (provider.themes != null)
              ...provider.themes.map((t) => ThemeItem(theme: t)).toList()
          ],
        ),
    );
  }
}


class ThemeItem extends StatefulWidget {

  final QuizTheme theme;

  ThemeItem({Key key, this.theme}) : super(key: key);

  @override
  _ThemeItemState createState() => _ThemeItemState();
}

class _ThemeItemState extends State<ThemeItem> {

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.theme?.title;
    _svgController.text = widget.theme?.rawSVG;
    _entitledController.text = widget.theme?.entitled;
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _svgController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _entitledController = TextEditingController();

  bool _inProgress = false;

  set inProgress(b) => setState(() => _inProgress = b);
  get inProgress => _inProgress;

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => Form(
        key: _formKey,
        child: Column(
          children: [
            
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

                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration.collapsed(hintText: "Title"),
                      validator: (value) => value.isEmpty ? "Invalid" : null,
                    )
                  ),

                  SizedBox(width: Values.normalSpacing,),

                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _entitledController,
                      decoration: InputDecoration.collapsed(hintText: "Entitled"),
                      validator: (value) => value.isEmpty ? "Invalid" : null,
                    ),
                  ),

                  SizedBox(width: Values.normalSpacing,),
                  
                  ...getActionWidgets(context),

                ],
              )
            ),
          ]
        )
      ),
    );
  }

  List<Widget> getActionWidgets(context) {
    if (widget.theme == null) {
      return [ButtonTheme(
        minWidth: 0,
        child: FlatButton(
          child: Text(inProgress ? "Loading..." : "Add"), 
          textColor: AppColors.primary,
          onPressed: inProgress ? null : () => onAddTheme(context)
        ),
      )];
    } else {
      return [
        InkWell(
          child: Icon(Icons.delete, color: AppColors.error),

          onTap: () => SnackBarFactory.showSuccessSnackbar(context: context, message: "Long click to delete the theme."),
          onLongPress: () => onDeleteTheme(context),
        ),
        SizedBox(child: SizedBox(width: Values.normalSpacing)),
        InkWell(
          child: Icon(Icons.save, color: AppColors.primary),
          onTap:  () => onUpdateTheme(context),
        ),
      ];
    }
  }


  onAddTheme(context) {
    if (_formKey.currentState.validate()){
      inProgress = true;
      Provider.of<QuestionsProvider>(context, listen: false).addTheme(getThemeFromForm())
        .then((_) => SnackBarFactory.showSuccessSnackbar(context: context, message: "Successfully added."))
        .catchError((e) => SnackBarFactory.showErrorSnabar(context: context, message: e.toString()))
        .whenComplete(() => inProgress = false);
    }
  }


  onUpdateTheme(context) {
    if (_formKey.currentState.validate()) {
      Provider.of<QuestionsProvider>(context, listen: false).updateTheme(getThemeFromForm())
        .then((_) => SnackBarFactory.showSuccessSnackbar(context: context, message: "Successfully updated."))
        .catchError((e) => SnackBarFactory.showErrorSnabar(context: context, message: e.toString()));
    }

  }


  onDeleteTheme(context) {
    Provider.of<QuestionsProvider>(context, listen: false).removeTheme(widget.theme)
      .then((_) => SnackBarFactory.showSuccessSnackbar(context: context, message: "Successfully deleted."))
      .catchError((e) => SnackBarFactory.showErrorSnabar(context: context, message: e.toString()));
  }


  QuizTheme getThemeFromForm() {
    return QuizTheme(
      id: widget.theme?.id,
      title: _titleController.text,
      entitled: _entitledController.text,
      color: null,
      rawSVG: _svgController.text,
    );
  }


}

