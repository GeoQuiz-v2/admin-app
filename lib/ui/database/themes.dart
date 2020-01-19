
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

class ThemeListWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SubTitle("Themes"),
        ThemeItem(),
        Consumer<DatabaseProvider>(
          builder: (context, provider, _) => 
            provider.themes == null 
            ? Container()
            : ListView(
              shrinkWrap: true,
              children: provider.themes.map((t) => ThemeItem(theme: t)).toList(),
            )
        ),
      ],
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


  final _formKey = GlobalKey<FormState>();

  TextEditingController _svgController;
  TextEditingController _titleController;
  TextEditingController _entitledController;
  TextEditingController _colorController;

  bool _inProgress = false;

  set inProgress(b) => setState(() => _inProgress = b);
  get inProgress => _inProgress;

  bool get selected => widget.theme != null && Provider.of<DatabaseProvider>(context, listen: false).currentSelectedTheme == widget.theme;
  

  @override
  Widget build(BuildContext context) {
    _svgController = TextEditingController();
    _titleController = TextEditingController();
    _entitledController = TextEditingController();
    _colorController = TextEditingController();
    _titleController.text = widget.theme?.title;
    _svgController.text = widget.theme?.rawSVG;
    _entitledController.text = widget.theme?.entitled;
    _colorController.text = widget.theme?.color?.toString();

    return Builder(
        builder: (context) => Form(
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

                ColorPicker(controller: _colorController, color: widget.theme?.color),

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
          onPressed: () => SnackBarFactory.showSuccessSnackbar(context: context, message: "Long click to delete the theme."),
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
      inProgress = true;
      Provider.of<DatabaseProvider>(context, listen: false).addTheme(getThemeFromForm())
        .then((_) => SnackBarFactory.showSuccessSnackbar(context: context, message: "Successfully added."))
        .catchError((e) => SnackBarFactory.showErrorSnabar(context: context, message: e.toString()))
        .whenComplete(() => inProgress = false);
    }
  }


  onUpdateTheme(context) {
    if (_formKey.currentState.validate()) {
      Provider.of<DatabaseProvider>(context, listen: false).updateTheme(getThemeFromForm())
        .then((_) => SnackBarFactory.showSuccessSnackbar(context: context, message: "Successfully updated."))
        .catchError((e) => SnackBarFactory.showErrorSnabar(context: context, message: e.toString()));
    }

  }


  onDeleteTheme(context) {
    Provider.of<DatabaseProvider>(context, listen: false).removeTheme(widget.theme)
      .then((_) => SnackBarFactory.showSuccessSnackbar(context: context, message: "Successfully deleted."))
      .catchError((e) => SnackBarFactory.showErrorSnabar(context: context, message: e.toString()));
  }


  QuizTheme getThemeFromForm() {
    return QuizTheme(
      id: widget.theme?.id,
      title: _titleController.text,
      entitled: _entitledController.text,
      color: int.parse(_colorController.text),
      rawSVG: _svgController.text,
    );
  }


}

