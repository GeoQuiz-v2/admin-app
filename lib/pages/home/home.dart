import 'package:admin/components/app_bar.dart';
import 'package:admin/pages/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: Text("Dashboard"),
      ),
      body: Container(
        child: RaisedButton(
          child: Text("Database"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DatabasePage(),
            ));
          },
        ),
      ),
    );
  }
}