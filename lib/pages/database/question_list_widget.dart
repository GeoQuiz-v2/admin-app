import 'package:admin/components/app_button.dart';
import 'package:admin/components/app_subtitle.dart';
import 'package:flutter/widgets.dart';

class QuestionListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSubtitle(
          child: Text("Questions"),
          trailing: [
            AppButton(
              style: AppButtonStyle.ligth,
              onPressed: () {},
              child: Text("Add"),
            )
          ],
        )
      ],
    );
  }
}