import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:geoquizadmin/env.dart';
import 'package:geoquizadmin/models/auth_notifier.dart';
import 'package:geoquizadmin/models/questions_provider.dart';
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
        ChangeNotifierProvider(create: (_) => QuestionsProvider())
      ],
      child: GeoQuizApp(),
    )
  );
}

class GeoQuizApp extends StatelessWidget {
  // This widget is the root of your application.
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
}
