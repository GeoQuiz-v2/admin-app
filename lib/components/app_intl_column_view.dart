import 'package:admin/models/language_model.dart';
import 'package:admin/utils/intl_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppIntlColumnView extends StatelessWidget {
  final List<LanguageModel> languages;
  final IntlResource intlRes;

  AppIntlColumnView({
    Key key,
    @required this.languages,
    @required this.intlRes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: languages.map((l) => 
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText2,
            text: intlRes.resource[l.isoCode2]??"×",
            children: [
              if (intlRes.defaultLanguage == l.isoCode2 && intlRes.wikidataCode != null)
                TextSpan(
                  style: TextStyle(fontStyle: FontStyle.italic),
                  text: ' (${intlRes.wikidataCode})'
                )
            ]
          ),
        )
      ).toList(),
    );
  }
}


class AppIntlLanguagesColumn extends StatelessWidget {
  final List<LanguageModel> languages;

  AppIntlLanguagesColumn({
    Key key,
    @required this.languages,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: languages.map((l) => Text(l.isoCode2)).toList()
    );
  }
}