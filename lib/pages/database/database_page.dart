import 'package:admin/components/app_bar.dart';
import 'package:admin/components/app_button.dart';
import 'package:admin/pages/database/database_provider.dart';
import 'package:admin/pages/database/language_list_widget.dart';
import 'package:admin/pages/database/question_list_widget.dart';
import 'package:admin/pages/database/theme_list_widget.dart';
import 'package:admin/pages/database/translation_provider.dart';
import 'package:admin/services/impl/cloud_firestore_service.dart';
import 'package:admin/services/impl/cloud_storage_service.dart';
import 'package:admin/services/impl/wikidata_translation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class DatabasePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseProvider>(create: (_) => DatabaseProvider(
          databaseService: CloudFirestoreService(),
          storageService: CloudStorageService()
        )..init()),
        ChangeNotifierProvider<TranslationProvider>(create: (_) => TranslationProvider(
          databaseService: CloudFirestoreService(),
          translationService: WikiDataTranslationService()
        ),)
      ],
      child: Scaffold(
        appBar: AppAppBar(
          title: Text("Database"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(54),
            child: DatabaseActionBar(),
          ),
        ),
        body: Consumer<TranslationProvider>(
          builder: (_,__,___) => Consumer<DatabaseProvider>(
            builder: (context, databaseProvider, _) => SingleChildScrollView(
              child: Column(
                children: [
                  LanguageListWidget(
                    languages: databaseProvider.languages
                  ),
                  ThemesListWidget(
                    themes: databaseProvider.themes,
                    supportedLanguages: databaseProvider.languages,
                  ),
                  QuestionListWidget(
                    selectedTheme: databaseProvider.themes?.first,
                    questions: databaseProvider.questions,
                    supportedLanguages: databaseProvider.languages,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class DatabaseActionBar extends StatelessWidget {
  onPublishDatabase(context) async {
    await Provider.of<DatabaseProvider>(context, listen: false).publishDatabase();
  }

  onGenerateTranslations(context) async {
    var database = Provider.of<DatabaseProvider>(context, listen: false).models;
    await Provider.of<TranslationProvider>(context, listen: false).generateTranslatation(database);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppButton(
          child: Text("Update database"),
          onPressed: () => onPublishDatabase(context),
          style: AppButtonStyle.primary,
        ),
        AppButton(
          child: Text("Generate translations"),
          onPressed: () => onGenerateTranslations(context),
          style: AppButtonStyle.primary,
        ),
      ],
    );
  }
}