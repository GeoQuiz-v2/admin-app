import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/database_provider.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:provider/provider.dart';

class PublishDatabase extends StatefulWidget {
  @override
  _PublishDatabaseState createState() => _PublishDatabaseState();
}

class _PublishDatabaseState extends State<PublishDatabase> {
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Values.normalSpacing),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Values.radius),
        border: Border.all(color: AppColors.error)
      ),
      child: Wrap(
        spacing: Values.blockSpacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Consumer<DatabaseProvider>(builder: (context, provider, _) => Text("Current version : ${provider.currentDatabaseVersion??"unknown"}")),
          FlatButton.icon(
            icon: Icon(Icons.cloud_upload),
            label: Text("Publish database"),
            onPressed: inProgress ? null : () => onPublish(context),
          ),
        ],
      ),
    );
  }

  onPublish(context) async {
    setState(() => inProgress = true);
    await Provider.of<DatabaseProvider>(context, listen: false).publishDatabase();
    setState(() => inProgress = false);
  }
}