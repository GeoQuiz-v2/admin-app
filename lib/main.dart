import 'package:flutter/material.dart';
import 'package:geoquizadmin/models/questions_provider.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/template.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
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
      title: 'Flutter Demo',
      theme: ThemeData(
        
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
          title: TextStyle(fontSize: Values.titleSize, fontWeight: Values.weightBold, color: AppColors.primary),
          subtitle: TextStyle(fontSize: Values.pageTitleSize, fontWeight: Values.weightBlack)
        )
      ),
      home: Template(),
    );
  }
}
