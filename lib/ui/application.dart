import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/auth_notifier.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/logo.dart';
import 'package:geoquizadmin/ui/widget/utils.dart';
import 'package:provider/provider.dart';


class ApplicationView extends StatefulWidget {

  final List<TabTemplate> tabs;

  ApplicationView({Key key, @required this.tabs}) : super(key: key);

  
  @override
  _ApplicationViewState createState() => _ApplicationViewState();
}

class _ApplicationViewState extends State<ApplicationView> {

  TabTemplate currentTab;

  @override
  void initState() {
    super.initState();
    currentTab = widget.tabs.first;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: widget.tabs.map((tab) => ListTile(
            title: tab.title,
            onTap: () {
              setState(() => currentTab = tab);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),

      appBar: MainAppBar(),
      
      body: currentTab
    );
  }
}


class TabTemplate extends StatelessWidget {
  final Widget title;
  final Widget action;
  final Widget content;

  TabTemplate({Key key, @required this.title, this.action, @required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(Values.screenMargin),
        child: ScrollConfiguration(
          behavior: BasicScrollWithoutGlow(),
          child: ListView(
            children: <Widget>[
              SizedBox(height: Values.normalSpacing,),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: Values.blockSpacing,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.subtitle,
                    child: title,
                  ),
                  if (action != null)
                    action,
                ]
              ),
              content
            ],
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
        title: AppLogo(),
        
        actions: [
          Chip(
            backgroundColor: Colors.transparent,
            label: Text(Provider.of<AuthenticationNotifier>(context).user.name),
            avatar: Icon(Icons.account_circle),
            elevation: 0,
            deleteIcon: Icon(Icons.exit_to_app, color: AppColors.error),
            deleteButtonTooltipMessage: "Sign out",
            onDeleted: () => onSignOut(context),
          ),
          SizedBox(width: Values.blockSpacing,)
        ],
      );
  }

  onSignOut(context) {
    Provider.of<AuthenticationNotifier>(context, listen: false).logout();
  }

  @override
  final Size preferredSize;
}