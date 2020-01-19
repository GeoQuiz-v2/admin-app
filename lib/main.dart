import 'dart:html' as html;

import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:geoquizadmin/env.dart';
import 'package:geoquizadmin/models/auth_notifier.dart';
import 'package:geoquizadmin/models/database_provider.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/authentication/authentication.dart';
import 'package:geoquizadmin/ui/template.dart';
import 'package:provider/provider.dart';



void main() {
  initializeApp(
    apiKey: apiKey,
    authDomain: authDomain,
    databaseURL: databaseURL,
    projectId: projectId,
    storageBucket: storageBucket,
    messagingSenderId: messagingSenderId,
    appId: appId,
  );

  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationNotifier()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider())
      ],
      child: GeoQuizApp(),
    )
  );
}


class GeoQuizApp extends StatefulWidget {
  @override
  _GeoQuizAppState createState() => _GeoQuizAppState();
}


class _GeoQuizAppState extends State<GeoQuizApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme(
          primary: AppColors.primary,
          secondary: AppColors.primary,
          primaryVariant: AppColors.primary,
          secondaryVariant: AppColors.primary,
          error: AppColors.error,
          background: Colors.white,
          onBackground: Colors.black,
          onError: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          surface: Colors.white,

          brightness: Brightness.light,
        ),
        fontFamily: "Roboto",
        textTheme: TextTheme(
          title: TextStyle(fontSize: Values.titleSize, color: AppColors.primary),
          subtitle: TextStyle(fontSize: Values.pageTitleSize, fontWeight: Values.weightBlack),
          headline: TextStyle(fontSize: Values.dialogTitleSize, fontWeight: Values.weightBold),
          body1: TextStyle(fontSize: 16)
        ),
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: TextStyle(fontSize: 12, color: AppColors.error)
        ),
        buttonTheme: ButtonThemeData(                
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Values.radius),),
          minWidth: 0
        )
      ),
      home: Consumer<AuthenticationNotifier>(

        builder: (context , provider, _) {
          return !provider.isInit || provider.user == null
            ? AuthenticationScreen()
            : Template();
        }
          
      ),
    );
  }


  //////////////////////////////////////////////////////////
  /// What follows is a hack to solve the following issue: 
  /// https://github.com/flutter/flutter/issues/32274
  /// ([web]: Blurry rendering at some resolutions #32274)
  /// To be removed when the issue is resolved !!!!
  /// Hack author : @moodstubos
  /////////////////////////////////////////////////////////
  html.MutationObserver _mutationObserver;

  @override
  initState() {
    _mutationObserver = html.MutationObserver((List<dynamic> mutations, html.MutationObserver observer) => _translateHack());

    WidgetsBinding.instance.addPostFrameCallback((_) => _translateHack());

    super.initState();
  }

  void _translateHack() async {
    List<html.Node> nodes = html.window.document.getElementsByTagName("*");

    for (html.Node node in nodes) {
      _mutationObserver.observe(node, childList: true);
      html.Element el = node as html.Element;
      if (el.style.transform.isEmpty) continue;
      if (!el.style.transform.contains("\.")) continue;
      //print(el.style.transform + " --> " + _normalizeTranslate(el.style.transform));
      el.style.transform = _normalizeTranslate(el.style.transform);
    }
  }

  String _normalizeTranslate(String value) {
    if (value.length > 12) {
      if (value.substring(0, 10) == "translate(") {
        String p = value.replaceFirst("translate(", "").replaceFirst(")", "").replaceAll("px", "");
        List<String> m = p.split(", ");
        return "translate(" + (double.parse(m[0]).toInt()).toString() + "px, " + (double.parse(m[1]).toInt()).toString() + "px)";
      } else if (value.substring(0, 12) == "translate3d(") {
        String p = value.replaceFirst("translate3d(", "").replaceFirst(")", "").replaceAll("px", "");
        List<String> m = p.split(", ");
        return "translate3d(" + (double.parse(m[0]).toInt()).toString() + "px, " + (double.parse(m[1]).toInt()).toString() + "px, " + double.parse(m[2]).toInt().toString() + "px)";
      }
    }
    return value;
  }
}
