import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/models.dart';
import 'package:geoquizadmin/models/database_provider.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/color_picker.dart';
import 'package:geoquizadmin/ui/widget/form_dialog.dart';
import 'package:geoquizadmin/ui/widget/icon_button.dart';
import 'package:geoquizadmin/ui/widget/subtitle.dart';
import 'package:geoquizadmin/ui/widget/utils.dart';
import 'package:provider/provider.dart';


final GlobalKey globalKey = GlobalKey();


////
///
///
class ThemeListWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      key: globalKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SubTitle("Themes"),
        Consumer<DatabaseProvider>(
          builder: (context, provider, _) => 
            provider.themes == null 
            ? Container()
            : ListView(
              key: GlobalKey(),
              shrinkWrap: true,
              children: [
                ThemeItem(),
                ...provider.themes.map((t) => ThemeItem(
                  theme: t,
                )).toList(),
              ]
            )
        ),
      ],
    );
  }
}



////
///
///
class ThemeItem extends StatefulWidget {

  final QuizTheme theme;

  ThemeItem({Key key, this.theme}) : super(key: key);
  
  @override
  _ThemeItemState createState() => _ThemeItemState();
}



///
///
///
class _ThemeItemState extends State<ThemeItem> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _svgController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _entitledController = TextEditingController();
  int _colorController;

  bool _inProgress = false;

  set inProgress(b) {
    if (mounted)
      setState(() => _inProgress = b);
  } 
  get inProgress => _inProgress;

  bool get selected => widget.theme != null && Provider.of<DatabaseProvider>(context, listen: false).currentSelectedTheme == widget.theme;
  

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.theme?.title;
    _svgController.text = widget.theme?.rawSVG;
    _entitledController.text = widget.theme?.entitled;
    _colorController = widget.theme?.color;
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: InkWell(
        focusColor: Colors.transparent,
        onTap: widget.theme == null 
          ? null 
          : () {
            Provider.of<DatabaseProvider>(context, listen: false).currentSelectedTheme = widget.theme;
          },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: selected ? AppColors.primary : AppColors.divider)),
            color: selected ? AppColors.primaryLight : Colors.transparent
          ),
          child: Row(
            children: <Widget>[
              TextFieldDialog(
                controller: _svgController,
                icon: Icons.image,
                label: "SVG data",
                onSubmit: null,
                title: "Add SVG icon data",
                customValidator:basicValidator,
              ),

              SizedBox(width: Values.normalSpacing,),

              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration.collapsed(hintText: "Title"),
                  validator: basicValidator,
                )
              ),

              SizedBox(width: Values.normalSpacing,),

              ColorPicker(
                initialColor: _colorController,
                validator: (c) => c == null || c.toString().length != 10 ? "Invalid color" : null,
                onSaved: (c) => _colorController = c,
              ),

              SizedBox(width: Values.normalSpacing,),

              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _entitledController,
                  decoration: InputDecoration.collapsed(hintText: "Entitled"),
                  validator: basicValidator,
                ),
              ),

              SizedBox(width: Values.normalSpacing,),
              
              ...getActionWidgets(context),

            ],
          )
        ),
      ),
    );
  }


  List<Widget> getActionWidgets(context) {
    if (widget.theme == null) {
      return [FlatButton(
        child: Text(inProgress ? "Loading..." : "Add"), 
        textColor: AppColors.primary,
        onPressed: inProgress ? null : () => onAddTheme(context)
      )];
    } else {
      return [
        RoundedIconButton(
          icon: Icon(Icons.delete, color: AppColors.error),
          onPressed: () => SnackBarFactory.showSuccessSnackbar(context: globalKey.currentContext, message: "Long click to delete the theme."),
          onLongPress: () => onDeleteTheme(context),
        ),
        RoundedIconButton(
          icon: Icon(Icons.save, color: AppColors.primary),
          onPressed:  () => onUpdateTheme(context),
        ),
      ];
    }
  }


  onAddTheme(context) {
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      inProgress = true;
      Provider.of<DatabaseProvider>(context, listen: false).addTheme(getThemeFromForm())
        .then((_) => SnackBarFactory.showSuccessSnackbar(context: globalKey.currentContext, message: "Successfully added."))
        .catchError((e) => SnackBarFactory.showErrorSnabar(context: globalKey.currentContext, message: e.toString()))
        .whenComplete(() => inProgress = false);
    }
  }


  onUpdateTheme(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Provider.of<DatabaseProvider>(context, listen: false).updateTheme(getThemeFromForm())
        .then((_) => SnackBarFactory.showSuccessSnackbar(context: globalKey.currentContext, message: "Successfully updated."))
        .catchError((e) => SnackBarFactory.showErrorSnabar(context: globalKey.currentContext, message: e.toString()));
    }
  }


  onDeleteTheme(context) {
    Provider.of<DatabaseProvider>(context, listen: false).removeTheme(widget.theme)
      .then((_) => SnackBarFactory.showSuccessSnackbar(context: globalKey.currentContext, message: "Successfully deleted."))
      .catchError((e) => SnackBarFactory.showErrorSnabar(context: globalKey.currentContext, message: e.toString()));
  }


  QuizTheme getThemeFromForm() {
    return QuizTheme(
      id: widget.theme?.id,
      title: _titleController.text,
      entitled: _entitledController.text,
      color: _colorController,
      rawSVG: _svgController.text,
    );
  }
}

