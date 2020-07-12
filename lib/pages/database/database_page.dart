import 'package:admin/components/app_bar.dart';
import 'package:admin/components/app_button.dart';
import 'package:admin/pages/database/database_provider.dart';
import 'package:admin/pages/database/language_list_widget.dart';
import 'package:admin/pages/database/question_list_widget.dart';
import 'package:admin/pages/database/theme_list_widget.dart';
import 'package:admin/services/impl/cloud_firestore_service.dart';
import 'package:admin/services/impl/cloud_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class DatabasePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DatabaseProvider>(
      create: (_) => DatabaseProvider(
        databaseService: CloudFirestoreService(),
        storageService: CloudStorageService()
      )..init(),
      builder: (context, _) =>  Scaffold(
        appBar: AppAppBar(
          title: Text("Database"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(54),
            child: DatabaseActionBar(),
          ),
        ),
        body: Consumer<DatabaseProvider>(
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
    );
  }
}


class DatabaseActionBar extends StatelessWidget {
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
          onPressed: () {},
          style: AppButtonStyle.primary,
        ),
      ],
    );
  }

  onPublishDatabase(context) async {
    await Provider.of<DatabaseProvider>(context, listen: false).publishDatabase();
  }
}