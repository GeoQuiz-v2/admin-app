
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/auth_notifier.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/form_field.dart';
import 'package:geoquizadmin/ui/widget/logo.dart';
import 'package:provider/provider.dart';


class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {

  bool inProgress = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (context) => Center(
          child: Card(
            child: Container(
              padding: EdgeInsets.all(25),
              constraints: BoxConstraints(maxWidth: 350),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  
                  children: <Widget>[
                    Center(child: AppLogo(size: 25,)),
                    SizedBox(height: Values.blockSpacing),
                    RoundedTextFormField(hint: "Email", controller: _emailController,),
                    SizedBox(height: Values.normalSpacing),
                    RoundedTextFormField(hint: "Password", controller: _passwordController, password: true,),
                    FlatButton.icon(
                      label: Text("Log in"),
                      icon: Icon(Icons.done),
                      onPressed: () => onSubmit(context),
                    )
                  ],
                ),
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
      Provider.of<AuthenticationNotifier>(context, listen: false).signIn(_emailController.text, _passwordController.text)
        .whenComplete(() => setState(() => inProgress = false))
        .catchError((e) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
              elevation: 0,
            )
          );
        });
    }

  }
}