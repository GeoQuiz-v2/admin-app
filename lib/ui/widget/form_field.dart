
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoquizadmin/res/colors.dart';


class RoundedTextFormField extends StatefulWidget {

  final String hint;
  final TextEditingController controller;
  final bool password;
  final String Function(String value) validator;

  RoundedTextFormField({@required this.hint, this.controller, this.password = false, this.validator});

  @override
  _RoundedTextFormFieldState createState() => _RoundedTextFormFieldState(obscure: password);
}

class _RoundedTextFormFieldState extends State<RoundedTextFormField> {

  bool obscure;

  _RoundedTextFormFieldState({this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.surface,
      ),
      child: TextFormField(
        obscureText: obscure,
        controller: widget.controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          labelText: widget.hint, 
          labelStyle: TextStyle(backgroundColor: AppColors.surface),
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          suffixIcon: !widget.password ? null : IconButton(icon: Icon(obscure ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => obscure = !obscure),)
        ),
        validator: widget.validator??((value) => value.isEmpty ? "Empty field" : null),
      ),
    );
  }
}