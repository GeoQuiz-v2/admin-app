import 'dart:ui';

import 'package:admin/components/app_button.dart';
import 'package:admin/components/app_color_picker.dart';
import 'package:admin/components/app_integer_selector.dart';
import 'package:admin/components/app_intl_column_view.dart';
import 'package:admin/components/app_intl_resource_form_field.dart';
import 'package:admin/components/app_model_actions.dart';
import 'package:admin/components/app_model_edition_dialog.dart';
import 'package:admin/components/app_model_listview.dart';
import 'package:admin/components/app_subtitle.dart';
import 'package:admin/components/app_window.dart';
import 'package:admin/models/language_model.dart';
import 'package:admin/models/model.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/pages/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';


class ThemesListWidget extends StatefulWidget {
  final Iterable<LanguageModel> supportedLanguages;
  final List<ThemeModel> themes;

  ThemesListWidget({
    Key key,
    @required this.supportedLanguages,
    @required this.themes,
  }) : super(key: key) {
    // themes?.sort((t1, t2) => t1?.priority?.compareTo(t2.priority)??-1);
  }

  @override
  _ThemesListWidgetState createState() => _ThemesListWidgetState();
}

class _ThemesListWidgetState extends State<ThemesListWidget> {
  DatabaseProvider get databaseProvider => Provider.of<DatabaseProvider>(context, listen: false);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSubtitle(
          child: Text("Themes"),
          trailing: [
            AppButton(
              style: AppButtonStyle.ligth,
              onPressed: () {
                ThemeEditionDialog(
                  databaseProvider: databaseProvider,
                )..show(context);
              },
              child: Text("Add"),
            )
          ],
        ),
        AppModelListView<ThemeModel>(
          models: widget.themes,
          weights: [1,2,2,4,2,10,2,2],
          labels: [Container(), Container(), Text("Icon"), Text("Theme"), Text("Color"), Text("Entitled"), Text("Priority"), Container()],
          cellsBuilders: [
            (t) =>  Radio<ThemeModel>(
                      value: t,
                      groupValue: databaseProvider.selectedTheme,
                      onChanged: (t) => databaseProvider.selectedTheme = t,
                    ),
            (t) =>  AppIntlLanguagesColumn(languages: widget.supportedLanguages),
            (t) =>  WebsafeSvg.string(t.svgIcon,height: 35, color: Color(t.color)),
            (t) =>  AppIntlColumnView(
                      languages: widget.supportedLanguages,
                      intlRes: t.name,
                    ),
            (t)     {
                      Color color;
                      try { color = Color(t.color); } catch(e) {}
                      return CircleAvatar(backgroundColor: color??Colors.transparent);
                    },
            (t) =>  AppIntlColumnView(
                      languages: widget.supportedLanguages,
                      intlRes: t.entitled,
                    ),
            (t) =>  Text(t.priority?.toString()??""),
            (t) =>  ModelActionsWidget(
                      dialog: ThemeEditionDialog(
                        initialTheme: t, 
                        databaseProvider: databaseProvider
                      ),
                      onDelete: () => databaseProvider.deleteTheme(t),
                    ),
          ],
        ),
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
  ColorEditingController colorController;
  IntegerSelectorController priorityController;
  TextEditingController iconController;
  IntlResourceEditingController nameController;
  IntlResourceEditingController entitledController;
  

  @override
  void initState() {
    super.initState();
    var theme = widget.initialModel as ThemeModel;
    colorController = ColorEditingController(color: theme?.color);
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

  save() {
    if (_formKey.currentState.validate()) {
      var updatedTheme = ThemeModel(
        id: widget.initialModel?.id,
        entitled: entitledController.resource,
        name: nameController.resource,
        color: colorController.color,
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
              languages: widget.languages,
              validator: basicIntlValidator,
            ),
            TextFormField(
              controller: iconController,
              validator: (v) => v.isEmpty ? "NON" : null
            ),
            ColorPicker(
              controller: colorController,
              // validator: (c) => c == null || c.toString().length != 10 ? "Invalid color" : null,
            ),
            IntlResourceFormField(
              controller: entitledController,
              languages: widget.languages,
              validator: basicIntlValidator,
            ),
            IntegerSelector(
              controller: priorityController,
            ),
          ],
        ),
      )
    );
  }
}