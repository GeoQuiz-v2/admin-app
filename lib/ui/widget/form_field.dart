
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/colors.dart';


class RoundedTextFormField extends StatelessWidget {

  final String hint;
  final TextEditingController controller;
  final bool password;

  RoundedTextFormField({@required this.hint, this.controller, this.password = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.surface,
      ),
      child: TextFormField(
        obscureText: password,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          labelText: hint, 
          labelStyle: TextStyle(backgroundColor: AppColors.surface),
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
        ),
        validator: (value) => value.isEmpty ? "Empty field" : null,
      ),
    );
  }
}