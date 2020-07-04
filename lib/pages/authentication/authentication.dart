
import 'package:admin/pages/authentication/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';


class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}


class _AuthenticationPageState extends State<AuthenticationPage> {

  bool inProgress = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: "admin@admin.admin");
  final _passwordController = TextEditingController(text: "admin.admin");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(50),
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(Values.radius), border: Border.all(color: AppColors.divider)),
            constraints: BoxConstraints(maxWidth: 450),
            child: Form(
              key: _formKey,
              child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    // Center(child: AppLogo(size: 25,)),
                    // SizedBox(height: Values.blockSpacing),
                    TextFormField(decoration: InputDecoration(hintText: "Email"), controller: _emailController,),
                    // SizedBox(height: Values.normalSpacing),
                    TextFormField(decoration: InputDecoration(hintText: "Password"), controller: _passwordController),
                    FlatButton.icon(
                      label: Text(inProgress ? "Loading..." : "Log in"),
                      icon: Icon(Icons.done),
                      onPressed: inProgress ? null : () => onSubmit(context),
                    )
                  ],
                ),
            ),
          ),
        ),
      
      ),
    );
  }

  onSubmit(context) {
    if (_formKey.currentState.validate()) {
      setState(() => inProgress = true);
      Provider.of<AuthenticationProvider>(context, listen: false).signIn(_emailController.text, _passwordController.text)
        // .then((_) => SnackBarFactory.showSuccessSnackbar(context: context, message: "Successfully logged"))
        // .catchError((e) => SnackBarFactory.showErrorSnabar(context: context, message: e.toString()))
        .whenComplete(() => setState(() => inProgress = false));
    }
  }
}