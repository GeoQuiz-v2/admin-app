import 'package:admin/components/app_button.dart';
import 'package:admin/components/app_subtitle.dart';
import 'package:admin/models/theme.dart';
import 'package:flutter/widgets.dart';

class ThemesListWidget extends StatelessWidget {
  final Iterable<ThemeModel> themes;

  ThemesListWidget({
    Key key,
    @required this.themes
  }) : super(key: key);

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

              },
            )
          ],
        ),
        themes == null
        ? Text("Loading")
        : ListView(
            shrinkWrap: true,
            children: themes.map((t) => Text("t.entitled.resource.values.first")).toList()
          )
      ],
    );
  }
}