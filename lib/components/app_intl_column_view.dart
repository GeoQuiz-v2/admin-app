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
  }) : super(key: key) {
    this.languages.sort();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText2,
            text: intlRes.defaultResource??"×",
            children: [
              if (intlRes.wikidataCode != null)
                TextSpan(
                  style: TextStyle(fontStyle: FontStyle.italic),
                  text: ' (${intlRes.wikidataCode})'
                )
            ]
          ),
        ),
        ...languages.where((l) => l.isoCode2 != IntlResource.defaultLanguage).map((l) => 
          Text(intlRes.resource[l.isoCode2]??"×")
        ).toList(),
      ]
    );
  }
}




class AppIntlLanguagesColumn extends StatelessWidget {
  final List<LanguageModel> languages;

  AppIntlLanguagesColumn({
    Key key,
    @required this.languages,
  }) : super(key: key) {
    this.languages.sort();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(IntlResource.defaultLanguage),
        ...languages.where((l) => l.isoCode2 != 'en').map((l) => Text(l.isoCode2)).toList()
      ]
    );
  }
}