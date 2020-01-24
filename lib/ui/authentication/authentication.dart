import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/models/auth_notifier.dart';
import 'package:geoquizadmin/res/colors.dart';
import 'package:geoquizadmin/res/values.dart';
import 'package:geoquizadmin/ui/widget/form_field.dart';
import 'package:geoquizadmin/ui/widget/logo.dart';
import 'package:geoquizadmin/ui/widget/utils.dart';
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
          child: Container(
            padding: EdgeInsets.all(50),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Values.radius), border: Border.all(color: AppColors.divider)),
            constraints: BoxConstraints(maxWidth: 450),
            child: Form(
              key: _formKey,
              child: ScrollConfiguration(
                behavior: BasicScrollWithoutGlow(),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Center(child: AppLogo(size: 25,)),
                    SizedBox(height: Values.blockSpacing),
                    RoundedTextFormField(hint: "Email", controller: _emailController,),
                    SizedBox(height: Values.normalSpacing),
                    RoundedTextFormField(hint: "Password", controller: _passwordController, password: true,),
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
      
      ),
    );
  }

  onSubmit(context) {
    if (_formKey.currentState.validate()) {
      setState(() => inProgress = true);
      Provider.of<AuthenticationNotifier>(context, listen: false).signIn(_emailController.text, _passwordController.text)
        .then((_) => SnackBarFactory.showSuccessSnackbar(context: context, message: "Successfully logged"))
        .catchError((e) => SnackBarFactory.showErrorSnabar(context: context, message: e.toString()))
        .whenComplete(() => setState(() => inProgress = false));
    }
  }
}
