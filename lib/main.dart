import 'package:admin/env.prod.dart';
import 'package:admin/pages/authentication/authentication.dart';
import 'package:admin/pages/authentication/authentication_provider.dart';
import 'package:admin/pages/database/database_page.dart';
import 'package:admin/utils/environment.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "env.dev.dart" if (kDebugMode) "env.prod.dart";

final Environment env = kDebugMode ? devEnv : prodEnv;

void main() {
  try {
    firebase.app();
  } catch (e) {
    firebase.initializeApp(
      apiKey: env.apiKey,
      authDomain: env.authDomain,
      databaseURL: env.databaseURL,
      projectId: env.projectId,
      storageBucket: env.storageBucket,
      messagingSenderId: env.messagingSenderId,
      appId: env.appId,
    );
  }
  
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthenticationProvider>(
        create: (context) => AuthenticationProvider()
      ),
    ],
    child: QuizAdminApp()
  ));
}

class QuizAdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        })
      ),
      home: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, __) => authProvider.user == null
          ? AuthenticationPage()
          : DatabasePage()
      ),
    );
  }
}
