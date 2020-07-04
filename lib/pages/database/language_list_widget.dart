import 'package:admin/components/app_button.dart';
import 'package:admin/components/app_dialog.dart';
import 'package:admin/components/app_subtitle.dart';
import 'package:admin/models/language_model.dart';
import 'package:admin/pages/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LanguageListWidget extends StatelessWidget {
  final Iterable<LanguageModel> languages;

  LanguageListWidget({
    Key key,
    @required this.languages
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    return Column(
      children: [
        AppSubtitle(
          child: Text("Languages"),
          trailing: [
            AppButton(
              child: Text("Add"),
              style: AppButtonStyle.ligth,
              onPressed: () => LanguageEditionDialog.show(context, databaseProvider),
            )
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: 
          languages == null
          ? Text("Loading ...")
          : Row(
              children: languages.map((l) => InkWell(
                child: Text(l.isoCode2),
                onTap: () => LanguageEditionDialog.show(context, databaseProvider, l),
              )).toList(),
            ),
        ),
      ],
    );
  }
}



class LanguageEditionDialog extends StatefulWidget {
  final DatabaseProvider databaseProvider;
  final LanguageModel initialLanguage;

  LanguageEditionDialog({
    Key key,
    @required this.initialLanguage, 
    @required this.databaseProvider
  }) : super(key: key);

  static show(context, databaseProvider, [LanguageModel languageModel]) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: LanguageEditionDialog(
          databaseProvider: databaseProvider,
          initialLanguage: languageModel,
        ),
      ),
    );
  }

  @override
  _LanguageEditionDialogState createState() => _LanguageEditionDialogState();
}

class _LanguageEditionDialogState extends State<LanguageEditionDialog> {
  TextEditingController codeIsoController;

  @override
  void initState() {
    super.initState();
    codeIsoController = TextEditingController(text: widget.initialLanguage?.isoCode2);
  }

  @override
  void dispose() {
    super.dispose();
    codeIsoController.dispose();
  }

  dismiss() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Text("Add language"),
      content: Column(
        children: <Widget>[
          TextFormField(
            controller: codeIsoController,
          ),
        ],
      ),
      bottom: AppButton(
        child: Text("Save"),
        onPressed: save,
      )
    );
  }

  save() {
    var updatedLanguage = LanguageModel(
      id: widget.initialLanguage?.id,
      isoCode2: codeIsoController.text
    );
    widget.databaseProvider.saveLanguage(updatedLanguage).then((_) {
      dismiss();
    }).catchError((e) {
      print(e);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString()),));
    });
  }
}