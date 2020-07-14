import 'dart:ui';

import 'package:admin/models/model.dart';
import 'package:admin/utils/color_transformation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppModelListView<T extends Model> extends StatelessWidget {
  final List<int> weights;
  final List<Widget> labels;
  final List<Model> models;
  final List<Widget Function(T)> cellsBuilders; 

  AppModelListView({
    @required this.weights,
    @required this.labels,
    @required this.models,
    @required this.cellsBuilders
  });

  @override
  Widget build(BuildContext context) {
    var backgroundLigth = Theme.of(context).colorScheme.surface;
    var backgroundDark = ColorTransformation.darken(backgroundLigth, 0.1);
    return Column(
      children: [
        Row(
          children: List.generate(labels.length, (i) => i).map((i) => Expanded(
            flex: weights[i],
            child: labels[i],
          )).toList()
        ),
        models == null
        ? Text("Loading")
        : ListView.builder(
            shrinkWrap: true,
            itemCount: models.length,
            itemBuilder: (context, position) => Container(
              color: position % 2 == 0 ? backgroundLigth : backgroundDark,
              child: Row(
              children: List.generate(labels.length, (i) => i).map((i) => Expanded(
                flex: weights[i],
                child: cellsBuilders[i](models[position]),
              )).toList()
            )
          )
        )
      ],
    );
  }
}