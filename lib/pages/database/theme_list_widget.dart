import 'dart:ui';

import 'package:admin/components/app_button.dart';
import 'package:admin/components/app_color_picker.dart';
import 'package:admin/components/app_integer_selector.dart';
import 'package:admin/components/app_intl_resource_form_field.dart';
import 'package:admin/components/app_model_edition_dialog.dart';
import 'package:admin/components/app_subtitle.dart';
import 'package:admin/components/app_window.dart';
import 'package:admin/models/language_model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/pages/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';


class ThemesListWidget extends StatefulWidget {
  final Iterable<LanguageModel> supportedLanguages;
  final List<ThemeModel> themes;

  ThemesListWidget({
    Key key,
    @required this.supportedLanguages,
    @required this.themes,
  }) : super(key: key) {
    themes?.sort((t1, t2) => t1.priority.compareTo(t2.priority));
  }

  @override
  _ThemesListWidgetState createState() => _ThemesListWidgetState();
}

class _ThemesListWidgetState extends State<ThemesListWidget> {
  ThemeModel selectedTheme;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSubtitle(
          child: Text("Themes"),
          trailing: [
            AppButton(
              child: Text("Add"),
              style: AppButtonStyle.ligth,
              onPressed: () {
                final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
                ThemeEditionDialog(
                  databaseProvider: databaseProvider,
                )..show(context);
              },
            )
          ],
        ),
        ThemeItemHeaderWidget(),
        widget.themes == null
          ? Text("Loading")
          : ListView.separated(
              shrinkWrap: true,
              itemCount: widget.themes.length,
              separatorBuilder: (context, i) => Divider(color: Colors.black, thickness: window.devicePixelRatio, height: 10,),
              itemBuilder: (context, i) {
                final theme = widget.themes.elementAt(i);
                return ThemeitemWidget(
                  theme: theme,
                  supportedLanguages: widget.supportedLanguages,
                  isSelected: selectedTheme == theme,
                  onSelected: (t) => setState(() => this.selectedTheme = t),
                );
              } 
            )
      ],
    );
  }
}


class ThemeItemHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Container()), // radio button
        Expanded(flex: 2, child: Container()), // languages
        Expanded(flex: 2, child: Text("Icon")),
        Expanded(flex: 4, child: Text("Theme")),
        Expanded(flex: 4, child: Text("Color")),
        Expanded(flex: 10, child: Text("Entitled")),
        Expanded(flex: 2, child: Text("Priority")),
        Expanded(flex: 2, child: Container()) // edition/delete btns
      ],
    );
  }
}


class ThemeitemWidget extends StatelessWidget {
  final Iterable<LanguageModel> supportedLanguages;
  final ThemeModel theme;
  final Function(ThemeModel) onSelected;
  final bool isSelected;

  ThemeitemWidget({
    Key key,
    @required this.supportedLanguages,
    @required this.theme,
    @required this.onSelected,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Radio<ThemeModel>(
            value: theme,
            groupValue: isSelected ? theme : null,
            onChanged: onSelected,
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(children: supportedLanguages.map((l) => Text(l.isoCode2)).toList()),
        ),
        Expanded(
          flex: 2,
          child: Text("icon")
        ),
        Expanded(
          flex: 4,
          child: Column(children: supportedLanguages.map((l) => 
            Text(theme.name.resource[l.isoCode2]??"")
          ).toList(),),
        ),
        Expanded(
          flex: 4,
          child: Text(theme.color.toString()),
        ),
        Expanded(
          flex: 10,
          child: Column(children: supportedLanguages.map((l) => 
            Text(theme.entitled.resource[l.isoCode2]??"")
          ).toList(),),
        ),
        Expanded(
          flex: 1,
          child: Text(theme.priority.toString()),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              InkWell(
                child: Icon(Icons.edit),
                onTap: () {
                  final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
                  ThemeEditionDialog(
                    initialTheme: theme, 
                    databaseProvider: databaseProvider
                  )..show(context);
                }
              ),
              InkWell(
                child: Icon(Icons.delete),
                onTap: () {},
              )
            ],
          )
        )
      ],
    );
  }
}


class ThemeEditionDialog extends AppModelEditionDialog {
  ThemeEditionDialog({
    Key key,
    ThemeModel initialTheme,
    @required DatabaseProvider databaseProvider,
  }) : super(
    key: key,
    initialModel: initialTheme,
    databaseProvider: databaseProvider,
  );

  @override
  AppModelEditionDialogState createState() => _ThemeEditionDialogState();
}

class _ThemeEditionDialogState extends AppModelEditionDialogState {
  final _formKey = GlobalKey<FormState>();
  int colorController;
  IntegerSelectorController priorityController;
  TextEditingController iconController;
  IntlResourceEditingController nameController;
  IntlResourceEditingController entitledController;
  

  @override
  void initState() {
    super.initState();
    var theme = widget.initialModel as ThemeModel;
    colorController = theme?.color;
    priorityController = IntegerSelectorController(selectedValue: theme?.priority);
    iconController = TextEditingController(text: theme?.svgIcon);
    nameController = IntlResourceEditingController(resource: theme?.name);
    entitledController = IntlResourceEditingController(resource: theme?.entitled);
  }

  @override
  void dispose() {
    iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppWindow(
      title: Text("Add language"),
      bottom: AppButton(
        onPressed: save,
        child: Text("Save"),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            IntlResourceFormField(
              controller: nameController,
              languages: ["fr", "en"],
            ),
            TextFormField(
              controller: iconController
            ),
            // ColorPicker(
            //   initialColor: colorController,
            //   validator: (c) => c == null || c.toString().length != 10 ? "Invalid color" : null,
            //   onSaved: (c) => colorController = c,
            // ),
            IntlResourceFormField(
              controller: entitledController,
              languages: ["fr", "en"],
            ),
            // IntegerSelector(
            //   controller: priorityController,
            // ),
          ],
        ),
      )
    );
  }

  save() {
    if (_formKey.currentState.validate()) {
      var updatedTheme = ThemeModel(
        id: widget.initialModel?.id,
        entitled: entitledController.resource,
        name: nameController.resource,
        color: colorController,
        priority: priorityController.value,
        svgIcon: iconController.text,
      );
      widget.databaseProvider.saveTheme(updatedTheme).then((_) {
        dismiss();
      }).catchError((e) {
        print(e);
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString()),));
      });
    }
  }
}