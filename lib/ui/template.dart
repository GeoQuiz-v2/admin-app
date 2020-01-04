import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/dashboard.dart';
import 'package:geoquizadmin/ui/questions.dart';
import 'package:geoquizadmin/ui/widget/utils.dart';


class Template extends StatefulWidget {

  final Map<String, Widget> pages = {
    "Questions" : QuestionsScreen(),
    "Dashboard" : DashboardScreen(),
  };

  Template({Key key}) : super(key: key);

  
  @override
  _TemplateState createState() => _TemplateState();
}

class _TemplateState extends State<Template> {

  MapEntry<String, Widget> currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget.pages.entries.first;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: widget.pages.keys.map(
            (key) => ListTile(
              title: Text(key),
              onTap: () {
                setState(() => currentPage = MapEntry(key, widget.pages[key]));
                Navigator.pop(context);
              } ,
            )
          ).toList(),
        ),
      ),

      appBar: MainAppBar(),
      body: Center(
        child: Container(
              constraints: BoxConstraints(maxWidth: 1024),
              child: ScrollConfiguration(
                behavior: BasicScrollWithoutGlow(),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: Values.normalSpacing,),
                    Text(currentPage.key, style: Theme.of(context).textTheme.subtitle,),
                    currentPage.value
                  ],
                ),
              ),
        ),
      ),
    );
  }
}





class MainAppBar extends StatelessWidget implements PreferredSizeWidget {

  MainAppBar() : preferredSize = Size.fromHeight(kToolbarHeight);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.black),
        iconTheme: IconThemeData(color: AppColors.textColorLight),
        title: RichText(
          text: TextSpan(
            text: "GeoQuiz",
            style: Theme.of(context).textTheme.title,
            children: [TextSpan(text: " Admin", style: TextStyle(color: AppColors.textColorLight))]
          ),
        ),
        actions: [Icon(Icons.account_circle)],
      );
  }

  @override
  final Size preferredSize;
}