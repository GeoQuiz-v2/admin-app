import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final PreferredSizeWidget bottom;
  @override final Size preferredSize;

  AppAppBar({
    @required this.title,
    this.bottom
  }) : this.preferredSize = Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: this.title,
      elevation: 0,
      bottom: bottom,
    );
  }
}