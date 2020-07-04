import 'package:admin/env.dart';
import 'package:admin/pages/authentication/authentication.dart';
import 'package:admin/pages/authentication/authentication_provider.dart';
import 'package:admin/pages/database/database_page.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  try {
    firebase.app();
    
  } catch (e) {
    firebase.initializeApp(
      apiKey: apiKey,
      authDomain: authDomain,
      databaseURL: databaseURL,
      projectId: projectId,
      storageBucket: storageBucket,
      messagingSenderId: messagingSenderId,
      appId: appId,
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
