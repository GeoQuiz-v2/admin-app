import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/env.dart';
import 'package:geoquizadmin/res/assets.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:url_launcher/url_launcher.dart';



class ButtonData {
  final String label;
  final String url;
  final String asset;

  ButtonData({@required this.label, @required this.url, @required this.asset});
}



class DashboardButtons extends StatelessWidget {

  final List<ButtonData> buttons = [
    ButtonData(label: "Github", url: githubURL, asset: Assets.github),
    ButtonData(label: "Firebase", url: firebaseURL, asset: Assets.firebase),
    ButtonData(label: "Play Console", url: playConsoleURL, asset: Assets.playConsole),
    ButtonData(label: "AdMob", url: adMobURL, asset: Assets.admob),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: buttons.map((b) =>
        Expanded(flex: 1, child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: _DashboardButton(data: b),
        ))
      ).toList()
    );
  }
}


class _DashboardButton extends StatelessWidget {

  final ButtonData data;

  _DashboardButton({@required this.data});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            data.asset,
            height: 24,
          ),
          SizedBox(width: 10),
          Text(data.label)
        ],
      ), 
      onPressed: () => launch(data.url),
    );
  }
}