import 'package:admin/components/app_button.dart';
import 'package:admin/components/app_model_edition_dialog.dart';
import 'package:admin/components/app_subtitle.dart';
import 'package:admin/components/app_window.dart';
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
              onPressed: () => LanguageEditionDialog(databaseProvider: databaseProvider,)..show(context),
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
                onTap: () => LanguageEditionDialog(initialLanguage: l, databaseProvider: databaseProvider)..show(context),
              )).toList(),
            ),
        ),
      ],
    );
  }
}



class LanguageEditionDialog extends AppModelEditionDialog {

  LanguageEditionDialog({
    Key key,
    LanguageModel initialLanguage, 
    @required DatabaseProvider databaseProvider
  }) : super(
    key: key,
    initialModel: initialLanguage,
    databaseProvider: databaseProvider
  );

  @override
  AppModelEditionDialogState createState() => _LanguageEditionDialogState();
}

class _LanguageEditionDialogState extends AppModelEditionDialogState {
  TextEditingController codeIsoController;

  @override
  void initState() {
    super.initState();
    codeIsoController = TextEditingController(text: (widget.initialModel as LanguageModel)?.isoCode2);
  }

  @override
  void dispose() {
    super.dispose();
    codeIsoController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AppWindow(
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
      id: widget.initialModel?.id,
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


